package org.kisekiproject;

import org.kisekiproject.course.CourseRunner;
import nme.display.Sprite;
import nme.Assets;

/**
 * Main app.
 */
class KisekiApp extends Sprite {

	private var _courseRunner:CourseRunner;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		_courseRunner=new CourseRunner();
		addChild(_courseRunner);
	}

	/**
	 * Run based on xml asset.
	 */
	private function runAsset(asset:String):Void {
		_courseRunner.runSrc(Assets.getText(asset));
	}

	/**
	 * Run url.
	 */
	private function runUrl(url:String):Void {
		_courseRunner.runUrl(url);
	}

	/**
	 * Add a package where to look for classes.
	 */
	private function addContentPackage(path:String):Void {
		_courseRunner.addContentPackage(path);
	}
}