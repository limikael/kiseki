package test.utils;

import org.kisekiproject.utils.Glob;

/**
 * Glob test.
 */
class GlobTest {

	/**
	 * 
	 */
	private function new() {
		var g:Glob;

		g=new Glob("hello*");
		trace(g.match("hello world"));
		trace(g.match("world"));
		trace(g.match(" hello"));

		g=new Glob("*-ini");
		trace(g.match("test-ini"));
		trace(g.match("awfawef"));
	}

	/**
	 * Constructor.
	 */
	public static function main() {
		new GlobTest();
	}
}
