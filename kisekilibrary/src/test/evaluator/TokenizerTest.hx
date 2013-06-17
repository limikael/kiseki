package test.evaluator;

import org.kisekiproject.evaluator.Tokenizer;
import org.kisekiproject.evaluator.Token;

/**
 * @author mikael
 */
class TokenizerTest {

	/**
	 * Constructor.
	 */
	public static function main() {
		var t:Tokenizer=new Tokenizer();

		var a:Array<Token>=t.tokenize('   123.95  abc +"hello world" 123');

		trace("res: "+a);
	}
}
