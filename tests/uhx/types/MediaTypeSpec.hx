package uhx.types;

import utest.Assert;
import uhx.types.MediaType;
import uhx.types.MediaTypes;
import uhx.macro.mime.Helper.mime;

#if macro
import uhx.types.ObjectDecl;

using haxe.macro.ExprTools;
using uhx.macro.mime.Helper;
#end

/**
 * ...
 * @author Skial Bainn
 */
@:keep
class MediaTypeSpec {

	public function new() {
		
	}
	
	public function testFromString() {
		var mt:MediaType = 'text/plain';
		
		Assert.equals( 'text', mt.toplevel );
		Assert.equals( 'plain', mt.subtype );
		Assert.isTrue( mt.isText() );
		Assert.isNull( mt.suffix );
		Assert.isNull( mt.parameters );
		Assert.equals( 'text/plain', '$mt' );
	}
	
	public function testSuffix() {
		var mt:MediaType = 'text/plain+xml';
		
		Assert.equals( 'xml', mt.suffix );
		Assert.isTrue( mt.isXml() );
		Assert.isFalse( mt.isJson() );
	}
	
	public function testParameter() {
		var mt:MediaType = 'text/plain; charset=UTF-8';
		var params = mt.parameters;
		
		Assert.isTrue( params != null );
		Assert.isTrue( params.exists( 'charset' ) );
		Assert.equals( 'UTF-8', params.get( 'charset' ) );
	}
	
	public function testMultiParameters() {
		var mt:MediaType = 'text/plain; charset=UTF-8; name=value; hello=world';
		var params = mt.parameters;
		
		Assert.isTrue( params != null );
		Assert.isTrue( params.exists( 'charset' ) );
		Assert.isTrue( params.exists( 'name' ) );
		Assert.isTrue( params.exists( 'hello' ) );
		Assert.equals( 'UTF-8', params.get( 'charset' ) );
		Assert.equals( 'value', params.get( 'name' ) );
		Assert.equals( 'world', params.get( 'hello' ) );
	}
	
	public function testTree() {
		var mt:MediaType = 'text/vnd.a.b.1.2';
		
		Assert.isTrue( mt.isVendor() );
		Assert.isFalse( mt.isPersonal() );
		Assert.isFalse( mt.isVanity() );
		Assert.isFalse( mt.isStandard() );
		Assert.isFalse( mt.isUnregistered() );
		Assert.equals( 'vnd.a.b.1.2', mt.tree );
	}
	
	public function testVariable_Macro() {
		var mime = 'text/plain';
		var mt:MediaType = mime;
		
		Assert.equals( 'text', mt.toplevel );
		Assert.equals( 'plain', mt.subtype );
		Assert.isTrue( mt.isText() );
		Assert.isNull( mt.suffix );
		Assert.isNull( mt.parameters );
		Assert.equals( 'text/plain', '$mt' );
	}
	
	#if macro
	@:access(uhx.macro)
	public function testTemplateBuilder_haxifySimple() {
		var mime:MediaType = 'text/plain';
		var tmpToplevel = new ObjectDecl();
		
		mime.store( tmpToplevel );
		
		Assert.equals( '{ text : { plain : "text/plain" } }', tmpToplevel.toExpr().toString() );
	}
	
	@:access(uhx.macro)
	public function testTemplateBuilder_haxeifyComplex() {
		var mime:MediaType = 'text/vnd.a.b.c; charset=UTF-8;';
		var tmpToplevel = new ObjectDecl();

		mime.store( tmpToplevel );
		
		Assert.equals( '{ text : { vnd : { a : { b : { c : "text/vnd.a.b.c; charset=UTF-8" } } } } }', tmpToplevel.toExpr().toString() );
	}
	
	@:access(uhx.macro)
	public function testTemplateBuilder_haxeifyOverlap() {
		var m1:MediaType = 'text/vnd.a; a=b;';
		var m2:MediaType = 'text/vnd.a.b';
		var tmpToplevel = new ObjectDecl();
		
		m1.store( tmpToplevel );
		m2.store( tmpToplevel );
		
		Assert.equals( '{ text : { vnd : { a : { toString : function() return "text/vnd.a; a=b", b : "text/vnd.a.b" } } } }', tmpToplevel.toExpr().toString() );
	}
	#end

	public function testMediaTypes() {
		var mime = MediaTypes.Text_Plain;

		Assert.equals( 'text', mime.toplevel );
		Assert.equals( 'plain', mime.subtype );
		Assert.isTrue( mime.isText() );
		Assert.isNull( mime.parameters );
		Assert.equals( 'text/plain', mime.toString() );
	}

	public function testMediaTypes_extraInfo() {
		var mime = MediaTypes.Video_X_Ms_Wmv;

		Assert.isNull( mime.charset );
		Assert.isFalse( mime.compressible );
		Assert.equals( '[wmv]', '' + mime.extensions );
		Assert.equals( MediaTypeSource.Apache, mime.source );

		var mime = MediaTypes.Text_Vtt;

		Assert.equals( 'UTF-8', mime.charset );
	}

	public function testMediaType_haxeExpression() {
		// Can't have `text/vnd.a.1.2` as the numbers are invalid haxe access.
		// TODO consider adding array access `a[1][2]` notation which gets converted to `a.1.2`.
		var mime = mime([text/vnd.a.b-c.d.e.f+txt, charset=UTF-8, hello=world, name=skial-bainn]);

		Assert.equals( 'text', mime.toplevel );
		Assert.isTrue( mime.isVendor() );
		Assert.equals( 'vnd.a.b-c.d.e.f', mime.tree );
		
	}
	
}
