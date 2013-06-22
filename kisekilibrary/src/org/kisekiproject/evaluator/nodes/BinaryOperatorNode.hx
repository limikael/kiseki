package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.evaluator.Token;
import org.kisekiproject.evaluator.ExpressionError;
import org.kisekiproject.evaluator.nodes.ISyntaxNode;
import org.kisekiproject.signals.Signal;
import org.kisekiproject.utils.ArrayTools;

/**
 * Binary operator node.
 */
class BinaryOperatorNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	private var _left:ISyntaxNode;
	private var _right:ISyntaxNode;
	private var _value:Dynamic;
	private var _operator:String;
	private var _index:Int;
	private var _haveInitialValue:Bool;

	/**
	 * Constructor.
	 */
	public function new(op:String, left:ISyntaxNode, right:ISyntaxNode, index:Int) {
		onChange=new Signal();

		_index=index;
		_operator=op;
		_left=left;
		_right=right;
		_left.onChange.addListener(onDependencyChange);
		_right.onChange.addListener(onDependencyChange);

		_haveInitialValue=false;
	}

	/**
	 * Dependency change.
	 */
	private function onDependencyChange():Void {
		if (!_haveInitialValue) {
			onChange.dispatch();
			return;
		}

		var old:Dynamic=_value;

		calculate();

		if (old!=_value)
			onChange.dispatch();
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		if (!_haveInitialValue)
			calculate();

		return _value;
	}

	/**
	 * Convert dynamic to float.
	 */
	private static function dynamicToFloat(v:Dynamic):Float {
		if (v==true)
			return 1;

		if (v==false)
			return 0;

		return Std.parseFloat(v);
	}

	/**
	 * Perform calculation.
	 */
	private function calculate():Void {
/*		var leftVal:Float=dynamicToFloat(_left.value);
		var rightVal:Float=dynamicToFloat(_right.value);*/

		var leftVal:Dynamic=_left.value;
		var rightVal:Dynamic=_right.value;

		switch (_operator) {
			case "+":
				_value=leftVal+rightVal;

			case "-":
				_value=leftVal-rightVal;

			case "*":
				_value=leftVal*rightVal;

			case "/":
				_value=leftVal/rightVal;

			case "<":
				_value=(leftVal<rightVal)?1:0;

			case ">":
				_value=(leftVal>rightVal)?1:0;

			case "<=":
				_value=(leftVal<=rightVal)?1:0;
			
			case ">=":
				_value=(leftVal>=rightVal)?1:0;

			case "==", "=":
				//trace("cmp: "+leftVal+" == "+rightVal);
				_value=(leftVal==rightVal)?1:0;

			case "&&":
				//trace("leftval: "+leftVal+" rightval: "+rightVal);
				_value=(leftVal!=0 && rightVal!=0)?1:0;

			case "||":
				_value=(leftVal!=0 || rightVal!=0)?1:0;

			case "!=":
				//trace("leftval: "+leftVal+" rightval: "+rightVal+" neq: "+(leftVal!=rightVal));
				_value=(leftVal!=rightVal)?1:0;

			default:
				throw new ExpressionError("Not an operator: "+_operator,null,_index);
		}
	}

	/**
	 * Get precedence. Higher number means higher precedence.
	 */
	public static function getOperatorPrecedence(s:String):Int {
		switch (s) {
			case "&&", "||":
				return 1;

			case "=", "<", ">", "<=", ">=", "==", "!=":
				return 2;

			case "+", "-":
				return 3;

			case "*", "/":
				return 4;

			default:
				throw "not an operator";
				return 0;
		}
	}

	/**
	 * Is this a binary operatior?
	 */
	public static function isBinaryOperator(t:String):Bool {
		var operators:Array<String>=["+","-","*","/","<",">","<=",">=","==","=","&&","||","!="];

		return ArrayTools.contains(operators,t);
	}

	/**
	 * Get index.
	 */
	private function getIndex():Int {
		return _index;
	}
}
