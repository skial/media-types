package uhx.types;

import haxe.ds.StringMap;

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
