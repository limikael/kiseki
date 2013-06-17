package org.kisekiproject.appmarkup;

import org.kisekiproject.evaluator.VariableStore;
import org.kisekiproject.evaluator.IVariableNamespace;
import org.kisekiproject.evaluator.BindingExpression;
import org.kisekiproject.resources.ResourceLoader;
import org.kisekiproject.signals.Signal;
import Xml;

/**
 * Markup context.
 */
class MarkupContext {

	public var onComplete(default,null):Signal<Void>;
	public var onError(default,null):Signal<String>;
	public var onProgress(default,null):Signal<Float>;

	public var root(getRoot,null):Dynamic;
	public var variables(getVariables,null):IVariableNamespace;
	public var constructorFunc(null,setConstructorFunc):String->Dynamic;

	private var _root:Dynamic;
	private var _constructorFunc:String->Dynamic;
	private var _variables:IVariableNamespace;
	private var _bindings:Array<MarkupBinding>;
	private var _objects:Array<Dynamic>;
	private var _anonymousCount:Int;
	private var _resources:Array<MarkupResource>;
	private var _resourceLoader:ResourceLoader;

	/**
	 * Construct.
	 */
	public function new(vars:IVariableNamespace=null):Void {
		onComplete=new Signal<Void>();
		onError=new Signal<String>();
		onProgress=new Signal<Float>();

		_variables=vars;

		if (_variables==null)
			_variables=new VariableStore();

		_constructorFunc=defaultConstructorFunc;
		_bindings=new Array<MarkupBinding>();
		_objects=new Array<Dynamic>();
		_resources=new Array<MarkupResource>();
	}

	/**
	 * Set constructor func.
	 */
	private function setConstructorFunc(f:String->Dynamic):String->Dynamic {
		_constructorFunc=f;

		return _constructorFunc;
	}

	/**
	 * Default class constructor.
	 */
	private function defaultConstructorFunc(className:String):Dynamic {
		var c:Class<Dynamic>=Type.resolveClass(className);

		if (c==null)
			throw "Class not found: "+className;

		return Type.createInstance(c,[]);
	}

	/**
	 * Parse.
	 */
	public function parse(s:String):Void {
		parseXml(Xml.parse(s));
	}

	/**
	 * Parse.
	 */
	public function parseXml(xml:Xml):Void {
		_anonymousCount=0;
		_root=parseNode(xml.firstChild());
		loadResources();
	}

	/**
	 * Initialize objects.
	 */
	private function initialize():Void {
		trace("calling initialize, num objects="+_objects.length);
		for (b in _bindings)
			b.initialize();

		var r:Array<Dynamic>=_objects.copy();
		r.reverse();

		for (o in r) {
			var i:Dynamic=null;

			try {
				i=Reflect.getProperty(o,"initialize");
			}

			catch (e:Dynamic) {
			}

			if (i!=null && Reflect.isFunction(i))
				Reflect.callMethod(o,i,[]);
		}
	}

	/**
	 * Parse node.
	 */
	private function parseNode(node:Xml):Dynamic {
		if (node.nodeName=="String") {
			var s:String=StringTools.trim(node.firstChild().nodeValue);

			return s;
		}

		if (node.nodeName=="Var" || node.nodeName=="Object" || node.nodeName=="Dynamic") {
			var s:String=node.firstChild().nodeValue;
			var expr:BindingExpression=new BindingExpression(s,_variables);

			if (node.exists("id"))
				_variables.setVariable(node.get("id"),expr);

			return null;
		}

		var object:Dynamic=_constructorFunc(node.nodeName);

		if (object==null)
			throw "Unable to create instance: "+node.nodeName;

		_objects.push(object);

		if (node.exists("id"))
			_variables.setVariable(node.get("id"),object);

		else {
			_variables.setVariable("_"+_anonymousCount,object);
			_anonymousCount++;
		}


		for (attr in node.attributes())
			if (attr!="id")
				processPropertyText(object,attr,node.get(attr));

		for (child in getChildElements(node)) {
			var name:String=child.nodeName;
			var childText:String=getChildText(child);
			var childNodes:Array<Xml>=getChildElements(child);

			if (childText!=null && childNodes.length>0) {
				trace("parsing: "+node.toString());
				throw "Cannot have both text and child nodes.";
			}

			if (child.exists("src")) {
				var r:MarkupResource=new MarkupResource(object,name,child.get("src"));
				_resources.push(r);
				//trace("we have a resource property...");
			}

			else if (childText!=null)
				processPropertyText(object,name,childText);

			else {
				if (isArrayProperty(object,name)) {
					var a:Array<Dynamic>=new Array<Dynamic>();

					for (n in childNodes)
						a.push(parseNode(n));

					Reflect.setProperty(object,name,a);
				}

				else {
					if (childNodes.length!=1)
						throw "Not an array property";

					Reflect.setProperty(object,name,parseNode(childNodes[0]));
				}
			}
		}

		return object;
	}

