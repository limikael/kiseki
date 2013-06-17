package org.kisekiproject.appmarkup;

import org.kisekiproject.resources.ResourceLoader;

/**
 * Markup resource.
 */
class MarkupResource {

	public var url(getUrl,null):String;

	private var _object:Dynamic;
	private var _property:String;
	private var _src:String;

	/**
	 * Construct.
	 */
	public function new(o:Dynamic, prop:String, src:String) {
		_object=o;
		_property=prop;
		_src=src;
	}

	/**
	 * Assign.
	 */
	public function assignFromLoader(r:ResourceLoader):Void {
		var type:String=getPropertyType(_object,_property);

		trace("assigning resource property: "+type);

		switch (type) {
			case "nme.display.Bitmap":
				Reflect.setProperty(_object,_property,r.getBitmap(_src));

			case "nme.media.Sound":
				Reflect.setProperty(_object,_property,r.getSound(_src));

			default:
				throw "Unable to assing property of type: "+type+" (make sure rtti is enabled)";
		}

		trace("here..");
	}

	/**
	 * Get url.
	 */
	private function getUrl():String {
		return _src;
	}

	/**
	 * Get property type.
	 */
	private static function getPropertyType(object:Dynamic, prop:String):String {
		var objectClass:Class<Dynamic>=Type.getClass(object);

		if (Reflect.hasField(objectClass,"__rtti")) {
			var rtti:Xml=Xml.parse(Reflect.field(objectClass,"__rtti")).firstElement();

			for (x in rtti.elementsNamed(prop)) {
				var p:String=x.firstChild().get("path");
				return p;
			}
		}

		return null;
	}
}