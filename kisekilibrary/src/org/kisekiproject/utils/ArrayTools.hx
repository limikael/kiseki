package org.kisekiproject.utils;

/**
 * Array utilities.
 */
class ArrayTools {

	/**
	 * Does the array contain the value?
	 */
	public static function contains<T>(arr:Array<T>, val:T):Bool {
		if (arr==null)
			return false;

		for (v in arr)
			if (v==val)
				return true;

		return false;
	}

	/**
	 * What index does val have in the array?
	 */
	public static function indexOf<T>(arr:Array<T>, val:T):Int {
		if (arr==null)
			return -1;

		var pos:Int=0;
		for (v in arr) {
			if (v==val)
				return pos;

			pos++;
		}

		return -1;
	}
}
