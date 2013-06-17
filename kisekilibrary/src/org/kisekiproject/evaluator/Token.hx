package org.kisekiproject.evaluator;

/**
 * Token.
 */
class Token {
	public static inline var NUMBER:String="number";
	public static inline var STRING:String="string";
	public static inline var SYMBOL:String="symbol";
	public static inline var BINARY_OPERATOR:String="binaryOperator";
	public static inline var UNARY_OPERATOR:String="unaryOperator";
	public static inline var INDIRECTION:String="indirection";
	public static inline var LEFT_PARENTHESES:String="leftParentheses";
	public static inline var RIGHT_PARENTHESES:String="rightParentheses";
	public static inline var FLOW:String="flow";
	public static inline var FUNCTION_CALL:String="functionCall";
	public static inline var METHOD_CALL:String="methodCall";

	public var callToken:Token;
	public var argumentCount:Int;

	private var _value:Dynamic;
	private var _type:String;
	private var _index:Int;

	public var index(getIndex,null):Int;
	public var type(getType,null):String;
	public var value(getValue,null):Dynamic;
	public var number(getNumber,null):Float;
	public var string(getString,null):String;

	/**
	 * Constructor.
	 */
	public function new(type:String, value:Dynamic, index:Int) {
		_type=type;
		_value=value;
		_index=index;
	}

	/**
	 * Get index of the token in the original stream.
	 */
	private function getIndex():Int {
		return _index;
	}

	/**
	 * Get type.
	 */
	private function getType():String {
		return _type;
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		return _value;
	}

	/**
	 * Get number.
	 */
	private function getNumber():Float {
		return Std.parseFloat(_value);
	}

	/**
	 * Get string.
	 */
	private function getString():String {
		return Std.string(_value);
	}

	/**
	 * Get string representation.
	 */
	public function toString():String {
		return "[Token:"+_type+" "+_value+"]";
	}
}
