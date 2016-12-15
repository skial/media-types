package uhx.types;

import haxe.macro.Expr;
import haxe.DynamicAccess;
import haxe.macro.Context;

@:forward abstract ObjectDecl(Array<{field:String, expr:Expr}>) from Array<{field:String, expr:Expr}> to Array<{field:String, expr:Expr}> {
	
	public inline function new() this = [];
	
	public inline function exists(key:String):Bool {
		var result = false;
		
		for (obj in this) if (obj.field == key) {
			result = true;
			break;
			
		}
		
		return result;
	}
	
	@:arrayAccess @:noCompletion public inline function get(key:String):Null<Expr> {
		var result = null;
		
		for (obj in this) if (obj.field == key) {
			result = obj.expr;
			break;
		}
		
		return result;
	}
	
	@:arrayAccess @:noCompletion public inline function set(key:String, value:Expr) {
		if (get(key) == null) {
			this.push( { field:key, expr:value });
			
		} else {
			for (obj in this) if (obj.field == key) {
				obj.expr = value;
				break;
				
			}
			
		}
		
		return value;
	}
	
	@:arrayAccess @:noCompletion public inline function writeString(key:String, value:String) {
		set(key, macro $v{value});
		return value;
	}
	
	@:arrayAccess @:noCompletion public inline function writeDynamicAccess(key:String, value:DynamicAccess<Expr>) {
		set(key, fromDynamicAccess(value));
		return value;
	}
	
	public function keys() {
		return [for (obj in this) obj.field];
	}
	
	@:to public function toExpr():Expr {
		return { 
			expr: EObjectDecl( [for (key in keys()) {
				field: key, expr: get( key ),
			}] ), 
			pos: haxe.macro.Context.currentPos()
		};
	}
	
	@:from public static function fromExpr(v:Expr):ObjectDecl {
		return switch v {
			case _.expr => EObjectDecl(fields): fields;
			case _: throw '$v is not a valid type, only EObjectDecl(_) can be used.';
		}
	}
	
	@:from public static function fromDynamicAccess(v:DynamicAccess<Expr>):ObjectDecl {
		return [for (key in v.keys()) {field:key, expr:v.get(key)}];
	}
	
}
