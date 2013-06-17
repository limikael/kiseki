package org.kisekiproject.pages;

/**
 * Something with pages that can be navigated back and forth.
 */
interface IPager {

	public var pageIndex(getPageIndex,setPageIndex):Int;
	public var numPages(getNumPages,null):Int;

}