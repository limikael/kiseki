package org.kisekiproject.course;

import org.kisekiproject.actions.IAction;
import org.kisekiproject.evaluator.BindingExpression;
import org.kisekiproject.utils.Glob;

import nme.events.Event;
import nme.display.DisplayObject;

/**
 * Course.
 */
class Trigger implements haxe.rtti.Infos {

	private var _course:Course;

	public var action:Array<IAction>;

	public var event:String;
	public var from:String;
	public var criteria:Dynamic;

	private static var processingEventDepth:Int=0;

	/**
	 * Constructor.
	 */
	public function new() {
		action=new Array<IAction>();
		criteria=true;
	}

	/**
	 * Course.
	 */
	public function initializeCourse(value:Course):Void {
		_course=value;

		for (a in action)
			a.initializeCourse(_course);

		if (event==null)
			throw "Action needs to have event specified.";

		var g:Glob=null;

		if (from!=null)
			g=new Glob(from);

		for (name in _course.variables.getNames())
			if (from==null || g.match(name)) {
				var o:Dynamic=_course.variables.getVariable(name);

				if (Std.is(o,DisplayObject)) {
					var d:DisplayObject=o;

					//trace("adding listener to: "+d+" e: "+event);

					d.addEventListener(event,onEvent);
				}
			}

		for (a in action)
			a.initializeCourse(_course);
	}

	/**
	 * On event. Trigger.
	 */
	private function onEvent(e:Event):Void {
		//e.stopPropagation();

		_course.setEventVariable(e);

		if (criteria!=false && criteria!=0) {
			e.stopImmediatePropagation();
			trace("running trigger...");
			for (a in action)
				a.execute();
		}
	}
}