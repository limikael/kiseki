package org.kisekiproject.pages;

import org.kisekiproject.pages.IPager;
import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.Assets;

import org.kisekiproject.events.ContentEvent;

/**
 * Pager.
 */
class Pager extends Sprite, implements IPager, implements haxe.rtti.Infos {

	public var pageIndex(getPageIndex,setPageIndex):Int;
	public var numPages(getNumPages,null):Int;

	public var pages:Array<DisplayObject>;

	/**
	 * Construct.
	 */
	public function new() {
		super();

		pages=new Array<DisplayObject>();
	}

	/**
	 * Get num pages.
	 */
	private function getNumPages():Int {
		return pages.length;
	}

	/**
	 * Get current index.
	 */
	private function getPageIndex():Int {
		//trace("getPageIndex... "+name);
		for (i in 0...pages.length)
			if (pages[i].visible) {
				//trace(name+": getPageIndex: "+i);
				return i;
			}

		return -1;
	}

	/**
	 * Set current index.
	 */
	private function setPageIndex(v:Int):Int {
		if (v>numPages-1)
			v=numPages-1;

		if (v<0)
			v=0;

		var prevPageIndex:Int=pageIndex;

		for (i in 0...pages.length)
			if (i==v)
				setPageVisibility(pages[i],true);

			else
				setPageVisibility(pages[i],false);

		if (pageIndex!=prevPageIndex)
			dispatchEvent(new ContentEvent(ContentEvent.CHANGE));

		return getPageIndex();
	}

	/**
	 * Set visibilty.
	 */
	private function setPageVisibility(page:DisplayObject, value:Bool):Void {
		if (page.visible==value)
			return;

		page.visible=value;
		//trace("change..."+pageIndex);

		if (page.visible)
			page.dispatchEvent(new ContentEvent(ContentEvent.SHOW));

		else
			page.dispatchEvent(new ContentEvent(ContentEvent.HIDE));

		page.dispatchEvent(new ContentEvent(ContentEvent.CHANGE));
	}

	/**
	 * Initialize.
	 */
	public function initialize():Void {
		for (p in pages)
			addChild(p);

		for (i in 0...pages.length)
			if (pages[i].visible && i!=getPageIndex())
				pages[i].visible=false;
	}

	/**
	 * Get state.
	 */
	public function getState():Dynamic {
		return {
			pageIndex: getPageIndex()
		};
	}

	/**
	 * Get state.
	 */
	public function setState(state:Dynamic) {
		pageIndex=state.pageIndex;
	}
}