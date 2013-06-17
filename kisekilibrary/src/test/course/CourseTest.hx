package test.course;

import org.kisekiproject.KisekiApp;

import test.course.pages.Background;
import test.course.pages.Image;

/**
 * Course test.
 */
class CourseTest extends KisekiApp {

	/**
	 * Construct.
	 */
	public function new() {
		super();

		addContentPackage("test.course.pages");

		runAsset("assets/CourseTest.xml");
	}
}