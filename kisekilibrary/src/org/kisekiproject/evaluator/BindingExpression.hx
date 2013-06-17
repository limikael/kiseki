package org.kisekiproject.evaluator;

import org.kisekiproject.evaluator.IExpression;
import org.kisekiproject.signals.Signal;
/**
 * Binding expression.
 */
class BindingExpression implements IExpression {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;

	private var _expression:Expression;
	private var _constantValue:String;

	/**
	 * Constructor.
	 */
	public function new(expression:String, variables:IVariableNamespace) {
		onChange=new Signal<Void>();

		var s:String=StringTools.trim(expression);

		if (s.charAt(0)=="{" && s.charAt(s.length-1)=="}") {
			_expression=new Expression(s.substr(1,s.length-2), variables);
			_expression.onChange.addListener(onExpressionChange);
		}

		else
			_constantValue=expression;
	}

	/**
	 * Change.
	 */
	private function onExpressionChange():Void {
		onChange.dispatch();
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		if (_expression!=null)
			return _expression.value;

		return _constantValue;
	}

	/**
	 * Is this a binding expr?
	 */
	public static function isBindingExpression(expr:String):Bool {
		var s:String=StringTools.trim(expr);

		if (s.charAt(0)=="{" && s.charAt(s.length-1)=="}") {
			//trace("this is a binding expr: "+s);
			return true;
		}

		return false;
	}
}
