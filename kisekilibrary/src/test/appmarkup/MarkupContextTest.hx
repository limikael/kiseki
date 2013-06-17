package test.appmarkup;

import org.kisekiproject.appmarkup.MarkupContext;

class Course implements haxe.rtti.Infos {
	public var hello:Dynamic;

	public var prop:Array<PropClass>;
//	public var prop:String;

	public function new() {
	}

	public function initialize() {
		trace("init, pl: "+prop.length);
		trace("hello on init: "+hello);
	}

	private function setHello(val:String):String {
		trace("setting hello: "+val);

		return val;
	}
}

class PropClass {
	public var val:String;

	public function initialize():Void {
		trace("init prop..");
	}
}

/**
 * Markup context test.
 */
class MarkupContextTest {

	/**
	 * Construct.
	 */
	public function new() {
		var src:String=
			"<test.appmarkup.Course id='test'>"+
			"  <prop>"+
			"    <test.appmarkup.PropClass val='first'/>"+
			"    <test.appmarkup.PropClass val='second'  id='blaj'/>"+
			"  </prop>"+
			"  <hello>{blaj}</hello>"+
			"</test.appmarkup.Course>";

		var context:MarkupContext=new MarkupContext();
		context.parse(src);

		var c:Course=cast context.root;
		trace(c);
		trace("done!");
	}

	/**
	 * Main.
	 */
	public static function main() {
		new MarkupContextTest();
	}
}