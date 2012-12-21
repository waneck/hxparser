package hxparser.common;

/**
 * Solves a file path to an Input instance.
 * This abstraction allows us to work on many possible target setups
 * @author waneck
 */

class FileSolver 
{

	public function new() 
	{
		
	}
	
	public function read(path:String):Source
	{
		#if sys
		return Source.fromPath(path, sys.io.File.read(path));
		#else
		//override me
		throw "Not Implemented";
		#end
	}
	
	public function readAsync(path:String, onComplete:Source->Void):Void
	{
		#if sys
		onComplete( Source.fromPath(path, sys.io.File.read(path)) );
		#else
		var h = new haxe.Http(path);
		h.onData = function(s) {
			onComplete( Source.fromPath(path, new haxe.io.StringInput(s)) );
		};
		h.request(false);
		#end
	}
	
}