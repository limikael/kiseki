package org.kisekiproject.evaluator.nodes;
	
import org.kisekiproject.evaluator.Expression;
import org.kisekiproject.evaluator.IExpression;
import org.kisekiproject.evaluator.Token;
import org.kisekiproject.evaluator.ExpressionError;
import org.kisekiproject.signals.Signal;

/**
 * Token node.
 */
class TokenNode implements ISyntaxNode {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;
	public var index(getIndex,null):Int;
	public var token(getToken,null):Token;
	public var node(getNode,null):ISyntaxNode;

	private var _token:Token;
	private var _node:ISyntaxNode;
	private var _expression:String;

	/**
	 * Constructor.
	 */
	public function new(token:Token, node:ISyntaxNode, ex:String) {
		_token=token;
		_node=node;
		_expression=ex;
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		throw new ExpressionError("Unexpected "+_token.string,_expression,token.index);
	}

	/**
	 * Get index.
	 */
	private function getIndex():Int {
		return _token.index;
	}

	/**
	 * Get token.
	 */
	private function getToken():Token {
		return _token;
	}

	/**
	 * Get node.
	 */
	private function getNode():ISyntaxNode {
		return _node;
	}
}
