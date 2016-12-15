package uhx.types;

import haxe.ds.StringMap;

@:structInit
class MediaTypeStruct {
	
	private var original:Null<String>;

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

	public function toString():String {
		return if (original != null) {
			original;

		} else {
			var result = '';
			if (toplevel != null) result += toplevel;
			if (tree != null && subtype == null) result += '/$tree';
			if (tree == null && subtype != null) result += '/$subtype';
			if (suffix != null) result += '+$suffix';
			if (parameters != null) for (key in parameters.keys()) {
				result += '; $key=${parameters.get(key)}';
			}
			
			result;

		}

	}

	// Compile time embedded info.

	public var charset:Null<String>;
 	public var compressible:Null<Bool>;
	public var source:Null<MediaTypeSource>;
	public var extensions:Null<Array<String>>;
	
}
