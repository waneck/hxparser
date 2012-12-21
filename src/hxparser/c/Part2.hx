package hxparser.c;
import hxparser.c.ParserData;

//////// third translation phase
/**
 * Preprocessing directives are executed, macro invocations are expanded, and
 * _Pragma unary operator expressions are executed. If a character sequence that
 * matches the syntax of a universal character name is produced by token
 * concatenation (6.10.3.3), the behavior is undeﬁned. A #include preprocessing
 * directive causes the named header or source ﬁle to be processed from phase 1
 * through phase 4, recursively. All preprocessing directives are then deleted.
 * 
 * Each source character set member, escape sequence, and universal character name
 * in character constants and string literals is converted to the corresponding member
 * of the execution character set; if there is no corresponding member, it is converted
 * to an implementation-deﬁned member.
 * 
 * Adjacent string literal tokens are concatenated.
 * 
 * White-space characters separating tokens are no longer signiﬁcant. Each
 * preprocessing token is converted into a token. The resulting tokens are
 * syntactically and semantically analyzed and translated as a translation unit.
 * 
 * @author waneck
 */

class Part2 
{

	public function new(input:PTokens, runtime:MacroRuntime) 
	{
		
	}
	
}