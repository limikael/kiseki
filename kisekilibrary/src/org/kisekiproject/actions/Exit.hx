package org.kisekiproject.actions;

import org.kisekiproject.course.Course;
import org.kisekiproject.pages.IPager;

/**
 * Exit.
 */
class Exit implements IAction {

	private var _course:Course;

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
	}

	/**
	 * Execute the action.
	 */
	public function execute():Void {
		_course.exit();
	}
}