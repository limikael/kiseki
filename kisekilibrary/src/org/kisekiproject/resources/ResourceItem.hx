package org.kisekiproject.resources;

import nme.display.Loader;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.display.PixelSnapping;
import nme.events.Event;
import nme.events.ErrorEvent;
import nme.events.IOErrorEvent;
import nme.events.SecurityErrorEvent;
import nme.events.ProgressEvent;
import nme.net.URLRequest;
import nme.media.Sound;
import org.kisekiproject.signals.Signal;
import org.kisekiproject.utils.FileUtil;
import haxe.io.Bytes;

/**
 * Resource item.
 */
class ResourceItem {

	public var loaded(getLoaded,null):Bool;

	public var onError(default,null):Signal<String>;
	public var onLoaded(default,null):Signal<Void>;
	public var onProgress(default,null):Signal<Float>;

	private var _loader:Loader;
	private var _sound:Sound;
	private var _url:String;
	private var _bitmapData:BitmapData;
	private var _loaded:Bool;

	/**
	 * Construct.
	 */
	public function new(url:String):Void {
		onError=new Signal<String>();
		onLoaded=new Signal<Void>();
		onProgress=new Signal<Float>();

		_url=url;
		_loaded=false;
	}

	/**
	 * Loaded?
	 */
	public function getLoaded():Bool {
		return _loaded;
	}

	/**
	 * Load.
	 */
	public function load():Void {
		var req:URLRequest=new URLRequest(_url);

		trace("loading item: "+_url);

		switch (FileUtil.getFileExtension(_url)) {
			case "jpg", "jpeg", "gif", "png":
				trace("yep loading: "+_url);
				_loader=new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onItemLoaded);
				_loader.addEventListener(IOErrorEvent.IO_ERROR,onItemError);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onItemError);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onItemError);
				_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onItemError);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onItemProgress);
				_loader.load(req);

			case "mp3":
				_sound=new Sound();
				_sound.addEventListener(ProgressEvent.PROGRESS,onItemProgress);
				_sound.addEventListener(Event.COMPLETE,onItemLoaded);
				_sound.addEventListener(IOErrorEvent.IO_ERROR,onItemError);
				_sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onItemError);
				_sound.load(req);

			default:
				throw "Don't know how to load: "+FileUtil.getFileExtension(_url);
		}
	}

	/**
	 * Progress event.
	 */
	private function onItemProgress(e:ProgressEvent):Void {
		if (e.bytesTotal>0)
			onProgress.dispatch(e.bytesLoaded/e.bytesTotal);
	}

	/**
	 * Item loaded.
	 */
	private function onItemLoaded(e:Event):Void {
		trace("item loaded in ResourceItem");

		_loaded=true;

		if (_loader!=null) {
			_bitmapData=new BitmapData(Math.ceil(_loader.width),Math.ceil(_loader.height),true);
			_bitmapData.draw(_loader);
		}

		onLoaded.dispatch();
	}

	/**
	 * Item error.
	 */
	private function onItemError(e:ErrorEvent):Void {
		onError.dispatch(e.text);
	}

	/**
	 * Get bitmap data.
	 */
	public function getBitmapData():BitmapData {
		if (_bitmapData==null)
			throw "Resource is not a bitmap.";
		return _bitmapData;
	}

	/**
	 * Get bitmap.
	 */
	public function getBitmap():Bitmap {
		return new Bitmap(getBitmapData(),PixelSnapping.AUTO,true);
	}

	/**
	 * Get bytes.
	 */
	public function getBytes():Bytes {
		return null;
	}

	/**
	 * Get sound.
	 */
	public function getSound():Sound {
		if (_sound==null)
			throw "Resource is not a sound.";

		return _sound;
	}
}