package uhx.types;

@:enum abstract MediaTypeSource(String) from String to String {
	public var Apache = 'apache';
	public var IANA = 'iana';
	public var NGINX = 'nginx';
}