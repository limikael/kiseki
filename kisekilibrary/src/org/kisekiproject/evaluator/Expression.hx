package org.kisekiproject.evaluator;
	
import org.kisekiproject.evaluator.ExpressionError;
import org.kisekiproject.evaluator.nodes.BinaryOperatorNode;
import org.kisekiproject.evaluator.nodes.ConstantNode;
import org.kisekiproject.evaluator.nodes.FunctionNode;
import org.kisekiproject.evaluator.nodes.ISyntaxNode;
import org.kisekiproject.evaluator.nodes.IfNode;
import org.kisekiproject.evaluator.nodes.IndirectionNode;
import org.kisekiproject.evaluator.nodes.MethodNode;
import org.kisekiproject.evaluator.nodes.TokenNode;
import org.kisekiproject.evaluator.nodes.UnaryOperatorNode;
import org.kisekiproject.evaluator.nodes.VariableNode;

import org.kisekiproject.signals.Signal;

/**
 * Expression
 */
class Expression implements IExpression {

	public var onChange(default,null):Signal<Void>;
	public var value(getValue,null):Dynamic;

	private var _variables:IVariableNamespace;
	private var _node : ISyntaxNode;
	private var _expression : String;
	//private var _valueFetched:Boolean;

	/**
	 * Constructor.
	 */
	public function new(expression:String, variables:IVariableNamespace) {
		onChange=new Signal<Void>();

		_variables=variables;
		_expression=expression;

		_node=parse(expression);
		_node.onChange.addListener(onNodeChange);
	}

	/**
	 * Node change, propagate.
	 */
	private function onNodeChange():Void {
		//if (_valueFetched)
			onChange.dispatch();
	}

	/**
	 * Get value.
	 */
	private function getValue():Dynamic {
		//_valueFetched=true;
		return _node.value;
	}

	/**
	 * Parse the expression and build AST.
	 * Implements http://en.wikipedia.org/wiki/Shunting-yard_algorithm
	 */
	private function parse(expression:String):ISyntaxNode {
		var tokenizer:Tokenizer=new Tokenizer();
		var tokens:Array<Token>=tokenizer.tokenize(expression);

		/*trace("-----------");

		for (t in tokens)
			trace("token: "+t);*/

		tokens=rpn(tokens);

		/*trace("--- rpn ---");
		for (t in tokens)
			trace("rpn: "+t);*/

		//trace("-----------");*/

		return ast(tokens);
	}

	/**
	 * Build ast.
	 * The tokens are assumed to be rpn.
	 */
	private function ast(tokens:Array<Token>):ISyntaxNode {
		var stack:Array<ISyntaxNode>=new Array<ISyntaxNode>();
		var args:Array<ISyntaxNode>;
		var i:Int;

		for (token in tokens) {
			//trace("parsing: "+token.string);
			switch (token.type) {
				case Token.STRING, Token.NUMBER:
					stack.push(new ConstantNode(token.value,token.index));

				case Token.FLOW:
					trace("parsing flow token: "+token.string);
					switch (token.string) {
						case "if":
							//trace("stacklen: "+stack.length);
							if (stack.length<2)
								throw new ExpressionError("Parse error",_expression,token.index);

							var elseNode:ISyntaxNode=popIfElse(stack);
							var trueNode:ISyntaxNode=stack.pop();

							if (stack.length==0)
								throw new ExpressionError("Parse error",_expression,token.index);

							var ifNode:ISyntaxNode=stack.pop();
							stack.push(new IfNode(ifNode,trueNode,elseNode,token.index));

						case "else":
							stack.push(new TokenNode(token,stack.pop(),_expression));
					}

				case Token.SYMBOL:
					stack.push(new VariableNode(_variables,token.string,token.index));

				case Token.BINARY_OPERATOR:
					if (stack.length<2)
						throw new ExpressionError("Parse error",_expression,token.index);

					if (!BinaryOperatorNode.isBinaryOperator(token.string))
						throw new ExpressionError("Parse error",_expression,token.index);

					var right:ISyntaxNode=stack.pop();
					var left:ISyntaxNode=stack.pop();
					stack.push(new BinaryOperatorNode(token.string,left,right,token.index));

				case Token.UNARY_OPERATOR:
					if (stack.length<1)
						throw new ExpressionError("Parse error",_expression,token.index);

					stack.push(new UnaryOperatorNode(token.string,stack.pop(),token.index));

				case Token.INDIRECTION:
					stack.push(new IndirectionNode(stack.pop(),token.string,token.index));

				case Token.FUNCTION_CALL:
					if (stack.length<token.argumentCount)
						throw new ExpressionError("Parse error",_expression,token.index);

					args=new Array();
					for (i in 0...token.argumentCount)
						args.push(stack.pop());

					stack.push(new FunctionNode(_variables,token.string,args,token.index));

				case Token.METHOD_CALL:
					if (stack.length<token.argumentCount+1)
						throw new ExpressionError("Parse error",_expression,token.index);

					args=new Array();
					for (i in 0...token.argumentCount)
						args.push(stack.pop());

					var obj:ISyntaxNode=stack.pop();
					stack.push(new MethodNode(_variables,obj,token.string,args,token.index));

				default:
					throw new ExpressionError("Parse error",_expression,token.index);
			}
		}

		if (stack.length!=1) {
			for (n in stack)
				trace("left on stack: "+n);

			throw new ExpressionError("Parse error",_expression,0);
		}

		return stack[0];
	}

