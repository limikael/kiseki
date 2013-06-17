package org.kisekiproject.ui;

import nme.geom.ColorTransform;
import nme.display.Sprite;
import nme.events.MouseEvent;

/**
 * Button decorator.
 */
class ButtonDecorator extends Sprite {

	public var enabled(getEnabled,setEnabled):Bool;

	private var _content:Sprite;

	/**
	 * Button decorator.
	 */
	public function new(content:Sprite) {
		super();

		_content=content;

		x=_content.x;
		y=_content.y;

		_content.x=0;
		_content.y=0;

		addChild(_content);

		_content.useHandCursor=true;
		_content.mouseEnabled=true;
		_content.mouseChildren=false;
		_content.buttonMode=true;

		_content.addEventListener(MouseEvent.MOUSE_OVER,onContentMouseOver);
		_content.addEventListener(MouseEvent.MOUSE_OUT,onContentMouseOut);
		_content.addEventListener(MouseEvent.MOUSE_DOWN,onContentMouseDown);
		_content.addEventListener(MouseEvent.MOUSE_UP,onContentMouseUp);

		_content.addEventListener(MouseEvent.CLICK,onContentClick);
	}

	/**
	 * Content mouse over.
	 */
	private function onContentMouseOver(e:MouseEvent):Void {
		_content.transform.colorTransform=new ColorTransform(1.25,1.25,1.25,1, 0,0,0,0);
	}

	/**
	 * Content mouse out.
	 */
	private function onContentMouseOut(e:MouseEvent):Void {
		_content.transform.colorTransform=new ColorTransform(1,1,1,1, 0,0,0,0);
	}

	/**
	 * Content mouse down.
	 */
	private function onContentMouseDown(e:MouseEvent):Void {
		_content.transform.colorTransform=new ColorTransform(.75,.75,.75,1, 0,0,0,0);
	}

	/**
	 * Content mouse up.
	 */
	private function onContentMouseUp(e:MouseEvent):Void {
		_content.transform.colorTransform=new ColorTransform(1.25,1.25,1.25,1, 0,0,0,0);
	}

	/**
	 * Content click.
	 */
	private function onContentClick(e:MouseEvent):Void {
		e.stopPropagation();
		dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}

	/**
	 * Enabled?
	 */
	private function getEnabled():Bool {
		return _content.buttonMode;
	}

	/**
	 * Enabled.
	 */
	private function setEnabled(v:Bool):Bool {
		if (v) {
			_content.useHandCursor=true;
			_content.mouseEnabled=true;
			_content.buttonMode=true;
			_content.alpha=1;
		}

		else {
			mouseEnabled=false;
			_content.useHandCursor=false;
			_content.mouseEnabled=false;
			_content.buttonMode=false;
			_content.alpha=.5;
		}

		return getEnabled();
	}
}