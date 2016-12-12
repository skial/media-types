package uhx.macro.mime;

import uhx.types.*;
import haxe.macro.*;

using StringTools;
using haxe.macro.ExprTools;
using uhx.macro.mime.Helper;

/*@:forward abstract Pos({ min : Int, max : Int, file : String }) from { min : Int, max : Int, file : String } {

	public inline function new(v) this = v;

	@:from public static inline function fromPosition(v:Position):Pos {
		return Context.getPosInfos(v);
	}

}*/

class Helper {

    public static function newMimeStruct(mime:MediaType):Expr {
        var parameters = macro null;
		
		if (mime.parameters != null) {
			var exprs = [];
			for (key in mime.parameters.keys()) exprs.push( macro $v{key}=>$v{mime.parameters.get(key)} );
			parameters = macro $a{exprs};
		}
        
        return macro @:mime ({ 
			// TODO generate random variable name as best as possible.
			// TODO figure out why @:structInit created classes does not work.
			//var mime:MediaTypeStruct = new MediaTypeStruct();
			isApplication: $v{mime.isApplication()},
			isAudio: $v{mime.isAudio()},
			isExample: $v{mime.isExample()},
			isImage: $v{mime.isImage()},
			isMessage: $v{mime.isMessage()},
			isModel: $v{mime.isModel()},
			isMultipart: $v{mime.isMultipart()},
			isText: $v{mime.isText()},
			isVideo: $v{mime.isVideo()},
			isStandard: $v{mime.isStandard()},
			isVendor: $v{mime.isVendor()},
			isPersonal: $v{mime.isPersonal()},
			isUnregistered: $v{mime.isUnregistered()},
			isXml: $v{mime.isXml()},
			isJson: $v{mime.isJson()},
			toplevel: $v{mime.toplevel},
			tree: $v{mime.tree},
			subtype: $v{mime.subtype},
			suffix: $v{mime.suffix},
			parameters: $parameters,
			original: $v{mime.toString()},
		}:MediaTypeStruct);
    }

    public static function newRuntimeMimeStruct(ident:Expr):Expr {
        return macro @:mime ({
			//var struct:MediaTypeStruct = new MediaTypeStruct();
			isApplication: $ident.isApplication(),
			isAudio: $ident.isAudio(),
			isExample: $ident.isExample(),
			isImage: $ident.isImage(),
			isMessage: $ident.isMessage(),
			isModel: $ident.isModel(),
			isMultipart: $ident.isMultipart(),
			isText: $ident.isText(),
			isVideo: $ident.isVideo(),
			isStandard: $ident.isStandard(),
			isVendor: $ident.isVendor(),
			isPersonal: $ident.isPersonal(),
			isUnregistered: $ident.isUnregistered(),
			isXml: $ident.isXml(),
			isJson: $ident.isJson(),
			toplevel: $ident.toplevel,
			tree: $ident.tree,
			subtype: $ident.subtype,
			suffix: $ident.suffix,
			parameters: $ident.parameters,
			original: @:this this.toString(),
		}:MediaTypeStruct);
    }

    public static function store(mime:MediaType, storage:ObjectDecl):Void {
        //trace( mime.toplevel, mime.tree, mime.subtype, mime.suffix, mime.parameters );
        var paths = [];

		for (v in [mime.toplevel, mime.tree, mime.subtype, mime.suffix]) if (v != null) {
			if (containsIllegals(v)) {
				for (i in splitIllegals(v)) {
					paths.push(i.prefixIllegals());
					
				}
				
			} else {
				paths.push(v.prefixIllegals());
				
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
	private static var keywords:Array<String> = [
		'package', 'import', 'class', 'abstract', 'interface', 'enum', 'typedef',
		'var', 'switch', 'case', 'default'
	];
	
	private static function replaceIllegals(value:String):String {
		return splitIllegals( value ).map( capitalize1st ).join('_');
	}
	
	private static inline function splitIllegals(value:String):Array<String> {
		return illegals.split( value );
	}
	
	private static inline function containsIllegals(value:String):Bool {
		return illegals.match( value );
	}

	private static function prefixDigits(value:String):String {
		return value.charCodeAt(0) >= '0'.code && value.charCodeAt(0) <= '9'.code ? '_$value' : value;
	}

	private static function prefixIllegals(value:String):String {
		return keywords.indexOf( value = value.prefixDigits() ) > -1 ? '_$value' : value;
	}

}