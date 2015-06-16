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
	public var isApplication(get, never):Bool;
	public var isAudio(get, never):Bool;
	public var isExample(get, never):Bool;
	public var isImage(get, never):Bool;
	public var isMessage(get, never):Bool;
	public var isModel(get, never):Bool;
	public var isMultipart(get, never):Bool;
	public var isText(get, never):Bool;
	public var isVideo(get, never):Bool;
	
	public var toplevel(get, never):String;
	
	// Tree checks
	public var isStandard(get, never):Bool;
	public var isVendor(get, never):Bool;
	public var isPersonal(get, never):Bool;
	public var isVanity(get, never):Bool;	// Same as `isPersonal`
	public var isUnregistered(get, never):Bool;
	
	public var tree(get, never):Null<String>;
	
	// Subtype
	public var subtype(get, never):Null<String>;
	
	// Suffix checks
	public var isXml(get, never):Bool;
	public var isJson(get, never):Bool;
	
	public var suffix(get, never):Null<String>;
	
	// Parameter
	public var parameters(get, never):Null<StringMap<String>>;
	
	public inline function new(v:Array<Token<MimeKeywords>>) {
		this = v;
	}
	
	@:noCompletion @:from public static inline function fromString(v:String):MediaType {
		return new MediaType( new MimeParser().toTokens( ByteData.ofString( v ), 'mediatype-fromstring' ) );
	}
	
	private inline function get_isApplication():Bool return this[0].match( Keyword(Toplevel('application')) );
	private inline function get_isAudio():Bool return this[0].match( Keyword(Toplevel('audio')) );
	private inline function get_isExample():Bool return this[0].match( Keyword(Toplevel('example')) );
	private inline function get_isImage():Bool return this[0].match( Keyword(Toplevel('image')) );
	private inline function get_isMessage():Bool return this[0].match( Keyword(Toplevel('message')) );
	private inline function get_isModel():Bool return this[0].match( Keyword(Toplevel('model')) );
	private inline function get_isMultipart():Bool return this[0].match( Keyword(Toplevel('multipart')) );
	private inline function get_isText():Bool return this[0].match( Keyword(Toplevel('text')) );
	private inline function get_isVideo():Bool return this[0].match( Keyword(Toplevel('video')) );
	
	private inline function get_toplevel():Null<String> return switch (this[0]) {
		case Keyword(Toplevel(n)): n;
		case _: null;
	}
	
	private inline function get_isStandard():Bool return this.length >= 2 && (switch (this[1]) {
		case Keyword(Tree(_)): false;
		case _: true;
	});
	
	private inline function get_isVendor():Bool return this.length >= 2 && (switch (this[1]) {
		case Keyword(Tree(n)): n.startsWith('vnd.');
		case _: false;
	});
	
	private inline function get_isPersonal():Bool return this.length >= 2 &&  (switch (this[1]) {
		case Keyword(Tree(n)): n.startsWith('prs.');
		case _: false;
	});
	
	private inline function get_isVanity():Bool return get_isPersonal();
	
	private inline function get_isUnregistered():Bool return this.length >= 2 &&  (switch (this[1]) {
		case Keyword(Tree(n)): n.startsWith('x.');
		case _: false;
	});
	
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
	}
	
	private inline function get_isXml():Bool return this.length >= 3) && this[2].match( Keyword(Suffix('xml')) );
	private inline function get_isJson():Bool return this.length >= 3) && this[2].match( Keyword(Suffix('json')) );
	
	private inline function get_subtype():Null<String> return if (this.length >= 3) switch (this[2]) {
		case Keyword(Suffix(n)): n;
		case _: null;
	} else {
		null;
	}
	
	private inline function get_parameters():Null<StringMap<String>> {
		var params = [for (token in this) if (token.match( Keyword(Parameter(_, _)) ) token)];
		if (params.length > 0) {
			return [for (param in params) switch(param) {
				case Keyword(Parameter(name, value)): name => value;
				case _: '' => '';
			}];
			
		} else {
			return null;
			
		}
	}
	
}