package hxparser.c;
import haxe.io.Eof;
import haxe.io.Input;
import hxparser.c.ParserData;
import hxparser.common.Platform;
import hxparser.common.Source;

/**
 * ...
 * @author waneck
 * @author Nicolas Cannasse
 * @author Russell Weir
 */
 
class Part1 implements hxparser.common.Parser<PTokens>
{
	private var path:String;
	private var p:Platform;
	
	private var async:Bool = false;
	private var input:Input;
	private var src:Source;
	private var pos:Int;
	
	public function new(p:Platform, path:String) 
	{
		this.p = p;
		this.path = path;
	}
	
	public function close()
	{
		input.close();
	}
	
	//////// 1st & 2nd translation phase
	private var charStack:Array<Int> = [];
	
	function getch():Int
	{
		var ret = charStack.pop();
		if (ret == 0 || #if !static ret == null #end)
		{
			try {
				pos++;
				ret = input.readByte(); 
				if (ret == '\n'.code)
					src.newlines.push(pos);
			} catch (e:Eof) {
				ret = 0;
			}
		}
		return ret;
	}
	
	/**
	 * first translation phase:
		 * Physical source ﬁle multibyte characters are mapped to the source character set
		 * (introducing new-line characters for end-of-line indicators) if necessary. Trigraph
		 * sequences are replaced by corresponding single-character internal representations.
		 * Each instance of a backslash character (\) immediately followed by a new-line
		 * character is deleted, splicing physical source lines to form logical source lines.
	 */
	 
	function char():Int
	{
		//trigraph sequences
		var ret = getch();
		
		switch(ret)
		{
		case '?'.code:
			var ret2 = getch();
			if (ret2 == '?'.code)
			{
				var ret3 = getch();
				switch(ret3)
				{
				case '='.code:
					return '#'.code;
				case '('.code:
					return '['.code;
				case '/'.code:
					return '\\'.code;
				case ')'.code:
					return ']'.code;
				case '\''.code:
					return '^'.code;
				case '<'.code:
					return '{'.code;
				case '!'.code:
					return '|'.code;
				case '>'.code:
					return '}'.code;
				case '-'.code:
					return '~'.code;
				default:
					addChar(ret3);
					addChar(ret2);
					return ret;
				}
			} else {
				addChar(ret2);
				return ret;
			}
		case '\\'.code:
			var ret2 = getch();
			if (ret2 == '\n'.code)
				return char();
			
			addChar(ret2);
			return ret;
		}
		return ret;
	}
	
	function peekChar():Int
	{
		var ret = char();
		addChar(ret);
		
		return ret;
	}
	
	/**
	 * reverts char peek
	 */
	inline function addChar(c:Int):Void
	{
		charStack.push(c);
	}
	
	//////// 3rd translation phase
	/**
	 * second translation phase:
		 * The source ﬁle is decomposed into preprocessing tokens and sequences of
		 * white-space characters (including comments). A source ﬁle shall not end in a
		 * partial preprocessing token or in a partial comment. Each comment is replaced by
		 * one space character. New-line characters are retained. Whether each nonempty
		 * sequence of white-space characters other than new-line is retained or replaced by
		 * one space character is implementation-deﬁned
	 */
	function token():PToken
	{
		//digraphs
		var c = char();
		while (true)
		{
			switch(c)
			{
			case 0: return PEof;
			case ' '.code, '\t'.code, '\n'.code, '\r'.code: //empty space
			case '.'.code, '0'.code, '1'.code, '2'.code, '3'.code, '4'.code, '5'.code, '6'.code, '7'.code, '8'.code, '9'.code:
				//int or float
				function mkInt(buf, rx, c)
				{
						switch(c)
						{
						case 'L'.code, 'l'.code:
							c = char();
							if (c == 'L'.code || c == 'l'.code)
							{
								c = char();
								if (c == 'U'.code || c == 'u'.code)
									return PConst( CLongLong(buf.toString(), rx, true) );
								addChar(c);
								return PConst( CLongLong(buf.toString(), rx, false) );
							} else if (c == 'U'.code || c == 'u'.code)
								return PConst( CLong(buf.toString(), rx, true) );
							addChar(c);
							return PConst( CLong(buf.toString(), rx, false) );
						case 'U'.code, 'u'.code:
							return PConst( CInt(buf.toString(), rx, true) );
						case 'F'.code, 'f'.code:
							return PConst( CFloat(buf.toString()) );
						default:
							addChar(c);
							return PConst( CInt(buf.toString(), rx, false) );
						}
				}
				
				var rx = Decimal, buf = new StringBuf(), isFloat = false;
				if (c == '0'.code)
				{
					c = char();
					switch c
					{
					case 'x'.code, 'X'.code:
						
						while ( isHex(c = char()) )
						{
							buf.addChar(c);
						}
						return mkInt( buf, Hexadecimal, c );
					case '.'.code:
						do {
							buf.addChar(c);
							c = char();
						} while ( isDigit(c) );
						
						var s = buf.toString();
						if (s == ".")
							return PDot;
						
						isFloat = true;
					default:
						rx = Octal;
					}
				} else {
					buf.addChar(c);
				}
				
				while ( c >= '0'.code && c <= '9'.code || c == '.'.code )
				{
					if (c == '.'.code)
					{
						if (isFloat) //already has '.'
						{
							//shouldn't happen
							p.error(new PreprocessingError(src, "Syntax Error", pos, pos));
							
							addChar(c);
							return PConst( CDouble( buf.toString() ) );
						}
						
						isFloat = true;
					}
					
					buf.addChar(c);
					c = char();
				}
				
				switch c 
				{
				case 'a'.code, 'A'.code, 'b'.code, 'B'.code, 'c'.code, 'C'.code, 'd'.code, 'D'.code, 'e'.code, 'E'.code, 'f'.code, 'F'.code, 'p'.code, 'P'.code:
					var hex = (c != 'f'.code && c != 'F'.code);
					buf.addChar(c);
					while(isHex(c))
					{
						hex = true;
						c = char();
						buf.addChar(c);
					};
					
					//exponent part
					
				case '.'.code:
					do {
						buf.addChar(c);
						c = char();
					} while ( isDigit(c) );
					
					var s = buf.toString();
					if (s == ".")
						return PDot;
					
					if (c == 'f'.code || c == 'F'.code)
					{
						return PConst( CFloat( s ) );
					} else if (c == 'l'.code || c == 'L'.code)
					{
						return PConst( CLongDouble( s ) );
					}
					
					addChar(c);
					return PConst( CDouble( s ) );
				case 'e'.code, 'E'.code:
					if (buf.toString() == ".") //dot only
					{
						addChar(c);
						return PDot;
					}
					
					c = char();
					if (c == '-'.code || c == '+'.code)
					{
						buf.addChar(c);
						c = char();
					}
					while (isDigit(c))
					{
						buf.addChar(c);
						c = char();
					}
					
					if (c == 'f'.code || c == 'F'.code)
						return PConst( CFloat( buf.toString() ) );
					else if (c == 'l'.code || c == 'L'.code)
						return PConst( CLongDouble( buf.toString()) ) );
					
					addChar(c);
					return PConst( CDouble( buf.toString() ) );
				default:
					
				}
			
			}
		}
	}
	
	static inline function isSpace(c:Int):Bool
	{
		return c == ' '.code || c == '\t'.code || c == '\n'.code;
	}
	
	static inline function isDigit(c:Int):Bool
	{
		return c >= '0'.code && c <= '9'.code;
	}
	
	static inline function isHex(c:Int):Bool
	{
		return (c >= '0'.code && c <= '9'.code) || (c >= 'a'.code && c <= 'f'.code) || (c >= 'A'.code && c <= 'F'.code);
	}
	
	public function parse():PTokens
	{
		if (input == null)
		{
			src = p.file.read(path);
			input = src.input;
		}
		
		//parse here
	}
	
	public function parseAsync(onComplete:PTokens->Void):Void
	{
		this.async = true;
		p.file.readAsync(path, function(src) {
			this.src = src;
			this.input = src.input;
			
			onComplete( parse() );
		});
	}
}