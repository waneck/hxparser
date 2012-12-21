package hxparser.common;
import haxe.io.Input;
import haxe.io.Path;

/**
 * ...
 * @author waneck
 */

class Source 
{
	public var name(default, null):String;
	public var dir(default, null):String;
	public var input(default, null):Input;
	public var newlines(default, null):Array<Int>;
	
	public function new(name, dir, input) 
	{
		this.name = name;
		this.dir = dir;
		this.input = input;
		this.newlines = [];
	}
	
	public static function fromPath(path:String, input):Source
	{
		var dir = Path.directory(path);
		if (dir != "")
			dir += "/"; 
		
		return new Source( Path.withoutDirectory(path), dir, input );
	}
	
	public function toString():String
	{
		return dir + name;
	}
}