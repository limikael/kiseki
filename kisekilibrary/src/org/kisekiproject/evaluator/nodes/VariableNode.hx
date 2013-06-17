package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.evaluator.IVariableNamespace;
import org.kisekiproject.signals.Signal;

/**
 * Variable node.
 */
class VariableNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	private var _variables : IVariableNamespace;
	private var _variable : String;
	private var _index : Int;
	private var _getValueCalled:Bool;

	/**
	 * Constructor.
	 */
	public function new(variables:IVariableNamespace, variable:String, index:Int) {
		onChange=new Signal<Void>();

		_variables=variables;
		_variable=variable;
		_index=index;

		_variables.onChange.addListener(onVariableChange);
		_getValueCalled=false;
	}

	/**
	 * Variable change.
	 */
	private function onVariableChange(name:String):Void {
		if (name==_variable)
			onChange.dispatch();
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		//trace("getting value of: "+_variable);
		if (_getValueCalled)
			throw new ExpressionError("Circular expression",null,_index);

		_getValueCalled=true;
		var value:Dynamic=_variables.getVariable(_variable);
		_getValueCalled=false;

		return value;
	}

	/**
	 * Get index.
	 */
	private function getIndex():Int {
		return _index;
	}
}
