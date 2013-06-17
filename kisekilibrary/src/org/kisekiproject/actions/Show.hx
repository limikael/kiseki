package org.kisekiproject.actions;

import nme.display.DisplayObject;

import org.kisekiproject.course.Course;
import org.kisekiproject.utils.Glob;
import org.kisekiproject.events.ContentEvent;

/**
 * Hide.
 */
class Show implements IAction {

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
			if (g.match(s))
				_displayObjects.push(_course.variables.getVariable(s));
	}

	/**
	 * Execute the action.
	 */
	public function execute():Void {
		for (d in _displayObjects) {
			if (!d.visible) {
				d.visible=true;

				trace("showing: "+d.name);
				d.dispatchEvent(new ContentEvent(ContentEvent.SHOW));
				d.dispatchEvent(new ContentEvent(ContentEvent.CHANGE));
			}
		}
	}
}