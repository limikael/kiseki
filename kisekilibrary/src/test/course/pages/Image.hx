package test.course.pages;

import nme.display.Sprite;
import nme.display.Bitmap;

/** 
 * Image.
 */
class Image extends Sprite, implements haxe.rtti.Infos {

	public var img:Bitmap;

	/**
	 * Construct.
	 */
	public function new():Void {
		super();
	}

	/**
	 * Initialize.
	 */
	public function initialize():Void {
		trace("initializing image");
		if (img!=null)
			addChild(img);
	}
}