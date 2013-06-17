package pages;

import org.kisekiproject.ui.ButtonDecorator;
import org.kisekiproject.ui.SvgClipLibrary;
import org.kisekiproject.ui.SvgClip;

import nme.events.MouseEvent;
import nme.events.Event;

import nme.display.Sprite;
import nme.Assets;

/**
 * Background.
 */
class Background extends Sprite {

	public var title:String="";

	private var _clipLibray:SvgClipLibrary;
	private var _background:SvgClip;
	private var _rightButton:Sprite;
	private var _leftButton:Sprite;

	/**
	 * Construct.
	 */
	public function new():Void {
		super();

		graphics.beginFill(0xff0000);
		graphics.drawRect(0,0,100,100);
		trace("background created..");

		_clipLibray=SvgClipLibrary.parseAsset("assets/testcourse.svg");
		_background=_clipLibray.getClip("Background-main");
		addChild(_background);

		var b:ButtonDecorator;

		b=new ButtonDecorator(_clipLibray.getClip("Navigation-left"));
		b.addEventListener(MouseEvent.CLICK,onLeftClick);
		addChild(b);

		b=new ButtonDecorator(_clipLibray.getClip("Navigation-right"));
		b.addEventListener(MouseEvent.CLICK,onRightClick);
		addChild(b);
	}

	/**
	 * Initialize.
	 */
	public function initialize():Void {
		_background.firstTextField.text=title;
	}

	/**
	 * Content click.
	 */
	private function onLeftClick(e:MouseEvent):Void {
		dispatchEvent(new Event("left"));
	}

	/**
	 * Content click.
	 */
	private function onRightClick(e:MouseEvent):Void {
		dispatchEvent(new Event("right"));
	}
}