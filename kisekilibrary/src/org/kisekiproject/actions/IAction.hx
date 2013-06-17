package org.kisekiproject.actions;

import org.kisekiproject.course.Course;

/**
 * Action.
 */
interface IAction {

	function initializeCourse(c:Course):Void;

	function execute():Void;

}