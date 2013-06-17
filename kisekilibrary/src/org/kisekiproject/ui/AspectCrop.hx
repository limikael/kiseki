package org.kisekiproject.ui;

import nme.display.Sprite;
import nme.display.Bitmap;

/**
 * Aspect
 */
class AspectCrop extends Sprite {

	private var _bitmap:Bitmap;
	private var _mask:Sprite;

	/**
	 * Construct.
	 */
	public function new(b:Bitmap, w:Float, h:Float):Void {
		super();

		_bitmap=b;
		addChild(_bitmap);

		_mask=new Sprite();
		_mask.graphics.beginFill(0xff0000);
		_mask.graphics.drawRect(0,0,w,h);
		_mask.graphics.endFill();

		addChild(_mask);

		_bitmap.mask=_mask;

		var aspect:Float=w/h;
		var bitmapAspect:Float=_bitmap.width/_bitmap.height;

		var orgW:Float=_bitmap.width;
		var orgH:Float=_bitmap.height;

		if (aspect>bitmapAspect) {
			_bitmap.width=w;
			_bitmap.height=orgH*(w/orgW);
		}

		else {
			_bitmap.height=h;
			_bitmap.width=orgW*(h/orgH);
		}

		_bitmap.y=-(_bitmap.height-h)/2;
		_bitmap.x=-(_bitmap.width-w)/2;
	}
}