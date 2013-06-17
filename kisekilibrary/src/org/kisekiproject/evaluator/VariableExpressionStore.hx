package org.kisekiproject.evaluator;

/**
 * A variable store that can use expressions as variables.
 */
class VariableExpressionStore extends EventDispatcher implements IVariableNamespace {

	public var onChange(default,null):Signal<String>;

	private var _constants:Hash<Dynamic>;
	private var _expressions:Hash<IExpression>;

	/**
	 * Constructor.
	 */
	public function VariableExpressionStore() {
		onChange=new Signal<String>();

		_constants=new Hash<Dynamic>();
		_expressions=new Hash<IExpression>();
	}

	/**
	 * Set variable.
	 */
	public function setVariable(name:String, value:Dynamic):Void {
		_constants.remove(name);
		_expressions.remove(name);

		_constants.set(name,value);
		onChange.dispatch(name);
	}

	/**
	 * Set an expression to use as variable.
	 */
	public function setVariableExpression(name:String, expression:IExpression):void {
		_constants.remove(name);
		_expressions.remove(name);

		_expressions.set(name,expression);
		expression.onChange.addListenerWithParameter(name);
		onChange.dispatch(name);
	}

	/**
	 * Expression change.
	 */
	private function onExpressionChange(name:String):void {
		onChange.dispatch(name);
	}
	
	/**
	 * Get variable value.
	 */
	public function getVariable(name:String):Object {
		trace("getting variable: "+name);
		if (_constants.get(name)!==null)
			return _constants.get(name);

		if (_expressions.get(name))
			return _expressions.get(name).value;

		throw new Error("Variable not defined: "+name);
	}

	/**
	 * Notify variable change.
	 */
	public function notifyVariableChange(name:String):void {
		onChange.dispatch(name);
	}
}