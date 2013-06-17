package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.signals.Signal;

/**
 * Unary operator.
 */
class UnaryOperatorNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	private var _operator:String;
	private var _operand:ISyntaxNode;
	private var _index:Int;

	/**
	 * Constructor.
	 */
	public function new(op:String, operand:ISyntaxNode, index:Int) {
		onChange=new Signal<Void>();

		_operator=op;
		_operand=operand;
		_index=index;

		_operand.onChange.addListener(onDependencyChange);
	}

	/**
	 * Dependency change.
	 */
	private function onDependencyChange():Void {
		onChange.dispatch();
	}
	
	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		switch (_operator) {
			case "-":
				return -_operand.value;

			case "!":
				return !_operand.value;

			default:
				throw "Unkown operator: "+_operator;
		}

		return null;
	}

	/**
	 * Get index.
	 */
	private function getIndex():Int {
		return _index;
	}
}
