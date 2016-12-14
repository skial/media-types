package uhx.macro.mime;

import uhx.types.*;
import haxe.macro.*;
import uhx.lexer.Mime;

using StringTools;
using haxe.macro.ExprTools;
using uhx.macro.mime.Helper;

/*@:forward abstract Pos({ min : Int, max : Int, file : String }) from { min : Int, max : Int, file : String } {

	public inline function new(v) this = v;

	@:from public static inline function fromPosition(v:Position):Pos {
		return Context.getPosInfos(v);
	}

}*/

private typedef Token = uhx.mo.Token<MimeKeywords>;
private typedef Tokens = Array<Token>;

class Helper {

	public static macro function mime(expr:Expr):Expr {
		var result = transform( expr );
		var mime:MediaTypeAbstract = result;

		if (result.length == 0) Context.error( 'Mime type expression `${expr.toString()}` can not be transformed', expr.pos );

		return macro @:pos(expr.pos) ($e{ mime.newMimeStruct() }:MediaTypeConst);
	} 

	#if macro
	private static function transform(expr:Expr):Tokens {
		var result = switch expr {
			case _.expr => EBlock(exprs) | EArrayDecl(exprs):
				var results = [];

				for (expr in exprs) for (token in transform(expr)) {
					results.push( token );

				}

				results;

			case macro $e1 / $e2:
				var toplevel = Keyword( Toplevel( e1.toString() ) );
				var rest = transform( e2 );
				rest.unshift( toplevel );
				rest;

			case _.expr => EField(e, name):
				var before = transform(e);
				
				switch before[before.length-1] { 
					case Keyword(Subtype(v)), Keyword(Tree(v)):
						before[before.length-1] = Keyword(Tree('$v.$name'));

					case _:
						before.push( Keyword(Tree(name)) );

				}

				before;

			case macro $e1 + $e2:
				var first = transform(e1);
				first.push( Keyword( Suffix( e2.toString() ) ) );
				first;

			case macro $e1 - $e2:
				// This might break as e2 is not being transformed.
				var first = transform(e1);
				
				first[first.length-1] = switch first[first.length-1] {
					case Keyword(Subtype(v)):
						Keyword(Subtype( '$v-' + e2.toString() ));

					case Keyword(Tree(v)):
						Keyword(Tree( '$v-' + e2.toString() ));

					case x:
						x;

				}

				first;

			case macro $i1 = $i2:
				[Keyword( Parameter( i1.toString().replace(' ', ''), i2.toString().replace(' ', '') ) )];
			
			case _.expr => EConst(CIdent(v)):
				[Keyword( Subtype( v ) )];

			case _:
				trace(expr);
				[];

		}

		return result;
	}

    public static function newMimeStruct(mime:MediaType, ?entry:MediaTypeEntry):Expr {
        var parameters = macro null;

		if (entry == null) entry = {
			charset: null,
			source: null,
			compressible: null,
			extensions: null,
		}
		
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
			charset: $v{entry.charset},
			source: $e{ entry.source != null ? macro ($v{entry.source}:MediaTypeSource) : macro null },
			compressible: $v{entry.compressible},
			extensions: $v{entry.extensions},
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
			charset: null,
			source: null,
			compressible: null,
			extensions: null,
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
	#end

}