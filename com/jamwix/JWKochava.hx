package com.jamwix;

#if cpp
import cpp.Lib;
#elseif neko
import neko.Lib;
#end

import haxe.Json;

#if (android && openfl)
import openfl.utils.JNI;
#end


class JWKochava {
	#if android
	private static var jwkochava_init = 
		JNI.createStaticMethod("com.jamwix.JWKochava", "initKochava", "(Ljava/lang/String;)V");
	private static var jwkochava_track_event = 
		JNI.createStaticMethod("com.jamwix.JWKochava", "trackEvent", "(Ljava/lang/String;Ljava/lang/String;)V");
	#elseif ios
	private static var jwkochava_init = Lib.load("jwkochava", "jwkochava_init", 1);
	private static var jwkochava_track_event = Lib.load("jwkochava", "jwkochava_track_event", 2);
	private static var jwkochava_get_kochava_id = Lib.load("jwkochava", "jwkochava_get_kochava_id", 0);
	private static var jwkochava_identity_link = Lib.load("jwkochava", "jwkochava_identity_link", 1);
	#end

	private static var _initialized = false;

	public static function init(appId:String, currency:String = "usd", 
								limitAdtracking:Bool = false, enableLogging:Bool = false):Void 
	{
#if (ios || android)
		if (_initialized) return;

		var options:Dynamic = 
		{
			kochavaAppId: appId,
			currency: currency,
			limitAdtracking: limitAdtracking ? 1 : 0,
			enableLogging: enableLogging ? 1 : 0
		};
		jwkochava_init(Json.stringify(options));

		_initialized = true;
#end
	}
	
	public static function trackEvent(title:String, value:String)
	{
#if (ios || android)
		jwkochava_track_event(title, value);
#end
	}

	public static function identityLink(opts:Dynamic)
	{
		if (opts == null) return;

		var optsStr:String = "{}";
		try
		{
			optsStr = Json.stringify(opts);
		}
		catch (err:String)
		{
			trace("identityLink stringify err: " + err);
		}

#if (ios || android)
		jwkochava_identity_link(optsStr);
#end
	}

	public static function getKochavaId():String
	{
#if (ios || android)
		return jwkochava_get_kochava_id();
#else
		return null;
#end
	}
}
