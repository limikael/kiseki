package org.kisekiproject.course;

import org.kisekiproject.evaluator.IFunction;
import org.kisekiproject.signals.Signal;
import org.kisekiproject.queryset.QuerySet;
import org.kisekiproject.events.ContentEvent;
import org.kisekiproject.utils.Glob;

import nme.display.DisplayObject;
import nme.events.Event;

/**
 * Query for variables.
 */
class QueryFunction implements IFunction {

	public var onChange(default,null):Signal<Void>;
	public var arguments(null,setArguments):Array<Dynamic>;
	public var value(getValue,null):Dynamic;

	private var _variables:CourseVariableStore;
	private var _pages:Array<DisplayObject>;
	private var _set:QuerySet;

	/**
	 * Construct.
	 */
	public function new(vars:CourseVariableStore):Void {
		onChange=new Signal<Void>();

		_variables=vars;
		_pages=new Array<DisplayObject>();
		_set=new QuerySet([]);
	}

	/**
	 * Set args.
	 */
	public function setArguments(args:Array<Dynamic>):Array<Dynamic> {
		for (p in _pages)
			p.removeEventListener(ContentEvent.CHANGE,onContentChange);

		_pages=new Array<DisplayObject>();
		var ref:String=args[0];
		var g:Glob=new Glob(ref);

		for (s in _variables.getNames())
			if (g.match(s) && Std.is(_variables.getVariable(s),DisplayObject)) {
				var d:DisplayObject=cast _variables.getVariable(s);

				d.addEventListener(ContentEvent.CHANGE,onContentChange);
				_pages.push(d);
			}

		_set=new QuerySet(_pages);

		return args;
	}

	/**
	 * Property change.
	 */
	private function onContentChange(e:ContentEvent):Void {
		//trace("prop change in qf..");
		onChange.dispatch();
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		return _set;
	}
}