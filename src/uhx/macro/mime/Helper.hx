package uhx.macro.mime;

import uhx.types.*;
import haxe.macro.*;

using StringTools;
using uhx.macro.mime.Helper;

class Helper {

    public static function newMimeStruct(mime:MediaType):Expr {
        var parameters = macro null;
		
		if (mime.parameters != null) {
			var exprs = [];
			for (key in mime.parameters.keys()) exprs.push( macro $v{key}=>$v{mime.parameters.get(key)} );
			parameters = macro $a{exprs};
		}
        
        return macro @:mergeBlock { 
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
			mime;
		}
    }

    public static function newRuntimeMimeStruct(ident:Expr):Expr {
        return macro @:mergeBlock {
			var struct:MediaTypeStruct = new MediaTypeStruct();
			struct.isApplication = ($ident.isApplication():Bool);
			struct.isAudio = ($ident.isAudio():Bool);
			struct.isExample = ($ident.isExample():Bool);
			struct.isImage = ($ident.isImage():Bool);
			struct.isMessage = ($ident.isMessage():Bool);
			struct.isModel = ($ident.isModel():Bool);
			struct.isMultipart = ($ident.isMultipart():Bool);
			struct.isText = ($ident.isText():Bool);
			struct.isVideo = ($ident.isVideo():Bool);
			struct.isStandard = ($ident.isStandard():Bool);
			struct.isVendor = ($ident.isVendor():Bool);
			struct.isPersonal = ($ident.isPersonal():Bool);
			struct.isUnregistered = ($ident.isUnregistered():Bool);
			struct.isXml = ($ident.isXml():Bool);
			struct.isJson = ($ident.isJson():Bool);
			struct.toplevel = ($ident.toplevel:Null<String>);
			struct.tree = ($ident.tree:Null<String>);
			struct.subtype = ($ident.subtype:Null<String>);
			struct.suffix = ($ident.suffix:Null<String>);
			struct.parameters = $ident.parameters;
		}
    }

    public static function store(mime:MediaType, storage:ObjectDecl):Void {
        //trace( mime.toplevel, mime.tree, mime.subtype, mime.suffix, mime.parameters );
        var paths = [];

		for (v in [mime.toplevel, mime.tree, mime.subtype, mime.suffix]) if (v != null) {
			if (containsIllegals(v)) {
				for (i in splitIllegals(v)) {
					paths.push(i);
					
				}
				
			} else {
				paths.push(v);
				
			}
			
		}
		
		var obj:ObjectDecl = storage;
		
		for (i in 0...paths.length) {
			var path = paths[i];
			
			if (!obj.exists( path )) {
				if (i < paths.length-1) {
					obj.set( path, { expr: EObjectDecl(obj = new ObjectDecl()), pos: Context.currentPos() } );
					
				} else {
					obj.set( path, macro $v{mime.toString()} );
					
				}
				
			} else {
				switch obj.get( path ) {
					case _.expr => EConst(CString(v)):
						obj.set( path, { expr: EObjectDecl(obj = [{field:'toString', expr:macro function() return $v{v}}]), pos: Context.currentPos() } );
						
					case _:
						obj = (obj.get( path ):ObjectDecl);
						
				}
				
			}
			
		}

    }

    public static function haxeify(mime:MediaType):String {
		var result = '';

		if (mime.toplevel != null) result += mime.toplevel.replaceIllegals() + '_';
		if (mime.tree != null && mime.subtype == null) result += '${mime.tree.replaceIllegals()}';
		if (mime.tree == null && mime.subtype != null) result += '${mime.subtype.replaceIllegals()}';
		if (mime.suffix != null) result += '_${mime.suffix.capitalize1st()}';
		if (mime.parameters != null) for (key in mime.parameters.keys()) {
			result += '_${key.capitalize1st()}_${mime.parameters.get(key).capitalize1st()}';
			
		}
		
		return result;
	}

    private static function capitalize1st(value:String):String {
		return value.charAt(0).toUpperCase() + value.substr(1);
	}
	
	private static var illegals:EReg = ~/[\.\-]/ig;
	
	private static function replaceIllegals(value:String):String {
		return splitIllegals( value ).map( capitalize1st ).join('_');
	}
	
	private static inline function splitIllegals(value:String):Array<String> {
		return illegals.split( value );
	}
	
	private static inline function containsIllegals(value:String):Bool {
		return illegals.match( value );
	}

}