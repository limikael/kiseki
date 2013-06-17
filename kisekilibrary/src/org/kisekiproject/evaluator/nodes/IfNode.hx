package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.signals.Signal;

/**
 * Handle if/else.
 */
class IfNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	private var _index:Int;
	private var _ifNode:ISyntaxNode;
	private var _trueNode:ISyntaxNode;
	private var _elseNode:ISyntaxNode;

	/**
	 * Constructor.
	 */
	public function new(ifNode:ISyntaxNode, trueNode:ISyntaxNode, elseNode:ISyntaxNode, index:Int) {
		onChange=new Signal();

		_ifNode=ifNode;
		_trueNode=trueNode;
		_elseNode=elseNode;
		_index=index;

		_ifNode.onChange.addListener(onDependencyChange);
		_trueNode.onChange.addListener(onDependencyChange);

		if (_elseNode!=null)
			_elseNode.onChange.addListener(onDependencyChange);
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
		if (_ifNode.value!=0)
			return _trueNode.value;

		if (_elseNode!=null)
			return _elseNode.value;

		return null;
	}

	/**
	 * Get index.
	 */
	private function getIndex():Int {
		return _index;
	}
}
