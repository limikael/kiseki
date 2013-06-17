package org.kisekiproject.actions;

import org.kisekiproject.course.Course;

/**
 * Prev.
 */
class Save implements IAction {

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
		_course.save();
	}
}