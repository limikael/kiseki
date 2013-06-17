package test.evaluator;
	
import org.kisekiproject.evaluator.Expression;
import org.kisekiproject.evaluator.VariableStore;

/**
 * @author mikael
 */
class ExpressionTest {

	/**
	 * Test expression evaluator.
	 */
	public function new() {
		var x:Expression;
		var v:VariableStore=new VariableStore();

		v.setVariable("hello",function(x){return x+1;});

		x=new Expression("hello(1)",v);

		trace("result: "+x.value);
	}

	/**
	 * Main.
	 */
	public static function main():Void {
		new ExpressionTest();
	}
}
