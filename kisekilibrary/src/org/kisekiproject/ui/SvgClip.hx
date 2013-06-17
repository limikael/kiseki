package org.kisekiproject.ui;

import format.gfx.GfxGraphics;
import format.svg.SVGData;
import format.svg.SVGRenderer;
import nme.Assets;

import nme.display.Sprite;
import nme.display.Graphics;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.geom.Matrix;
import nme.geom.Rectangle;
import nme.text.TextFormatAlign;

import format.svg.Text;
import format.svg.Group;

/**
 * Overridden version of GfxGraphics.
 */
class ClipGfxGraphics extends GfxGraphics {

	public var texts:Array<Text>;

	/**
	 * Construct.
	 */
	public function new(g:Graphics) {
		super(g);

		texts=new Array<Text>();
	}

	/**
	 * Render text.
	 */
	override public function renderText(text:Text) {
		texts.push(text);
	}
}

/**
 * Overriden version of renderer.
 */
class ClipSvgRenderer extends SVGRenderer {

	public var texts:Array<Text>;

	/**
	 * Construct.
	 */
	public function new(data:SVGData, groupId:String=null) {
		super(data);

		if (groupId!=null) {
			mRoot=findGroupRecursive(mSvg,groupId);
			if (mRoot==null)
				throw "Could not find root: "+groupId;
		}
	}

	/**
	 * Find group.
	 */
	private static function findGroupRecursive(g:Group, name:String):Group {
		if (g.name==name)
			return g;

		for (child in g.children)
			switch (child) {
				case DisplayGroup(childGroup):
					var found:Group=findGroupRecursive(childGroup,name);
					if (found!=null)
						return found;

				default:
			}

		return null;
	}

	/**
	 * Render.
	 */
	override public function render(inGfx:Graphics,?inMatrix:Matrix, ?inFilter:ObjectFilter, ?inScaleRect:Rectangle,?inScaleW:Float, ?inScaleH:Float ) {
		var clipGraphics:ClipGfxGraphics=new ClipGfxGraphics(inGfx);
		mGfx = clipGraphics;
		if (inMatrix==null)
			mMatrix = new Matrix();
		else
			mMatrix = inMatrix.clone();

		mScaleRect = inScaleRect;
		mScaleW = inScaleW;
		mScaleH = inScaleH;
		mFilter = inFilter;
		mGroupPath = [];

		iterateGroup(mRoot,inFilter==null);		
		texts=clipGraphics.texts;
	}
}

/**
 * SvgClip.
 */
class SvgClip extends Sprite {

	public var textFields(getTextFields,null):Array<TextField>;
	public var firstTextField(getFirstTextField,null):TextField;

	private var _svg:SVGData;
	private var _renderer:ClipSvgRenderer;
	private var _textFields:Array<TextField>;
	private var _groupId:String;
	private var _container:Sprite;

	/**
	 * Construct.
	 */
	public function new(svg:SVGData, groupId:String=null):Void {
		super();

		_svg=svg;
		_groupId=groupId;

		render();
	}

	/**
	 * Strip xml.
	 */
	private static function stripXml(s:String):String {
		var xml=Xml.parse("<o>"+s+"</o>");

		var res:String="";

		for (x in xml.firstChild())
			res+=x.firstChild().nodeValue;

		return res;
	}

	/**
	 * Render.
	 */
	private function render():Void {
		_container=new Sprite();
		addChild(_container);

		_textFields=new Array<TextField>();
		_renderer=new ClipSvgRenderer(_svg,_groupId);
		_renderer.render(_container.graphics);

		for (text in _renderer.texts) {
			//trace("n: "+text.name);
			var tf:TextFormat=new TextFormat();
			tf.size=text.font_size;
			tf.font=text.font_family;

			switch (text.fill) {
				case FillSolid(color):
					tf.color=color;

				case FillNone:
				case FillGrad(grad):
			}

			switch (text.text_align) {
				case "end":
					tf.align=TextFormatAlign.RIGHT;

				case "center":
					tf.align=TextFormatAlign.CENTER;

				default:
			}

			trace("align: "+text.text_align);

			var t:TextField=new TextField();
			t.name=text.name;
			t.selectable=false;
			t.defaultTextFormat=tf;
			t.text=stripXml(text.text);

			//trace("w: "+t.textWidth+" m: "+t.getLineMetrics(0).width);

			t.width=t.textWidth+20;
			t.height=100;

			t.wordWrap=true;

			var m:Matrix=new Matrix();
			m.identity();
			m.concat(text.matrix);

			switch (text.text_align) {
				case "end":
					m.translate(text.x-t.width,text.y-text.font_size);

				case "center":
					m.translate(text.x-t.width/2,text.y-text.font_size);

				default:
					m.translate(text.x,text.y-text.font_size);
			}

			t.transform.matrix=m;
			_container.addChild(t);

			_textFields.push(t);
		}

		var rect:Rectangle=_container.getRect(this);

		_container.x=-rect.x;
		_container.y=-rect.y;

		x=rect.x;
		y=rect.y;
	}

	/**
	 * Parse text.
	 */
	public static function parse(s:String, groupId:String=null):SvgClip {
		var xml:Xml=Xml.parse(s);
		var svg:SVGData=new SVGData(xml);

		return new SvgClip(svg,groupId);
	}

	/**
	 * Get textfields.
	 */
	private function getTextFields():Array<TextField> {
		return _textFields;
	}

	/**
	 * Get first textfield.
	 */
	private function getFirstTextField():TextField {
		return _textFields[0];
	}

	/**
	 * Get textfield by name.
	 */
	public function getTextFieldByName(name:String):TextField {
		//trace("getting by name:"+name);

		for (t in _textFields) {
			//trace("tname: "+t.name);
			if (t.name==name)
				return t;
		}

		return null;
	}
}