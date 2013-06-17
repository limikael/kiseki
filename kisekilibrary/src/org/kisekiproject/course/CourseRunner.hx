package org.kisekiproject.course;

import nme.display.Sprite;
import nme.display.DisplayObjectContainer;
import nme.net.URLLoader;
import nme.net.URLRequest;

import org.kisekiproject.utils.LogWindow;
import org.kisekiproject.appmarkup.MarkupContext;
import org.kisekiproject.course.Course;
import org.kisekiproject.utils.CenterContent;
import org.kisekiproject.evaluator.VariableStore;
import org.kisekiproject.evaluator.ExpressionError;
import org.kisekiproject.evaluator.IVariableNamespace;
import org.kisekiproject.splash.LoadingSplash;

import org.kisekiproject.persistence.SharedObjectPersister;
import org.kisekiproject.persistence.ScormPersister;

import org.kisekiproject.actions.First;
import org.kisekiproject.actions.Last;
import org.kisekiproject.actions.Next;
import org.kisekiproject.actions.Prev;
import org.kisekiproject.actions.Hide;
import org.kisekiproject.actions.Show;
import org.kisekiproject.actions.Goto;
import org.kisekiproject.actions.Save;
import org.kisekiproject.actions.Exit;

import org.kisekiproject.pages.Pager;

import nme.events.Event;
import nme.events.ErrorEvent;
import nme.events.IOErrorEvent;
import nme.events.SecurityErrorEvent;
import nme.Lib;

/**
 * Course.
 */
class CourseRunner extends Sprite {

	public var markupContext(getMarkupContext,null):MarkupContext;
	public var variables(getVariables,null):CourseVariableStore;

	private var _markupContext:MarkupContext;
	private var _contentPackages:Array<String>;
	private var _course:Course;
	private var _variables:CourseVariableStore;
	private var _urlLoader:URLLoader;

	private var _loadingSplash:LoadingSplash;

	/**
	 * Construct.
	 */
	public function new() {
		LogWindow.getInstance();

		super();

		addChild(LogWindow.getInstance());

		_loadingSplash=new LoadingSplash();
		_loadingSplash.initProgress(0);
		addChild(_loadingSplash);

		var p:DisplayObjectContainer=LogWindow.instance.parent;
		p.setChildIndex(LogWindow.instance,p.numChildren-1);

		_variables=new CourseVariableStore();
		_variables.setVariable("event",{"type":"none"});
		_markupContext=new MarkupContext(_variables);
		_markupContext.constructorFunc=createMarkupInstance;
		_markupContext.onError.addListener(onMarkupError);

		_contentPackages=new Array<String>();

		trace("CourseRunner created.");
	}

	/**
	 * Get markup context.
	 */
	private function getVariables():CourseVariableStore {
		return _variables;
	}

	/**
	 * Get markup context.
	 */
	private function getMarkupContext():MarkupContext {
		return _markupContext;
	}

	/**
	 * Add content package.
	 */
	public function addContentPackage(p:String):Void {
		_contentPackages.push(p);
	}

	/**
	 * Create markup instance.
	 */
	private function createMarkupInstance(className:String):Dynamic {
		var c:Class<Dynamic>=null;

		switch (className) {
			case "Pager":
				c=Type.resolveClass("org.kisekiproject.pages."+className);
				return Type.createInstance(c,[]);

			case "Course", "Trigger":
				c=Type.resolveClass("org.kisekiproject.course."+className);
				return Type.createInstance(c,[]);

			case "Next", "Prev", "Show", "Hide", "First", "Last", "Goto", "Save", "Exit":
				//trace("creating: "+className);
				c=Type.resolveClass("org.kisekiproject.actions."+className);
				return Type.createInstance(c,[]);

			/*case "SharedObjectPersister", "ScormPersister":
				c=Type.resolveClass("org.kisekiproject.persistence."+className);
				return Type.createInstance(c,[]);*/
		}

		c=Type.resolveClass(className);
		if (c!=null)
			return Type.createInstance(c,[]);

		for (p in _contentPackages) {
			c=Type.resolveClass(p+"."+className);
			if (c!=null)
				return Type.createInstance(c,[]);
		}

		return null;
	}

	/**
	 * Run from source.
	 */
	public function runSrc(src:String):Void {
		trace("Running from source: "+(src!=null));
		parse(src);
	}

	/**
	 * Run url.
	 */
	public function runUrl(url):Void {
		url+="?t="+Math.round(Math.random()*1000000);
		trace("Running from url: "+url);
		_urlLoader=new URLLoader(new URLRequest(url));
		_urlLoader.addEventListener(Event.COMPLETE,onUrlLoaded);
		_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onUrlError);
		_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onUrlError);
	}

	/**
	 * Url loaded.
	 */
	private function onUrlLoaded(e:Event):Void {
		trace("url loaded");
		runSrc(_urlLoader.data);
	}

	/**
	 * Url error.
	 */
	private function onUrlError(e:ErrorEvent):Void {
		trace("url error: "+e.text);
	}

	/**
	 * Parse xml.
	 */
	private function parse(src:String):Void {
		try {
			_markupContext.onComplete.addListener(onMarkupComplete);
			_markupContext.onProgress.addListener(onMarkupProgress);
			//_markupContext.onError.addListener(onMarkupError);
			_markupContext.parse(src);
		}

		catch (s:String) {
			LogWindow.show();
			trace("Error: "+s);
			return;
		}

		catch (e:ExpressionError) {
			LogWindow.show();
			trace("Expression error: "+e.message);
			trace(e.source);

			var s:String="";
			for (i in 0...e.pos)
				s+=".";
			s+="^";
			trace(s);
		}

		catch (s:Dynamic) {
			LogWindow.show();
			trace("Dynamic Error: "+s);
			trace(s.getStackTrace());
			return;
		}
	}

	/**
	 * Markup error.
	 */
	/*private function onMarkupError(msg:String):Void {
		LogWindow.show();
		trace("Error loading course: "+msg);
	}*/

	/**
	 * Markup progress.
	 */
	private function onMarkupProgress(p:Float):Void {
		_loadingSplash.initProgress(p);
	}

	/**
	 * Markup resources loaded.
	 */
	private function onMarkupComplete():Void {
		_course=cast _markupContext.root;

		trace("CourseRunner: resources loaded, running course...");

		_course.initializeRunner(this); //initializeVariables(_variables);

		removeChild(_loadingSplash);

		var centerContent:CenterContent=new CenterContent(_course.displayObject,_course.width,_course.height);
		addChild(centerContent);

		var p:DisplayObjectContainer=LogWindow.instance.parent;
		p.setChildIndex(LogWindow.instance,p.numChildren-1);

		switch (Lib.current.loaderInfo.parameters.persistence) {
			case "so":
				trace("**** using SO persistence ****");
				_course.setPersister(new SharedObjectPersister());

			case "scorm":
				trace("**** using SCORM persistence ****");
				_course.setPersister(new ScormPersister());

			case null:
				trace("**** not using persistence ****");

			default:
				throw "unknonw persistence type";
		}

		_course.run();
	}

	/**
	 * Markup error.
	 */
	private function onMarkupError(s:String):Void {
		trace("error in markup: "+s);
		LogWindow.show();
	}
}