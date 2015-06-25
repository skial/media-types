package;

import uhx.mo.Token;
import byte.ByteData;
import haxe.ds.StringMap;
import uhx.lexer.MimeLexer;
import uhx.lexer.MimeParser;

using StringTools;

/**
 * ...
 * @author Skial Bainn
 */
abstract MediaType(Array<Token<MimeKeywords>>) from Array<Token<MimeKeywords>> to Array<Token<MimeKeywords>> {
	
	// Toplevel checks
	public inline function isApplication():Bool return this[0].match( Keyword(Toplevel('application')) );
	public inline function isAudio():Bool return this[0].match( Keyword(Toplevel('audio')) );
	public inline function isExample():Bool return this[0].match( Keyword(Toplevel('example')) );
	public inline function isImage():Bool return this[0].match( Keyword(Toplevel('image')) );
	public inline function isMessage():Bool return this[0].match( Keyword(Toplevel('message')) );
	public inline function isModel():Bool return this[0].match( Keyword(Toplevel('model')) );
	public inline function isMultipart():Bool return this[0].match( Keyword(Toplevel('multipart')) );
	public inline function isText():Bool return this[0].match( Keyword(Toplevel('text')) );
	public inline function isVideo():Bool return this[0].match( Keyword(Toplevel('video')) );
	
	public var toplevel(get, never):Null<String>;
	
	// Tree checks
	public inline function isStandard():Bool return this.length >= 2 && !this[1].match( Keyword(Tree(_)) );
	public inline function isVendor():Bool return this.length >= 2 && this[1].match( Keyword(Tree(_.startsWith('vnd.') => true)) );
	public inline function isPersonal():Bool return this.length >= 2 && this[1].match( Keyword(Tree(_.startsWith('prs.') => true)) );
	public inline function isVanity():Bool return isPersonal();
	public inline function isUnregistered():Bool return this.length >= 2 && this[1].match( Keyword(Tree(_.startsWith('x.') => true)) );
	
	public var tree(get, never):Null<String>;
	
	// Subtype
	public var subtype(get, never):Null<String>;
	
	// Suffix checks
	public inline function isXml():Bool return this.length >= 3 && this[2].match( Keyword(Suffix('xml')) );
	public inline function isJson():Bool return this.length >= 3 && this[2].match( Keyword(Suffix('json')) );
	
	public var suffix(get, never):Null<String>;
	
	// Parameter
	public var parameters(get, never):Null<StringMap<String>>;
	
	public inline function new(v:Array<Token<MimeKeywords>>) {
		this = v;
	}
	
	@:noCompletion @:from public static inline function fromString(v:String):MediaType {
		return new MediaType( new MimeParser().toTokens( ByteData.ofString( v ), 'mediatype-fromstring' ) );
	}
	
	@:noCompletion @:to public inline function toString():String {
		return [for (token in this) switch (token) {
			case Keyword(Toplevel(n)): n;
			case Keyword(Tree(n)), Keyword(Subtype(n)): '/$n';
			case Keyword(Suffix(n)): '+$n';
			case Keyword(Parameter(n, v)): '; $n=$v';
			case _: '';
		}].join('');
	}
	
	private inline function get_toplevel():Null<String> return switch (this[0]) {
		case Keyword(Toplevel(n)): n;
		case _: null;
	}
	
	private inline function get_tree():Null<String> return if (this.length >= 2) switch (this[1]) {
		case Keyword(Tree(n)): n;
		case _: null;
	} else {
		null;
	}
	
	private inline function get_subtype():Null<String> return if (this.length >= 2) switch (this[1]) {
		case Keyword(Subtype(n)): n;
		case _: null;
	} else {
		null;
	};
	
	private inline function get_suffix():Null<String> return if (this.length >= 3) switch (this[2]) {
		case Keyword(Suffix(n)): n;
		case _: null;
	} else {
		null;
	}
	
	private inline function get_parameters():Null<StringMap<String>> {
		var params = [for (token in this) if (token.match( Keyword(Parameter(_, _)) )) token];
		if (params.length > 0) {
			var map = new StringMap();
			[for (param in params) switch(param) {
				case Keyword(Parameter(name, value)): map.set(name, value);
				case _:
			}];
			return map;
			
		} else {
			return null;
			
		}
	}
	
}