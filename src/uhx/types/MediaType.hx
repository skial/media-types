package uhx.types;

import uhx.mo.Token;
import byte.ByteData;
import haxe.ds.StringMap;
import uhx.lexer.Mime.MimeKeywords;
import uhx.lexer.Mime as MimeLexer;
import uhx.parser.Mime as MimeParser;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
#end

using StringTools;
#if macro
using haxe.macro.ExprTools;
#end

/**
 * ...
 * @author Skial Bainn
 */

typedef MediaType = 
#if !macro
uhx.types.MediaTypeConst
#else
uhx.types.MediaTypeAbstract
#end
;

abstract MediaTypeConst(MediaTypeStruct) from MediaTypeStruct to MediaTypeStruct {
	
	@:from public static macro function fromExpr(v:Expr) {
		var result = macro @:pos(v.pos) throw 'Could not convert the expression ' + $v{v.toString()} + ' to a mime type.';
		
		switch v {
			case _.expr => EConst(CString(value)):
				var mime = (value:uhx.types.MediaTypeAbstract);
				var parameters = macro null;
				
				if (mime.parameters != null) {
					var exprs = [];
					for (key in mime.parameters.keys()) exprs.push( macro $v{key}=>$v{mime.parameters.get(key)} );
					parameters = macro $a{exprs};
				}
				
				result = if (!Context.defined('js')) { 
					macro @:mergeBlock { 
						// TODO generate random variable name as best as possible.
						// TODO figure out why @:structInit created classes does not work.
						var mime:MediaTypeStruct = new MediaTypeStruct();
						mime.isApplication = ($v{mime.isApplication()}:Bool);
						mime.isAudio = ($v{mime.isAudio()}:Bool);
						mime.isExample = ($v{mime.isExample()}:Bool);
						mime.isImage = ($v{mime.isImage()}:Bool);
						mime.isMessage = ($v{mime.isMessage()}:Bool);
						mime.isModel = ($v{mime.isModel()}:Bool);
						mime.isMultipart = ($v{mime.isMultipart()}:Bool);
						mime.isText = ($v{mime.isText()}:Bool);
						mime.isVideo = ($v{mime.isVideo()}:Bool);
						mime.isStandard = ($v{mime.isStandard()}:Bool);
						mime.isVendor = ($v{mime.isVendor()}:Bool);
						mime.isPersonal = ($v{mime.isPersonal()}:Bool);
						mime.isUnregistered = ($v{mime.isUnregistered()}:Bool);
						mime.isXml = ($v{mime.isXml()}:Bool);
						mime.isJson = ($v{mime.isJson()}:Bool);
						mime.toplevel = ($v{mime.toplevel}:Null<String>);
						mime.tree = ($v{mime.tree}:Null<String>);
						mime.subtype = ($v{mime.subtype}:Null<String>);
						mime.suffix = ($v{mime.suffix}:Null<String>);
						mime.parameters = $parameters;
						(mime:MediaTypeConst);
					}
					
				} else {
					macro @:mergeBlock {
						var mime:MediaTypeStruct = {
							isApplication: ($v{mime.isApplication()}:Bool),
							isAudio: ($v{mime.isAudio()}:Bool),
							isExample: ($v{mime.isExample()}:Bool),
							isImage: ($v{mime.isImage()}:Bool),
							isMessage: ($v{mime.isMessage()}:Bool),
							isModel: ($v{mime.isModel()}:Bool),
							isMultipart: ($v{mime.isMultipart()}:Bool),
							isText: ($v{mime.isText()}:Bool),
							isVideo: ($v{mime.isVideo()}:Bool),
							isStandard: ($v{mime.isStandard()}:Bool),
							isVendor: ($v{mime.isVendor()}:Bool),
							isPersonal: ($v{mime.isPersonal()}:Bool),
							isUnregistered: ($v{mime.isUnregistered()}:Bool),
							isXml: ($v{mime.isXml()}:Bool),
							isJson: ($v{mime.isJson()}:Bool),
							toplevel: ($v{mime.toplevel}:Null<String>),
							tree: ($v{mime.tree}:Null<String>),
							subtype: ($v{mime.subtype}:Null<String>),
							suffix: ($v{mime.suffix}:Null<String>),
							parameters: $parameters,
						};
						(mime:MediaTypeConst);
					}
					
				}
				
			case _:
				var struct = if (Context.defined('js')) {
					macro @:mergeBlock {
						var struct:MediaTypeStruct = {
							isApplication: (mime.isApplication():Bool),
							isAudio: (mime.isAudio():Bool),
							isExample: (mime.isExample():Bool),
							isImage: (mime.isImage():Bool),
							isMessage: (mime.isMessage():Bool),
							isModel: (mime.isModel():Bool),
							isMultipart: (mime.isMultipart():Bool),
							isText: (mime.isText():Bool),
							isVideo: (mime.isVideo():Bool),
							isStandard: (mime.isStandard():Bool),
							isVendor: (mime.isVendor():Bool),
							isPersonal: (mime.isPersonal():Bool),
							isUnregistered: (mime.isUnregistered():Bool),
							isXml: (mime.isXml():Bool),
							isJson: (mime.isJson():Bool),
							toplevel: (mime.toplevel:Null<String>),
							tree: (mime.tree:Null<String>),
							subtype: (mime.subtype:Null<String>),
							suffix: (mime.suffix:Null<String>),
							parameters: mime.parameters,
						};
					}
					
				} else {
					macro @:mergeBlock {
						var struct:MediaTypeStruct = new MediaTypeStruct();
						struct.isApplication = (mime.isApplication():Bool);
						struct.isAudio = (mime.isAudio():Bool);
						struct.isExample = (mime.isExample():Bool);
						struct.isImage = (mime.isImage():Bool);
						struct.isMessage = (mime.isMessage():Bool);
						struct.isModel = (mime.isModel():Bool);
						struct.isMultipart = (mime.isMultipart():Bool);
						struct.isText = (mime.isText():Bool);
						struct.isVideo = (mime.isVideo():Bool);
						struct.isStandard = (mime.isStandard():Bool);
						struct.isVendor = (mime.isVendor():Bool);
						struct.isPersonal = (mime.isPersonal():Bool);
						struct.isUnregistered = (mime.isUnregistered():Bool);
						struct.isXml = (mime.isXml():Bool);
						struct.isJson = (mime.isJson():Bool);
						struct.toplevel = (mime.toplevel:Null<String>);
						struct.tree = (mime.tree:Null<String>);
						struct.subtype = (mime.subtype:Null<String>);
						struct.suffix = (mime.suffix:Null<String>);
						struct.parameters = mime.parameters;
					}
					
				}
				
				result = macro @:mergeBlock { 
					var mime = ($v:MediaTypeAbstract);
					$struct;
					(struct:MediaTypeConst);
				}
				
		}
		
		return macro @:pos(v.pos) $result;
	}
	
	public inline function isApplication():Bool return this.isApplication;
	public inline function isAudio():Bool return this.isAudio;
	public inline function isExample():Bool return this.isExample;
	public inline function isImage():Bool return this.isImage;
	public inline function isMessage():Bool return this.isMessage;
	public inline function isModel():Bool return this.isModel;
	public inline function isMultipart():Bool return this.isMultipart;
	public inline function isText():Bool return this.isText;
	public inline function isVideo():Bool return this.isVideo;
	
	public inline function isStandard():Bool return this.isStandard;
	public inline function isVendor():Bool return this.isVendor;
	public inline function isPersonal():Bool return this.isPersonal;
	public inline function isVanity():Bool return isPersonal();
	public inline function isUnregistered():Bool return this.isUnregistered;
	
	public inline function isXml():Bool return this.isXml;
	public inline function isJson():Bool return this.isJson;
	
	public var toplevel(get, never):Null<String>;
	public var tree(get, never):Null<String>;
	public var subtype(get, never):Null<String>;
	public var suffix(get, never):Null<String>;
	public var parameters(get, never):Null<StringMap<String>>;
	
	private inline function get_toplevel():Null<String> return this.toplevel;
	private inline function get_tree():Null<String> return this.tree;
	private inline function get_subtype():Null<String> return this.subtype;
	private inline function get_suffix():Null<String> return this.suffix;
	
	private inline function get_parameters():Null<StringMap<String>> {
		return this.parameters;
	}
	
	@:to public inline function toString():String {
		var result = '';
		if (toplevel != null) result += toplevel;
		if (tree != null && subtype == null) result += '/$tree';
		if (tree == null && subtype != null) result += '/$subtype';
		if (suffix != null) result += '+$suffix';
		if (parameters != null) for (key in parameters.keys()) {
			result += '; $key=${parameters.get(key)}';
		}
		return result;
	}
	
}

