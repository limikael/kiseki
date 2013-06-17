package org.kisekiproject.utils;

/**
 * File util.
 */
class FileUtil {

	/**
	 * Compute file extension given file name.
	 */
	public static function getFileExtension(fn:String):String {
		var index:Int=fn.lastIndexOf(".");

		if (index<0)
			return "";

		return fn.substr(index+1).toLowerCase();
	}
}