	/**
	 * Process property text.
	 */
	private function processPropertyText(object:Dynamic, prop:String, src:String):Void {
		if (BindingExpression.isBindingExpression(src)) {
			var binding:MarkupBinding=new MarkupBinding(object,prop,src,_variables);
			_bindings.push(binding);
		}

		else if (isArrayProperty(object,prop))
			throw "Cannot assign constant string to array prop.";

		else {
			var s:String=StringTools.trim(src);

			Reflect.setProperty(object,prop,s);
		}
	}

	/**
	 * Get child element nodes.
	 */
	private static function getChildElements(x:Xml):Array<Xml> {
		var r:Array<Xml>=new Array<Xml>();

		for (c in x)
			if (c.nodeType==Xml.Element)
				r.push(c);

		return r;
	}

	/**
	 * Get child element nodes.
	 */
	private static function getChildText(x:Xml):String {
		for (c in x) {
			if (c.nodeType==Xml.PCData && StringTools.trim(c.nodeValue)!="")
				return c.nodeValue;
		}

		return null;
	}

	/**
	 * Make an effort at checking if a property is an array.
	 * Three possible methods, none perfect:
	 *   1. The property needs to be an array.
	 *   2. The property needs to be tagged with @array.
	 *   3. Rtti info must be enabled with haxe.rtti.Infos.
	 */
	private static function isArrayProperty(object:Dynamic, prop:String):Bool {
		var objectClass:Class<Dynamic>=Type.getClass(object);

		if (Reflect.hasField(objectClass,"__rtti")) {
			var rtti:Xml=Xml.parse(Reflect.field(objectClass,"__rtti")).firstElement();

			for (x in rtti.elementsNamed(prop)) {
				if (x.firstChild().get("path")=="Array")
					return true;
			}
		}

		var v:Dynamic=Reflect.getProperty(object,prop);
		if (Std.is(v,Array))
			return true;

		var meta:Dynamic=haxe.rtti.Meta.getFields(objectClass);
		var propMeta:Dynamic=Reflect.field(meta,prop);
		if (propMeta!=null && Reflect.hasField(propMeta,"array"))
			return true;

		return false;
	}

	/**
	 * Get root.
	 */
	private function getRoot():Dynamic {
		return _root;
	}

	/**
	 * Get variables.
	 */
	private function getVariables():IVariableNamespace {
		return _variables;
	}

	/**
	 * Load resources.
	 */
	private function loadResources():Void {
		_resourceLoader=new ResourceLoader();

		for (r in _resources)
			_resourceLoader.addItem(r.url);

		_resourceLoader.onComplete.addListener(onResourceLoaderComplete);
		_resourceLoader.onProgress.addListener(onResourceLoaderProgress);
		_resourceLoader.onError.addListener(onResourceLoaderError);
		_resourceLoader.load();
	}

	/**
	 * Resource loader progress.
	 */
	private function onResourceLoaderProgress(p:Float):Void {
		onProgress.dispatch(p);
	}

	/**
	 * Resource loader complete.
	 */
	private function onResourceLoaderComplete():Void {
		try {
			trace("resources loaded, assigning");

			for (r in _resources)
				r.assignFromLoader(_resourceLoader);

			trace("running initialize");

			initialize();
		}

		catch (e:Dynamic) {
			//trace(e.getStackTrace());
			onError.dispatch(e);
			return;
		}

		onComplete.dispatch();
	}

	/**
	 * Resource loader error.
	 */
	private function onResourceLoaderError(s:String):Void {
		trace("resource loader error: "+s);
		onError.dispatch(s);
	}

	/**
	 * Reassign bindings for target.
	 */
	/*public function reassignBindings(target:Dynamic):Void {
		for (b in _bindings) {
			if (b.target==target)
				b.assign();
		}
	}*/
}