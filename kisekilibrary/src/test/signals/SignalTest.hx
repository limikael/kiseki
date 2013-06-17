package test.signals;

import org.kisekiproject.signals.Signal;

/**
 * Signal test.
 */
class SignalTest {

	/**
	 * 
	 */
	private function new() {
		var s:Signal<Void>=new Signal<Void>();
		var t:Signal<String>=new Signal<String>();

		s.addListener(onS);
		s.dispatch();

		t.addListener(onT);
		t.dispatch("hello");
	}

	/**
	 * on signal.
	 */
	private function onS():Void {
		trace("dispatched..");
	}

	/**
	 * on signal.
	 */
	private function onT(s:String):Void {
		trace("t dispatcher: "+s);
	}

	/**
	 * Constructor.
	 */
	public static function main() {
		new SignalTest();
	}
}
