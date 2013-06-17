package org.kisekiproject.course;

import nme.display.DisplayObject;
import nme.display.Sprite;
import org.kisekiproject.actions.IAction;
import org.kisekiproject.evaluator.IVariableNamespace;
import org.kisekiproject.evaluator.VariableStore;
import org.kisekiproject.course.CourseRunner;
import org.kisekiproject.events.ContentEvent;
import org.kisekiproject.appmarkup.MarkupContext;
import org.kisekiproject.persistence.IPersister;
import org.kisekiproject.utils.ArrayTools;
import org.kisekiproject.utils.FrameUtil;
import org.kisekiproject.persistence.PersistenceState;

import haxe.Json;

/**
 * Course.
 */
class Course implements haxe.rtti.Infos {

	public var variables(getVariables,null):IVariableNamespace;

	private var _runner:CourseRunner;

	public var displayObject(default,null):Sprite;

	public var content:Array<DisplayObject>;
	public var triggers:Array<Trigger>;
	public var init:Array<IAction>;
	public var declarations:Array<Dynamic>;
	public var width:Int;
	public var height:Int;
	public var complete:Bool;
	public var score:Int;

	private var _persister:IPersister;
	private var _lastState:PersistenceState;
	//public var persistence:IPersister;

	/**
	 * Constructor.
	 */
	public function new() {
		content=new Array<DisplayObject>();
		triggers=new Array<Trigger>();
		init=new Array<IAction>();
		declarations=new Array<Dynamic>();

		width=800;
		height=600;
		complete=false;
		score=0;

		trace("course created..");
		displayObject=new Sprite();
	}

	/**
	 * Initialize context.
	 */
	public function initializeRunner(value:CourseRunner):Void {
		_runner=value;
		_runner.variables.onContentStateChange.addListener(onCourseContentStateChange);

		for (t in triggers)
			t.initializeCourse(this);

		for (a in init)
			a.initializeCourse(this);
	}

	/**
	 * Get variable.
	 */
	private function getVariables():IVariableNamespace {
		return _runner.variables;
	}

	/**
	 * Set event variable.
	 */
	public function setEventVariable(v:Dynamic):Void {
		_runner.variables.setVariable("event",v);
	}

	/**
	 * Get persistence state.
	 */
	public function getPersistenceState():PersistenceState {
		var state:Dynamic={};

		state.v=[];

		for (c in content)
			if (c.visible)
				state.v.push(c.name);

		state.s={};

		for (name in variables.getNames()) {
			var v:Dynamic=variables.getVariable(name);

			if (Reflect.hasField(v,"getState"))
				Reflect.setField(state.s,name,v.getState());
		}

		var persistenceState:PersistenceState=new PersistenceState();
		persistenceState.data=state;
		persistenceState.score=score;
		persistenceState.complete=complete;

		return persistenceState;
	}

	/**
	 * Restore state.
	 */
	private function restoreState(persistenceState:PersistenceState):Void {
		var state:Dynamic=persistenceState.data;

		for (c in content)
			if (ArrayTools.contains(state.v,c.name))
				c.visible=true;

			else
				c.visible=false;

		for (name in variables.getNames()) {
			var v:Dynamic=variables.getVariable(name);

			//trace("name: "+name);

			if (Reflect.field(state.s,name)!=null)
				if (Reflect.hasField(v,"setState")) {
					//trace("restoring state for: "+name);

					v.setState(Reflect.field(state.s,name));

					if (Std.is(v,DisplayObject)) {
						v.dispatchEvent(new ContentEvent(ContentEvent.CHANGE));
					}
				}
		}
	}

	/**
	 * Set persister.
	 */
	public function setPersister(persister:IPersister):Void {
		_persister=persister;
	}

	/**
	 * Run course.
	 */
	public function run():Void {
		for (c in content)
			displayObject.addChild(c);

		var state:PersistenceState=null;

		if (_persister!=null)
			state=_persister.load();

		if (state!=null) {
			trace("**** RESTORING: "+state.data);
			//trace("state: "+state);
			restoreState(state);

			_lastState=state;
		}

		else {
			for (c in content)
				c.visible=true;

			for (a in init)
				a.execute();

			_lastState=getPersistenceState();
		}
	}

	/**
	 * Content state changed.
	 */
	private function onCourseContentStateChange():Void {
		save();
	}

	/**
	 * Save.
	 */
	public function save():Void {
		//trace("save called...");
		FrameUtil.callLater(doSave);
	}

	/**
	 * Save at end to frame.
	 */
	private function doSave():Void {
		if (_persister!=null) {
			var state:PersistenceState=getPersistenceState();

			if (!state.equals(_lastState)) {
				trace("**** SAVING: "+state.data);
				_persister.save(state);
				_lastState=state;
			}
		}
	}
}