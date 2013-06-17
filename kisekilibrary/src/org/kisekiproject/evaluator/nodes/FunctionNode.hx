package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.evaluator.IFunction;
import org.kisekiproject.evaluator.IVariableNamespace;
import org.kisekiproject.signals.Signal;

/**
 * Function call.
 */
class FunctionNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	private var _index:Int;
	private var _name:String;
	private var _arguments:Array<ISyntaxNode>;
	private var _variables:IVariableNamespace;
	private var _function:IFunction;

	/**
	 * Constructor.
	 */
	public function new(variables:IVariableNamespace, name:String, arguments:Array<ISyntaxNode>, index:Int) {
		onChange=new Signal();

		_index=index;
		_name=name;
		_arguments=arguments;
		_variables=variables;

		for (arg in _arguments)
			arg.onChange.addListener(onDependencyChange);
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
		if (_function!=null)
			return _function.value;

		var f:Dynamic=_variables.getVariable(_name);

		if (Std.is(f,IFunction)) {
			_function=cast f;
			_function.arguments=getArgumentArray();
			_function.onChange.addListener(onFunctionChange);
			return _function.value;
		}

		if (!Reflect.isFunction(f))
			throw "Not a function: "+_name;

		return Reflect.callMethod(null,f,getArgumentArray());
	}

	/**
	 * Function change.
	 */
	private function onFunctionChange():Void {
		onChange.dispatch();
	}

	/**
	 * Get arg array.
	 */
	private function getArgumentArray():Array<Dynamic>	 {
		var argValues:Array<Dynamic>=new Array<Dynamic>();

		for (arg in _arguments)
			argValues.push(arg.value);

		return argValues;
	}

	/**
	 * Get stream index.
	 */
	private function getIndex():Int {
		return _index;
	}
}
