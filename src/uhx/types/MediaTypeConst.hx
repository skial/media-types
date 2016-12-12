package uhx.types;

import haxe.ds.StringMap;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import uhx.macro.mime.Helper;

using haxe.macro.ExprTools;
using uhx.macro.mime.Helper;
#end

abstract MediaTypeConst(MediaTypeStruct) from MediaTypeStruct {

	@:from public static macro function fromExpr(v:Expr) {
		var result = macro @:pos(v.pos) throw 'Could not convert the expression ' + $v{v.toString()} + ' to a mime type.';
		var local = haxe.macro.Context.getLocalType();
		var method = haxe.macro.Context.getLocalMethod();

		switch v {
			case _.expr => EConst(CString(value)):
				var mime = (value:uhx.types.MediaTypeAbstract);
				result = macro ($e{mime.newMimeStruct()}:MediaTypeConst);
				
			case _:
				var struct = Helper.newRuntimeMimeStruct(macro mime);
                
				result = macro @:mergeBlock { 
					var mime = ($v:MediaTypeAbstract);
					($struct:MediaTypeConst);
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

}