package org.kisekiproject.appmarkup;

import org.kisekiproject.evaluator.BindingExpression;
import org.kisekiproject.evaluator.IVariableNamespace;
import org.kisekiproject.queryset.QuerySet;

/**
 * Markup binding.
 */
class MarkupBinding {

	public var target(getTarget,null):Dynamic;

	private var _targetObject:Dynamic;
	private var _targetProperty:String;
	private var _expression:BindingExpression;

	/**
	 * Construct.
	 */
	public function new(targetO:Dynamic, targetP:String, expr:String, vars:IVariableNamespace) {
		_targetObject=targetO;
		_targetProperty=targetP;
		_expression=new BindingExpression(expr,vars);
//		_expression.onChange.addListener(onExpressionChange);
	}

	/**
	 * Get target.
	 */
	private function getTarget():Dynamic {
		return _targetObject;
	}

	/**
	 * Initialize.
	 */
	public function initialize():Void {
		_expression.onChange.addListener(onExpressionChange);
		assign();
	}

	/**
	 * Change.
	 */
	private function onExpressionChange():Void {
		assign();
	}

	/**
	 * Assign.
	 */
	private function assign():Void {
		var useVal:Dynamic=_expression.value;

		if (Std.is(useVal,QuerySet)) {
			var qs:QuerySet=cast useVal;
			useVal=qs.array();
		}

		Reflect.setProperty(_targetObject,_targetProperty,useVal);
	}
}