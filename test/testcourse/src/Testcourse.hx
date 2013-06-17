package;

import nme.display.Sprite;

import org.kisekiproject.KisekiApp;

import pages.Background;
import pages.Intro;

/**
 * Democourse.
 */
class Testcourse extends KisekiApp {

	/**
	 * Construct.
	 */
	public function new() {
		super();

		addContentPackage("pages");
		runAsset("assets/testcourse.xml");
	}
}