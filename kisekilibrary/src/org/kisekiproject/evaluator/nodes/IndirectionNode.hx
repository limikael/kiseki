package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.signals.Signal;

/**
 * Object indirection.
 */
class IndirectionNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	private var _index:Int;
	private var _argument:ISyntaxNode;
	private var _property:String;

	/**
	 * Constrcutor.
	 */
	public function new(argument:ISyntaxNode, property:String, index:Int) {
		onChange=new Signal();

		_argument=argument;
		_property=property;
		_index=index;

		_argument.onChange.addListener(onArgumentChange);
	}

	/**
	 * Argument change.
	 */
	private function onArgumentChange():Void {
		onChange.dispatch();
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		if (Reflect.hasField(_argument.value,_property))
			return Reflect.getProperty(_argument.value,_property);

		else
			return null;
	}

	/**
	 * Get index.
	 */
	private function getIndex():Int {
		return _index;
	}
}