#if js
typedef MediaTypeStruct = {
	// Toplevel checks
	public var isApplication:Bool;
	public var isAudio:Bool;
	public var isExample:Bool;
	public var isImage:Bool;
	public var isMessage:Bool;
	public var isModel:Bool;
	public var isMultipart:Bool;
	public var isText:Bool;
	public var isVideo:Bool;
	
	public var toplevel:Null<String>;
	
	// Tree checks
	public var isStandard:Bool;
	public var isVendor:Bool;
	public var isPersonal:Bool;
	public var isUnregistered:Bool;
	
	public var tree:Null<String>;
	
	// Subtype
	public var subtype:Null<String>;
	
	// Suffix checks
	public var isXml:Bool;
	public var isJson:Bool;
	
	public var suffix:Null<String>;
	
	// Parameter
	public var parameters:Null<StringMap<String>>;
}
#else
@:structInit
class MediaTypeStruct {
	
	// Toplevel checks
	public var isApplication:Bool;
	public var isAudio:Bool;
	public var isExample:Bool;
	public var isImage:Bool;
	public var isMessage:Bool;
	public var isModel:Bool;
	public var isMultipart:Bool;
	public var isText:Bool;
	public var isVideo:Bool;
	
	public var toplevel:Null<String>;
	
	// Tree checks
	public var isStandard:Bool;
	public var isVendor:Bool;
	public var isPersonal:Bool;
	public var isUnregistered:Bool;
	
	public var tree:Null<String>;
	
	// Subtype
	public var subtype:Null<String>;
	
	// Suffix checks
	public var isXml:Bool;
	public var isJson:Bool;
	
	public var suffix:Null<String>;
	
	// Parameter
	public var parameters:Null<StringMap<String>>;
	
	public inline function new() {
		
	}
	
}
#end

abstract MediaTypeAbstract(Array<Token<MimeKeywords>>) from Array<Token<MimeKeywords>> to Array<Token<MimeKeywords>> {
	
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
	
	@:noCompletion @:from public inline static inline function fromString(v:String):MediaTypeAbstract {
		return new MediaTypeAbstract( new MimeParser().toTokens( ByteData.ofString( v ), 'mediatype-fromstring' ) );
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
			for (param in params) switch(param) {
				case Keyword(Parameter(name, value)): map.set(name, value);
				case _:
			};
			return map;
			
		} else {
			return null;
			
		}
	}
	
}
