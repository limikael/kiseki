package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.signals.Signal;

/**
 * Constant node.
 */
class ConstantNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	private var _value:Dynamic;
	private var _index:Int;

	/**
	 * Constructor.
	 */
	public function new(val:Dynamic, index:Int) {
		onChange=new Signal<Void>();

		_value=val;
		_index=index;
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		return _value;
	}

	/**
	 * Get index.
	 */
	private function getIndex():Int {
		return _index;
	}
}
