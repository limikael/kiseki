package org.kisekiproject.ui;

import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;

/**
 * Horizontal slider.
 */
class HSliderDecorator extends Sprite {

	public static inline var INTERACTION_START:String="interactionStart";
	public static inline var INTERACTION_END:String="interactionEnd";

	public var knob(getKnob,null):Sprite;

	public var value(getValue,setValue):Float;
	public var min(null,setMin):Float;
	public var max(null,setMax):Float;

	private var _back:Sprite;
	private var _knob:Sprite;
	private var _downMousePos:Float;
	private var _downKnobPos:Float;
	private var _value:Float;
	private var _min:Float;
	private var _max:Float;
	private var _knobMouseOver:Bool;
	private var _knobMouseDown:Bool;

	/**
	 * Construct.
	 */
	public function new(b:Sprite, k:Sprite) {
		super();

		_back=b;
		_knob=new ButtonDecorator(k);

		_knob.x=0;
		_knob.y=_knob.y-_back.y;

		x=_back.x;
		y=_back.y;

		_back.x=0;
		_back.y=0;

		addChild(_back);
		addChild(_knob);

		_knob.addEventListener(MouseEvent.MOUSE_DOWN,onKnobMouseDown);
		_knob.addEventListener(MouseEvent.MOUSE_OVER,onKnobMouseOver);
		_knob.addEventListener(MouseEvent.MOUSE_OUT,onKnobMouseOut);

		_min=0;
		_max=1;
	}

	/**
	 * Knob over.
	 */
	private function onKnobMouseOver(e:Event):Void {
		_knobMouseOver=true;
		dispatchEvent(new Event(INTERACTION_START));
	}

	/**
	 * Knob over.
	 */
	private function onKnobMouseOut(e:Event):Void {
		_knobMouseOver=false;

		if (!_knobMouseDown)
			dispatchEvent(new Event(INTERACTION_END));
	}

	/**
	 * Knob mouse down.
	 */
	private function onKnobMouseDown(e:MouseEvent):Void {
		_knobMouseDown=true;
		_downMousePos=stage.mouseX;
		_downKnobPos=_knob.x;

		stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
		stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
	}

	/**
	 * Stage mouse up.
	 */
	private function onStageMouseUp(e:MouseEvent):Void {
		_knobMouseDown=false;
		stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);

		if (!_knobMouseOver)
			dispatchEvent(new Event(INTERACTION_END));
	}

	/**
	 * Mouse move.
	 */
	private function onStageMouseMove(e:MouseEvent):Void {
		var delta:Float=stage.mouseX-_downMousePos;

		_knob.x=_downKnobPos+delta;
		validatePos();

		dispatchEvent(new Event(Event.CHANGE));
	}

	/**
	 * Validate position.
	 */
	private function validatePos():Void {
		if (_knob.x<0)
			_knob.x=0;
			
		if (_knob.x>_back.width-_knob.width)
			_knob.x=_back.width-_knob.width;
	}

	/**
	 * Get value.
	 */
	private function getValue():Float {
		var frac:Float=_knob.x/(_back.width-_knob.width);

		return _min+(_max-_min)*frac;
	}

	/**
	 * Set value.
	 */
	private function setValue(v:Float):Float {
		//trace("setting value: "+v);
		var frac:Float=(v-_min)/(_max-_min);

		_knob.x=frac*(_back.width-_knob.width);

		return getValue();
	}

	/**
	 * Set minimum.
	 */
	public function setMin(value:Float):Float {
		//trace("setting min: "+value);
		_min=value;
		validatePos();

		return _min;
	}

	/**
	 * Set maximum.
	 */
	public function setMax(value:Float):Float {
		//trace("setting max: "+value);
		_max=value;
		validatePos();

		return _max;
	}

	/**
	 * Knob.
	 */
	private function getKnob():Sprite {
		return _knob;
	}
}