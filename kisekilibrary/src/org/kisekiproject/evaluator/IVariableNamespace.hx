package org.kisekiproject.evaluator;

import org.kisekiproject.signals.Signal;

/**
 * Something that can hold named variables. 
 * onChange should signal if a variable change.
 */
interface IVariableNamespace {

	public var onChange(default,null):Signal<String>;

	function getVariable(name:String):Dynamic;

	function setVariable(name:String, value:Dynamic):Void;

	function getNames():Array<String>;
}
