package org.kisekiproject.utils;

import nme.text.TextField;
import nme.text.TextFormat;
import nme.filters.DropShadowFilter;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.ui.Keyboard;
import nme.Lib;

import nme.system.Capabilities;
import nme.system.System;

/**
 * Link button.
 */
class LinkButton extends Sprite {

        public var label(null,setLabel):String;

        private var _labelField:TextField;

        /**
         * Constructor.
         */
        public function new(l:String):Void {
                super();

                var tf:TextFormat=new TextFormat();
                tf.bold=true;

                _labelField=new TextField();
                _labelField.textColor=0xc0c0ff;
                _labelField.selectable=false;
                _labelField.defaultTextFormat=tf;
                _labelField.text=l;
                _labelField.width=_labelField.textWidth+5;
                _labelField.height=_labelField.textHeight+5;
                addChild(_labelField);

                var df:DropShadowFilter=new DropShadowFilter();
#if flash
                df.distance=0;
#end
                filters=[df];

                buttonMode=true;
                mouseChildren=false;
        }

        /**
         * Set label.
         */
        private function setLabel(s:String):String {
                _labelField.text=s;
                return s;
        }
}

/**
 * Log window.
 */
class LogWindow extends Sprite {

	public static var instance(getInstance,null):LogWindow;

	private static var _instance:LogWindow=null;

	private var _textField:TextField;
	private var _bg:Sprite;
	private var _copyLogButton:LinkButton;
	private var _clearLogButton:LinkButton;

	/**
	 * Constructor.
	 */
	public function new() {
		super();

		_bg=new Sprite();
		_bg.graphics.beginFill(0x000000,.5);
		_bg.graphics.drawRect(0,0,100,100);
		_bg.graphics.endFill();
		_bg.x=10;
		_bg.y=10;
		addChild(_bg);

		_textField=new TextField();
		_textField.x=20;
		_textField.y=20;
		_textField.wordWrap=true;
		_textField.textColor=0xffffff;
		addChild(_textField);
		haxe.Log.trace=tracer;

		addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		Lib.current.stage.addEventListener(Event.RESIZE,onStageResize);
		visible=false;

		_copyLogButton=new LinkButton("Copy log to clipboard");
		_copyLogButton.addEventListener(MouseEvent.CLICK,onCopyLogButtonClick);
		addChild(_copyLogButton);

		_clearLogButton=new LinkButton("Clear");
		_clearLogButton.addEventListener(MouseEvent.CLICK,onClearLogButtonClick);
		addChild(_clearLogButton);
	}

	/**
	 * Clear log.
	 */
	private function onClearLogButtonClick(e:MouseEvent):Void {
		_textField.text="";
		_textField.scrollV=_textField.maxScrollV;
	}

	/**
	 * Copy log.
	 */
	private function onCopyLogButtonClick(e:MouseEvent):Void {
		System.setClipboard(_textField.text);
		trace("Log copied: "+Date.now().toString());
	}

	/**
	 * Update size.
	 */
	private function updateSize():Void {
		_bg.width=stage.stageWidth-20;
		_bg.height=stage.stageHeight-20;
		_textField.width=stage.stageWidth-40;
		_textField.height=stage.stageHeight-40;

#if flash
		_textField.scrollV=_textField.maxScrollV;
#end
		_copyLogButton.y=20;
		_copyLogButton.x=stage.stageWidth-20-_copyLogButton.width;

		_clearLogButton.y=40;
		_clearLogButton.x=stage.stageWidth-20-_clearLogButton.width;
	}

	/**
	 * Stage resize.
	 */
	private function onStageResize(e:Event):Void {
		updateSize();
	}

	/**
	 * Added to stage.
	 */
	private function onAddedToStage(e:Event):Void {
		updateSize();
	}

	/**
	 * Trace.
	 */
	private function tracer(v:Dynamic, ?inf:haxe.PosInfos) {
		_textField.text+=v+"\n";

#if flash
		_textField.scrollV=_textField.maxScrollV;
#end
	}

	/**
	 * Key down.
	 */
	private function onKeyDown(e:KeyboardEvent):Void {
		switch (e.keyCode) {
			case Keyboard.ESCAPE:
				if (visible) {
					visible=false;
				}

				else {
					if (e.shiftKey || e.altKey || e.ctrlKey)
						visible=true;
				}
		}
	}

	/**
	 * Get instance.
	 */
	public static function getInstance():LogWindow {
		if (_instance==null)
			_instance=new LogWindow();

		return _instance;
	}

	/**
	 * Show.
	 */
	public static function show():Void {
		if (instance.stage==null)
			Lib.current.addChild(instance);

		instance.visible=true;
	}
}
