package org.kisekiproject.evaluator;

import org.kisekiproject.signals.Signal;

/**
 * Something that can be evaluated as an expression.
 * Implementors should dispatch a Event.CHANGE event
 * on value change.
 */
interface IExpression {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;

	/**
	 * Get value of the expression.
	 */
	//function get value():Object;
}
