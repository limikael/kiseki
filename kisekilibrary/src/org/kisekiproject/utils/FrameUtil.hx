package org.kisekiproject.utils;

import nme.display.Sprite;
import nme.events.Event;

/**
 * Call later.
 */
class FrameUtil {

	private static var _sprite:Sprite;
	private static var _functions:Array<Void->Void>;

	/**
	 * Call at end of frame,
	 */
	public static function callLater(func:Void->Void):Void {
		if (_sprite==null) {
			_sprite=new Sprite();
			_sprite.addEventListener(Event.ENTER_FRAME,onSpriteFrame);
		}

		if (_functions==null)
			_functions=new Array<Void->Void>();

		for (f in _functions)
			if (Reflect.compareMethods(func,f))
				return;

		_functions.push(func);
	}

	/**
	 * Sprite frame.
	 */
	private static function onSpriteFrame(e:Event):Void {
		_sprite.removeEventListener(Event.ENTER_FRAME,onSpriteFrame);
		_sprite=null;

		var functions:Array<Void->Void>=_functions.copy();
		_functions=null;

		for (f in functions)
			f();
	} 
}