	/**
	 * Pop the top of stack if it is an else node.
	 */
	private function popIfElse(stack:Array<ISyntaxNode>):ISyntaxNode {
		if (stack.length==0)
			return null;

		var node:ISyntaxNode=stack[stack.length-1];
		if (Std.is(node,TokenNode)) {
			var t:TokenNode=cast node;

			if (t.token.type==Token.FLOW && t.token.string=="else") {
				//trace("popping else...");
				stack.pop();
				return t.node;
			}
		}

		return null;
	}

	/**
	 * Convert to rpn.
	 */
	private function rpn(tokens:Array<Token>):Array<Token> {
		var queue:Array<Token>=new Array<Token>();
		var stack:Array<Token>=new Array<Token>();
		var unaryMinus:Bool=true;
		var callType:String=null;
		var tmp:Token;
		var last:Token=null;
		while (tokens.length>0) {
			var t:Token=tokens.shift();

			//trace("tokenizing: "+t+" unaryMinus: "+unaryMinus);

			switch (t.type) {
				case Token.NUMBER, Token.STRING:
					queue.push(t);
					unaryMinus=false;
					callType=null;

				case Token.SYMBOL:
					queue.push(t);
					unaryMinus=false;
					callType=Token.FUNCTION_CALL;

				case Token.FLOW:
					stack.push(t);
					unaryMinus=true;
					callType=null;

				case Token.BINARY_OPERATOR:
					callType=null;

					//trace("bin op, string:"+t.string);

					if (t.string==".") {
						//trace("here, token len: "+tokens.length);
						var prop:Token=tokens.shift();

						if (prop==null)
							throw new ExpressionError("Parse error, lvalue expected",_expression,t.index);

						if (prop.type!=Token.SYMBOL)
							throw new ExpressionError("Parse error",_expression,prop.index);

						queue.push(new Token(Token.INDIRECTION,prop.string,t.index));
						callType=Token.METHOD_CALL;
					}

					else if ((t.string=="-" || t.string=="!") && unaryMinus) {
						stack.push(new Token(Token.UNARY_OPERATOR,t.string,t.index));
					}

					else if (BinaryOperatorNode.isBinaryOperator(t.string)) {
						while (compareTopOfStackWithOperator(stack,t))
							queue.push(stack.pop());

						stack.push(t);
					}

					else
						throw new ExpressionError("Parse error",_expression,t.index);

					unaryMinus=true;

				case Token.LEFT_PARENTHESES:
					tmp=null;
					switch (callType) {
						case Token.FUNCTION_CALL:
							tmp=queue.pop();
							tmp=new Token(Token.FUNCTION_CALL,tmp.value,tmp.index);
							tmp.argumentCount=1;
							//stack.push(new Token(Token.FUNCTION_CALL,tmp.value,tmp.index));

						case Token.METHOD_CALL:
							tmp=queue.pop();
							tmp=new Token(Token.METHOD_CALL,tmp.value,tmp.index);
							tmp.argumentCount=1;
							//stack.push(new Token(Token.METHOD_CALL,tmp.value,tmp.index));
					}

					stack.push(t);

					if (tmp!=null) {
						t.callToken=tmp;
						stack.push(tmp);
					}

					unaryMinus=true;
					callType=null;
						
				case Token.RIGHT_PARENTHESES:
					while (stack.length>0 && stack[stack.length-1].type!=Token.LEFT_PARENTHESES) {
						tmp=stack.pop();
						queue.push(tmp);
					}

					if (stack.length==0)
						throw new ExpressionError("Parse error",_expression,t.index);

					var lpToken:Token=stack.pop();
					unaryMinus=false;
					callType=null;

					if (last.type==Token.LEFT_PARENTHESES && lpToken.callToken!=null)
						lpToken.callToken.argumentCount=0;

				default:
					throw new ExpressionError("Parse error",_expression,t.index);
			}

			last=t;
		}

		while (stack.length>0)
			queue.push(stack.pop());

		return queue;			
	}

	/**
	 * Implements the test for:
	 * If the token is an operator, o1, then:
	 * while there is an operator token, o2, at the top of the stack, and
	 * either o1 is left-associative and its precedence is less than or equal to that of o2,
	 * or o1 is right-associative and its precedence is less than that of o2,
	 * pop o2 off the stack, onto the output queue;
	 * push o1 onto the stack.
	 */
	private static function compareTopOfStackWithOperator(stack:Array<Token>, t:Token):Bool {
		if (stack.length<1)
			return false;

		var top:Token=stack[stack.length-1];

		return (
			top.type==Token.BINARY_OPERATOR && 
			BinaryOperatorNode.isBinaryOperator(top.string) &&
			BinaryOperatorNode.getOperatorPrecedence(t.string)<=
				BinaryOperatorNode.getOperatorPrecedence(top.string)
		);
	}
}
