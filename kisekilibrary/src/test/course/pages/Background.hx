package test.course.pages;

import nme.display.Sprite;
import nme.text.TextField;

/**
 * Background.
 */
class Background extends Sprite {

	/**
	 * Construct.
	 */
	public function new() {
		super();

		var tf:TextField=new TextField();
		tf.text="This is the background";
		addChild(tf);
	}

}