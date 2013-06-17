package org.kisekiproject.evaluator;

import org.kisekiproject.signals.Signal;

/**
 * Variable store.
 */
class VariableStore implements IVariableNamespace {

	public var onChange(default,null):Signal<String>;

	private var _dictionary:Hash<Dynamic>;

	/**
	 * Constructor.
	 */
	public function new() {
		_dictionary=new Hash<Dynamic>();
		onChange=new Signal<String>();
	}

	/**
	 * Get variable.
	 */
	public function getVariable(name:String):Dynamic {
		if (_dictionary.get(name)==null)
			throw "The variable is not defined: "+name;

		return _dictionary.get(name);
	}

	/**
	 * Set variable.
	 */
	public function setVariable(variable:String, value:Dynamic):Void {
		var old:Dynamic=_dictionary.get(variable);

		_dictionary.set(variable,value);

		if (old!=value)
			onChange.dispatch(variable);
	}

	/**
	 * Get names.
	 */
	public function getNames():Array<String> {
		var r:Array<String>=new Array<String>();

		for (s in _dictionary.keys())
			r.push(s);

		return r;
	}
}
