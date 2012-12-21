package hxparser.common;
import haxe.PosInfos;

/**
 * Error / warning interfaces.
 * 
 * @author waneck
 */

class Platform 
{
	public var file(default, null):FileSolver;
	
	public function new(file) 
	{
		this.file = file;
	}
	
	public dynamic function warn(e:Error, ?pos:PosInfos):Void
	{
		#if sys
		Sys.stderr().writeString( e.toString() + "\n" );
		#else
		haxe.Log.trace("WARNING: " + e, pos);
		#end
	}
	
	public dynamic function error(e:Error, ?pos:PosInfos):Void
	{
		haxe.Log.trace("ERROR " + e, pos);
		throw e;
	}
}