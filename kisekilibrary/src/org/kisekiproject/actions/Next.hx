package org.kisekiproject.actions;

import org.kisekiproject.course.Course;
import org.kisekiproject.pages.IPager;

/**
 * Hide.
 */
class Next implements IAction {

	public var ref:String;

	private var _course:Course;
	private var _pager:IPager;

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

		_pager=_course.variables.getVariable(ref);
	}

	/**
	 * Execute the action.
	 */
	public function execute():Void {
		var c:Int=_pager.pageIndex+1;

		if (c>_pager.numPages-1)
			c=_pager.numPages-1;

		_pager.pageIndex=c;
	}
}