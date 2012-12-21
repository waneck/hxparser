package hxparser.common;
import haxe.io.Input;

/**
 * Standard Error reporting
 * @author waneck
 */

class Error
{
	public var message(default, null):String;
	public var source(default, null):Source;
	public var minPos(default, null):Int;
	public var maxPos(default, null):Int;
	
	public function new(source, msg, minPos, maxPos)
	{
		this.message = msg;
		this.source = source;
		this.minPos = minPos;
		this.maxPos = maxPos;
	}
	
	public static function getLine(src:Source, pos:Int):{ line:Int, pos:Int }
	{
		var ln = 0;
		var last = 0;
		for (l in src.newlines)
		{
			if (l > pos)
			{
				return { line : ln, pos : (pos - last) };
			}
			
			last = l;
			ln++;
		}
		
		return { line : ln, pos : (pos - last) };
	}
	
	public function toString():String
	{
		var minLine = getLine(source, minPos);
		var maxLine = getLine(source, maxPos);
		
		if (minLine.line == maxLine.line)
		{
			return source + ":" + minLine.line + ": character" + (minLine.pos == maxLine.pos ? " " + minLine.pos : "s " + minLine.pos + "-" + maxLine.pos) + " : " + message;
		} else {
			return source + ":" + minLine.line + ": lines " + minLine.line + "-" + maxLine.line + " : " + message;
		}
	}
}