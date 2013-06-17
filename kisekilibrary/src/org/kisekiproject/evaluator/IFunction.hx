package org.kisekiproject.evaluator;

import org.kisekiproject.signals.Signal;
import org.kisekiproject.evaluator.nodes.ISyntaxNode;

/**
 * A function that can change its result dynamically.
 * The implementing class should dispatch a Event.CHANGE event
 * if the result changes.
 */
interface IFunction {

	public var onChange(default,null):Signal<Void>;
	public var arguments(null,setArguments):Array<Dynamic>;
	public var value(getValue,null):Dynamic;
}