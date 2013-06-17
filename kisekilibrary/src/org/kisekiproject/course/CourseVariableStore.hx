package org.kisekiproject.course;

import org.kisekiproject.signals.Signal;
import org.kisekiproject.evaluator.IVariableNamespace;
import org.kisekiproject.evaluator.BindingExpression;

import nme.display.DisplayObject;
import org.kisekiproject.events.ContentEvent;

/**
 * Variable store.
 */
class CourseVariableStore implements IVariableNamespace {

	public var onChange(default,null):Signal<String>;
	public var onContentStateChange(default,null):Signal<Void>;

	private var _dictionary:Hash<Dynamic>;

	/**
	 * Constructor.
	 */
	public function new() {
		_dictionary=new Hash<Dynamic>();
		onChange=new Signal<String>();
		onContentStateChange=new Signal<Void>();
	}

	/**
	 * Get variable.
	 */
	public function getVariable(name:String):Dynamic {
		if (name=="$")
			return new QueryFunction(this);

		if (_dictionary.get(name)==null)
			throw "The variable is not defined: "+name;

		var d:Dynamic=_dictionary.get(name);

		if (Std.is(d,BindingExpression))
			return cast(d,BindingExpression).value;

		return d;
	}

	/**
	 * Set variable.
	 */
	public function setVariable(variable:String, value:Dynamic):Void {
		trace("setting var: "+variable);

		var old:Dynamic=_dictionary.get(variable);

		_dictionary.set(variable,value);

		if (old!=value) {
			if (Std.is(old,DisplayObject))
				old.removeEventListener(ContentEvent.CHANGE,onContentChange);

			if (Std.is(old,BindingExpression))
				cast(old,BindingExpression).onChange.removeListener(onExpressionChange);

			onChange.dispatch(variable);

			if (Std.is(value,DisplayObject)) {
				value.addEventListener(ContentEvent.CHANGE,onContentChange);

				var d:DisplayObject=value;
				d.name=variable;
			}

			if (Std.is(value,BindingExpression))
				cast(value,BindingExpression).onChange.addListenerWithParameter(onExpressionChange,variable);
		}
	}

	/**
	 * Property change event.
	 */
	private function onContentChange(e:ContentEvent):Void {
		var d:DisplayObject=cast e.target;

		//trace("property change: "+d.name);

		onChange.dispatch(d.name);

		onContentStateChange.dispatch();
	}

	/**
	 * Expression change.
	 */
	private function onExpressionChange(s:String):Void {
		//trace("expression change: "+s);
		onChange.dispatch(s);
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
