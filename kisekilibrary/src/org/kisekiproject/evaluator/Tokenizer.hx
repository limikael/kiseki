package org.kisekiproject.evaluator;

/**
 * Tokenizer.
 */
class Tokenizer {

	private var _pos:Int;
	private var _string:String;

	/**
	 * Constructor.
	 */
	public function new() {
	}

	/**
	 * Tokenize string.
	 */
	public function tokenize(s:String):Array<Token> {
		var res:Array<Token>=new Array<Token>();

		_string=s;
		_pos=0;

		while(_pos<_string.length) {
			if (StringTools.isSpace(_string,_pos))
				_pos++;

			else
				res.push(getNextToken());
		}

		return res;
	}

	/**
	 * Get next token.
	 */
	private function getNextToken():Token {
		var opChars:String="+-*/.[]!=<>&|";

		if (reMatch(_string.charAt(_pos),~/\.?[0-9]/))
			 return extractNumber();

		else if (reMatch(_string.charAt(_pos),~/[a-zA-Z_$]/))
			 return extractSymbol();

		else if (_string.charAt(_pos)=='"')
			return extractString();

		else if (opChars.indexOf(_string.charAt(_pos))>=0)
			 return extractOperator();

		else if ("()".indexOf(_string.charAt(_pos))>=0)
			return extractParentheses();

		else throw new ExpressionError("Unexpected token",_string,_pos);
	}

	/**
	 * Extract parentheses.
	 */
	private function extractParentheses():Token {
		var p:Int=_pos;

		switch (_string.charAt(_pos++)) {
			case "(":
				return new Token(Token.LEFT_PARENTHESES,null,p);
				
			case ")":
				return new Token(Token.RIGHT_PARENTHESES,null,p);
		}

		throw new ExpressionError("Unexpected token",_string,_pos);
	}

	/**
	 * Extract number.
	 */
	private function extractNumber():Token {
		var p:Int=_pos;
		var s:String=extractRegExp(~/[0-9]*(\.[0-9]+)?/);

		return new Token(Token.NUMBER,Std.parseFloat(s),p);
	}

	/**
	 * Extract Symbol.
	 */
	private function extractSymbol():Token {
		var p:Int=_pos;
		var s:String=extractRegExp(~/[A-Za-z_$]?[A-Za-z0-9_$]*/);

		if (s=="if" || s=="else")
			return new Token(Token.FLOW,s,p);

		return new Token(Token.SYMBOL,s,p);
	}

	/**
	 * Extract String.
	 */
	private function extractString():Token {
		var p:Int=_pos;
		var s:String=extractRegExp(~/"[^"]*"/);

		return new Token(Token.STRING,s.substr(1,s.length-2),p);
	}

	/**
	 * Extract String.
	 */
	private function extractOperator():Token {

		// Long must be before short.
		var operators:Array<String>=["==","!=","<=",">=","!","*","%","(",")","[","]","+","=","<",">",".","-","/","&&","||"];
		var p:Int=_pos;

		for (op in operators)
			if (_string.substr(_pos,op.length)==op) {
				_pos+=op.length;

				return new Token(Token.BINARY_OPERATOR, op, p);
			}

		throw new ExpressionError("Unexpected token",_string,_pos);
	}

	/**
	 * Extract reg exp and advance position pointer.
	 */
	private function extractRegExp(re:EReg):String {
		var cand:String=_string.substr(_pos);

		re.match(cand);
		var match:String=re.matched(0);

		_pos+=match.length;

		return match;
	}

	/**
	 * Reg exp match.
	 */
	private static function reMatch(s:String, re:EReg):Bool {
		 return re.match(s);
	}
}
