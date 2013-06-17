package org.kisekiproject.splash;

import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Matrix;
import nme.display.GradientType;
import nme.display.Graphics;

/**
 * Loading splash.
 */
class LoadingSplash extends NMEPreloader {

	private var _spinner:Sprite;
	private var _bg:Sprite;
	private var _progress:Float=0;

	/** 
	 * Construct.
	 */
	public function new() {
		super();

		_bg=new Sprite();
		addChild(_bg);

		_spinner=new Sprite();
		addChild(_spinner);

		addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		_progress=0;
	}

	/**
	 * Added to stage.
	 */
	private function onAddedToStage(e:Event):Void {
		stage.addEventListener(Event.RESIZE,onStageResize);
		updateSize();
	}

	/**
	 * Stage resize.
	 */
	private function onStageResize(e:Event):Void {
		if (stage!=null)
			updateSize();
	}

	/**
	 * Stage resize.
	 */
	private function updateSize():Void {
		var g:Graphics=_bg.graphics;

		g.clear();

		var m:Matrix=new Matrix();
		m.createGradientBox(stage.stageWidth,stage.stageHeight,90);

		g.beginGradientFill(GradientType.LINEAR,
			[0x422e1f,0x56220f],[1,1],[0,255],
			m);
		g.drawRect(0,0,stage.stageWidth,stage.stageHeight);
		g.endFill();

		drawSpinner();
	}

	/**
	 * Draw spinner.
	 */
	private function drawSpinner():Void {
		if (stage==null)
			return;

		_spinner.x=stage.stageWidth/2;
		_spinner.y=stage.stageHeight/2;

		var g:Graphics=_spinner.graphics;

		g.clear();
		g.lineStyle(2,0xffffff);

		var lines:Int=32;
		for (i in 0...lines) {
			if (i/lines<=_progress) {
				g.moveTo(30*Math.sin(i*2*Math.PI/lines),-30*Math.cos(i*2*Math.PI/lines));
				g.lineTo(40*Math.sin(i*2*Math.PI/lines),-40*Math.cos(i*2*Math.PI/lines));
			}
		}
	}

	/**
	 * Loading update.
	 */
	override public function onUpdate(bytesLoaded:Int, bytesTotal:Int):Void {
		var percentLoaded:Float=bytesLoaded/bytesTotal;

		if (percentLoaded>1)
			percentLoaded==1;

		_progress=percentLoaded/4;
		drawSpinner();
	}

	/**
	 * Init progress.
	 */
	public function initProgress(value:Float):Void {
		if (value>1)
			value=1;

		_progress=.25+.75*value;
		drawSpinner();
	}
}