package org.kisekiproject.utils;

import nme.display.Sprite;
import nme.display.Stage;
import nme.events.Event;
import nme.Lib;

/**
 * Centers the content, scales it down if it won't fit, 
 * but doesn't scale it up.
 * Add at 0,0 on stage.
 */
class CenterContent extends Sprite {

	private var _content:Sprite;
	private var _width:Int;
	private var _height:Int;

	/**
	 * Constrcutor.
	 */
	public function new(cnt:Sprite, w:Int, h:Int):Void {
		super();

		_content=cnt;
		_width=w;
		_height=h;

		addChild(_content);

		Lib.current.stage.addEventListener(Event.RESIZE,onResize);

		updateScaling();
	}

	/**
	 * Resize.
	 */
	private function onResize(e:Event):Void {
		updateScaling();
	}

	/**
	 * Update scaling.
	 */
	private function updateScaling():Void {
		var stage:Stage=Lib.current.stage;

		if (stage.stageWidth>=_width && stage.stageHeight>=_height) {
			_content.scaleX=1;
			_content.scaleY=1;
			_content.x=Math.round(stage.stageWidth/2-_width/2);
			_content.y=Math.round(stage.stageHeight/2-_height/2);
		}
                                
		else {
			_content.x=0;
			_content.y=0;
                                
			var xScale:Float=stage.stageWidth/_width;
			var yScale:Float=stage.stageHeight/_height;
			var useScale:Float=Math.min(xScale,yScale);
                                
			//trace("scale: "+xScale+" "+yScale);
			_content.scaleX=useScale;
			_content.scaleY=useScale;

			var w:Float=_width*useScale;
			_content.x=Math.round(stage.stageWidth/2-w/2);

			var h:Float=_height*useScale;
			_content.y=Math.round(stage.stageHeight/2-h/2);
		}		
	}
}