package uhx.macro.mime;

import uhx.types.MediaTypeSource;

typedef MediaTypeEntry = {
	@:optional var charset:String;
	@:optional var compressible:Bool;
	@:optional var source:MediaTypeSource;
	@:optional var extensions:Array<String>;
}