package org.kisekiproject.queryset;

/**
 * A set of objects that can be queried in various ways.
 */
class QuerySet {

	private var _array:Array<Dynamic>;

	/**
	 * Create an object set.
	 */
	public function new(source:Array<Dynamic>) {
		_array=source;
	}

	/**
	 * Sums the objects in the set.
	 */
	public function sum():Float {
		var res:Float=0;

		for (o in _array)
			res+=o;

		return res;
	}

	/**
	 * Counts the objects in the set.
	 */
	public function count():Int {
		return _array.length;
	}

	/**
	 * Slices the set vertically.
	 */
	public function slice(property:String):QuerySet {
		//trace("slicing...");
		var a:Array<Dynamic>=new Array<Dynamic>();

		for (o in _array)
			a.push(Reflect.getProperty(o,property));

		return new QuerySet(a);
	}

	/**
	 * Selects the objects that fulfill a criteria.
	 */
	/*public function where(expression:String):ObjectSet {
		return new ObjectSet([]);
	}*/

	/**
	 * Get array.
	 */
	public function array():Array<Dynamic> {
		return _array;
	}
}