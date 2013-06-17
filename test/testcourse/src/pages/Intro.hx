package pages;

import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.Assets;

/**
 * Intro page.
 */
class Intro extends Sprite, implements haxe.rtti.Infos {

	public var header:String;
	public var content:String;

	private var _headerField:TextField;
	private var _contentField:TextField;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		header="";
		content="";
	}

	/**
	 * Initialize.
	 */
	public function initialize() {
		trace("initializing intro, header="+header+" content="+content);
		var tf:TextFormat;

		_headerField=new TextField();
		tf=new TextFormat();
		tf.size=36;
		_headerField.defaultTextFormat=tf;
		_headerField.x=200;
		_headerField.y=140;
		_headerField.width=500;
		_headerField.text=header;
		_headerField.selectable=false;
		addChild(_headerField);

		_contentField=new TextField();
		tf=new TextFormat();
		tf.size=20;
		_contentField.defaultTextFormat=tf;
		_contentField.selectable=false;
		_contentField.x=200;
		_contentField.y=200;
		_contentField.width=500;
		_contentField.height=400;
		_contentField.text=content;
		addChild(_contentField);
	}
}