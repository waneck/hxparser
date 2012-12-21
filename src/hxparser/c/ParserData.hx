package hxparser.c;

/**
 * All Data produced by the parser
 * @see http://www.cs.rhul.ac.uk/research/languages/projects/grammars/c/c89/kr2/ansi_c_kr2.raw
 * @see http://std.dkuug.dk/JTC1/SC22/WG14/www/docs/n843.pdf
 * @author waneck
 */

enum Radix
{
	Decimal;
	Hexadecimal;
	Octal;
}
 
enum Const
{
	CLongLong( v : String, r : Radix, unsigned:Bool );
	CLong( v : String, r : Radix, unsigned:Bool );
	CInt( v : String, r : Radix, unsgined:Bool );
	CFloat( f : String );
	CDouble( f : String );
	CLongDouble( v : String );
	CString( s : String );
	CChar( c : String );
}
 
//Preprocessing Tokens
enum PToken
{
	PEof;
	PConst( c : Const );
	PId( s : String );
	POp( s : String );

	PPOpen; // (
	PPClose; // )
	PBrOpen; // [
	PBrClose; // ]
	PDot; // .
	PComma; // ,
	PSemicolon; // ;
	PBkOpen; // {
	PBkClose; // }
	PQuestion; // ?
	PDoubleDot; // :
	
	PComment( s : String, isBlock : Bool );
}

class PreprocessingError extends hxparser.common.Error { }

enum Token
{
	TEof;
	TConst( c : Const );
	TId( s : String );
	TOp( s : String );
	
	TPOpen; // (
	TPClose; // )
	TBrOpen; // [
	TBrClose; // ]
	TDot; // .
	TComma; // ,
	TSemicolon; // ;
	TBkOpen; // {
	TBkClose; // }
	TQuestion; // ?
	TDoubleDot; // :
	
	//keywords
	KAuto; //auto
	KBreak; //break
	KCase; //case
	KChar; //char
	KConst; //const
	KContinue; //continue
	KDefault; //default
	KDo; //do
	KDouble; //double
	KElse; //else
	
	KEnum; //enum
	KExtern; //extern
	KFloat; //float
	KFor; //for
	KGoto; //goto
	KIf; //if
	KInline; //inline
	KInt; //int
	KLong; //long
	KRegister; //register
	
	KRestrict; //restrict
	KReturn; //return
	KShort; //short
	KSigned; //signed
	KSizeof; //sizeof
	KStatic; //static
	KStruct; //struct
	KSwitch; //switch
	KTypedef; //typedef
	KUnion; //union
	
	KUnsigned; //unsigned
	KVoid; //void
	KVolatile; //volatile
	KWhile; //while
	KBool; //_Bool
	KComplex; //_Complex
	KImaginary; //_Imaginary
	
	TComment( s : String, isBlock : Bool );
}

//the tokenizer will output an array of preprocessor tokens:
typedef PTokens = Array<PToken>;
 
typedef CFile = 
{
	basePath:String,
	name:String,
	statements:Array<PStatement>
}

enum PStatement
{
	
}


