package org.kisekiproject.resources;

import org.kisekiproject.signals.Signal;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.media.Sound;
import haxe.io.Bytes;

/**
 * Resource loader.
 */
class ResourceLoader {

	public var onComplete(default,null):Signal<Void>;
	public var onError(default,null):Signal<String>;
	public var onProgress(default,null):Signal<Float>;
	private var _items:Array<ResourceItem>;
	private var _itemsByUrl:Hash<ResourceItem>;

	/**
	 * Construct.
	 */
	public function new() {
		onComplete=new Signal<Void>();
		onError=new Signal<String>();
		onProgress=new Signal<Float>();
		_items=new Array<ResourceItem>();
		_itemsByUrl=new Hash<ResourceItem>();
	}

	/**
	 * Add item.
	 */
	public function addItem(url:String):Void {
		if (_itemsByUrl.get(url)!=null)
			return;

		var item:ResourceItem=new ResourceItem(url);

		item.onLoaded.addListener(onItemLoaded);
		item.onError.addListener(onItemError);
		item.onProgress.addListener(onItemProgress);

		_items.push(item);
		_itemsByUrl.set(url,item);
	}

	/**
	 * Load.
	 */
	public function load() {
		loadNext();
	}

	/**
	 * Number of complete items.
	 */
	private function getNumComplete():Int {
		var r:Int=0;

		for (item in _items)
			if (item.loaded)
				r++;

		return r;
	}

	/**
	 * Load next item.
	 */
	private function loadNext() {
		for (item in _items) {
			if (!item.loaded) {
				onProgress.dispatch(getNumComplete()/_items.length);
				item.load();
				return;
			}
		}

		onProgress.dispatch(1);
		trace("ResourceLoader complete...");
		onComplete.dispatch();
	}

	/**
	 * Item progress.
	 */
	private function onItemProgress(p:Float):Void {
		var r:Float=getNumComplete()/_items.length;
		r+=p/_items.length;

		onProgress.dispatch(r);
	}

	/**
	 * Item error.
	 */
	private function onItemError(s:String):Void {
		trace("ResourceLoader: error loading item: "+s);
		onError.dispatch(s);
	}

	/**
	 * Item loaded.
	 */
	private function onItemLoaded():Void {
		trace("ResourceLoader: one item loaded");
		loadNext();
	}

	/**
	 * Get bitmap data.
	 */
	public function getBitmapData(url:String):BitmapData {
		return _itemsByUrl.get(url).getBitmapData();
	}

	/**
	 * Get Bitmap.
	 */
	public function getBitmap(url:String):Bitmap {
		return _itemsByUrl.get(url).getBitmap();
	}

	/**
	 * Get Xml.
	 */
	public function getBytes(url:String):Bytes {
		return _itemsByUrl.get(url).getBytes();
	}

	/**
	 * Get sound.
	 */
	public function getSound(url:String):Sound {
		return _itemsByUrl.get(url).getSound();
	}
}