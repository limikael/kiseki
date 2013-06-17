package org.kisekiproject.actions;

import nme.display.DisplayObject;

import org.kisekiproject.course.Course;
import org.kisekiproject.utils.Glob;
import org.kisekiproject.events.ContentEvent;

/**
 * Hide.
 */
class Hide implements IAction {

	private var _course:Course;
	public var ref:String;

	public var _displayObjects:Array<DisplayObject>;

	/**
	 * Construct.
	 */
	public function new() {
	}

	/**
	 * Initialize course.
	 */
	public function initializeCourse(c:Course) {
		_course=c;

		_displayObjects=new Array<DisplayObject>();

		var g:Glob=new Glob(ref);
		for (s in _course.variables.getNames())
			if (g.match(s) && Std.is(_course.variables.getVariable(s),DisplayObject))
				_displayObjects.push(_course.variables.getVariable(s));
	}

	/**
	 * Execute the action.
	 */
	public function execute():Void {
		for (d in _displayObjects) {
			if (d.visible==true) {
				d.visible=false;
				d.dispatchEvent(new ContentEvent(ContentEvent.HIDE));
				d.dispatchEvent(new ContentEvent(ContentEvent.CHANGE));
			}
		}
	}
}