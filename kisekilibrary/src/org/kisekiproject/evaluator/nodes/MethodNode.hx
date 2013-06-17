package org.kisekiproject.evaluator.nodes;

import org.kisekiproject.evaluator.IVariableNamespace;
import org.kisekiproject.signals.Signal;

/**
 * Method call.
 */
class MethodNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;

	private var _index:Int;
	private var _name:String;
	private var _arguments:Array<ISyntaxNode>;
	private var _variables:IVariableNamespace;
	private var _objectNode:ISyntaxNode;

	/**
	 * Constructor.
	 */
	public function new(variables:IVariableNamespace, object:ISyntaxNode, name:String, arguments:Array<ISyntaxNode>, index:Int) {
		onChange=new Signal<Void>();

		_index=index;
		_name=name;
		_arguments=arguments;
		_variables=variables;
		_objectNode=object;

		for (arg in _arguments)
			arg.onChange.addListener(onDependencyChange);

		_objectNode.onChange.addListener(onDependencyChange);
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
		var argValues:Array<Dynamic>=new Array<Dynamic>();

		for (arg in _arguments)
			argValues.push(arg.value);

		/*var o:Object=_objectNode.value;

		trace("getting value from method call, arg values: "+argValues+" method: "+_name+" object: "+o);*/

		var f:Dynamic=Reflect.getProperty(_objectNode.value,_name);
		return Reflect.callMethod(null,f,argValues);
	}

	/**
	 * Get stream index.
	 */
	private function getIndex():Int {
		return _index;
	}
}
