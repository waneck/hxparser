package hxparser.common;

/**
 * ...
 * @author waneck
 */

interface Parser<ParsedType>
{
	var source(default, null):Null<Source>;
	
	function parse():ParsedType;
	function parseAsync(onComplete:ParsedType->Void);
}