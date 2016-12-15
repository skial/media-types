package uhx.types;

/**
 * ...
 * @author Skial Bainn
 */
typedef MediaType = 
#if !macro
uhx.types.MediaTypeConst
#else
uhx.types.MediaTypeAbstract
#end
;
