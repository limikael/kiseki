package org.kisekiproject.evaluator;

/**
 * Expression error.
 */
class ExpressionError {

	public var message(default,null):String;
	public var source(default,null):String;
	public var pos(default,null):Int;

	/**
	 * Constructor.
	 */
	public function new(msg:String, src:String, p:Int) {
		message=msg+" before "+src.substr(p,1);
		source=src;
		pos=p;
	}
}