package org.kisekiproject.utils;
	
/**
 * Glob.
 */
class Glob {

	private var _regExp:EReg;

	/**
	 * Constructor
	 */
	public function new(pattern:String) {
		var s:String;

		s=StringTools.replace(pattern,"*",".*");

		_regExp=new EReg("^"+s+"$","");
	}

	/**
	 * Match against a string.
	 */
	public function match(s:String):Bool {
		return _regExp.match(s);
	}
}