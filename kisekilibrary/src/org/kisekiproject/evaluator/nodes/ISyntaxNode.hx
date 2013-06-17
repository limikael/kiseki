package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.signals.Signal;

/**
 * Syntax node.
 */
interface ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	/**
	 * Get node value.
	 */
	//function get value():Object;

	/**
	 * Get character index in the original stream.
	 */
	//function get index():int;
}
