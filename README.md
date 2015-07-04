# media-types

A little library which adds the `MediaType` abstract type.

Media types are also known as mime types and internet types.

## Terms

```
text/plain; charset=UTF-8
custom/vnd.name+xml; name1=value1; name2=value2
```

breaks down into the following terms.

```
toplevel/subtype; parameters(name=value)
toplevel/tree+suffix; parameters(name=value); parameters(name=value)
```

## Installation

You need to install the following libraries from GitHub.

1. hxparser - `haxelib git hxparse https://github.com/Simn/hxparse development src`
2. mo - `haxelib git mo https://github.com/skial/mo master src`
3. media-types - `haxelib git media-types https://github.com/skial/media-types master src`

Then in your `.hxml` file, add `-lib media-types` and you're set.
	
## Usage

Create a variable, typed as `MediaType` with a `String` value containing a media type.

```Haxe
package ;

class Main {
	
	public static function main() {
		var mt:MediaType = 'text/plain; charset=UTF-8';
	}
	
}
```

## Api

```Haxe
abstract MediaType {
	
	// Toplevel
	public function isApplication():Bool;	// `application/*`
	public function isAudio():Bool;		// `audio/*`
	public function isExample():Bool;	// `example/*`
	public function isImage():Bool;		// `image/*`
	public function isMessage():Bool;	// `message/*`
	public function isModel():Bool;		// `model/*`
	public function isMultipart():Bool;	// `multipart`
	public function isText():Bool;		// `text/*`
	public function isVideo():Bool;		// `video/*`
	
	public var toplevel(get, never):Null<String>;
	
	// Tree
	public function isStandard():Bool;	// `true` if its a subtype not a tree.
	public function isVendor():Bool;	// `*/vnd.*`
	public function isPersonal():Bool;	// `*/prs.*`
	public function isVanity():Bool;	// Same as `isPersonal()`
	public function isUnregistered():Bool;	// `*/x.*`
	
	public var tree(get, never):Null<String>;
	
	// Subtype
	public var subtype(get, never):Null<String>;
	
	// Suffix
	public function isXml():Bool;	// `*/*+json`
	public function isJson():Bool;	// `*/*+xml`
	
	public var suffix(get, never):Null<String>;
	
	// Parameters
	public var parameters(get, never):Null<StringMap<String>>;
	
}
```

## Examples

You can find a handful of tests in the [uhu-spec](https://github.com/skial/uhu-spec/blob/master/src/uhx/mt/MediaTypeSpec.hx) repository.