package org.kisekiproject.utils;

/**
 * Object util.
 */
class ObjectUtil {

	/**
	 * Compare dynamic objects.
	 */
	public static function compare(a:Dynamic, b:Dynamic):Bool {
		//trace("object compare..");

		if (Type.getClass(a)!=Type.getClass(b))
			return false;

		if (Reflect.isObject(a) && !Std.is(a, String)) {
			for (f in Reflect.fields(a))
				if (!compare(Reflect.field(a,f),Reflect.field(b,f)))
					return false;

			for (f in Reflect.fields(b))
				if (!compare(Reflect.field(a,f),Reflect.field(b,f)))
					return false;

			return true;
		}

		//trace("here: "+a+" ?= "+b);
		return (a==b);
	}
}