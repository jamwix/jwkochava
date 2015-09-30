package com.jamwix;


import java.lang.Runnable;

import android.app.Activity;
import android.content.res.AssetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.util.Log;
import org.json.JSONObject;
import org.json.JSONException;
import java.util.HashMap;

import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

import com.kochava.android.tracker.Feature;

/* 
	You can use the Android Extension class in order to hook
	into the Android activity lifecycle. This is not required
	for standard Java code, this is designed for when you need
	deeper integration.
	
	You can access additional references from the Extension class,
	depending on your needs:
	
	- Extension.assetManager (android.content.res.AssetManager)
	- Extension.callbackHandler (android.os.Handler)
	- Extension.mainActivity (android.app.Activity)
	- Extension.mainContext (android.content.Context)
	- Extension.mainView (android.view.View)
	
	You can also make references to static or instance methods
	and properties on Java classes. These classes can be included 
	as single files using <java path="to/File.java" /> within your
	project, or use the full Android Library Project format (such
	as this example) in order to include your own AndroidManifest
	data, additional dependencies, etc.
	
	These are also optional, though this example shows a static
	function for performing a single task, like returning a value
	back to Haxe from Java.
*/
public class JWKochava extends Extension {

    private static Handler mHandler = new Handler(Looper.getMainLooper());

    private static final String TAG = "JWKochava";

    private static Feature _kTracker;

	/**
	 * Called when an activity you launched exits, giving you the requestCode 
	 * you started it with, the resultCode it returned, and any additional data 
	 * from it.
	 */
	public boolean onActivityResult (int requestCode, int resultCode, Intent data) {
        Log.d(TAG, "onActivityResult");
		
		return true;
		
	}
	
	
	/**
	 * Called when the activity is starting.
	 */
	public void onCreate (Bundle savedInstanceState) {
		
	}
	
	
	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	public void onDestroy () {
		
		
		
	}
	
	
	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	public void onPause () {
		
		
		
	}
	
	
	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	public void onRestart () {
		
		
		
	}
	
	
    public static void initKochava(String sOptions) {
        String appId;
        String currency;

        try {
            JSONObject options = new JSONObject(sOptions);
            appId = options.getString("kochavaAppId");
            currency = options.getString("currency");
        } catch (JSONException e) {
            Log.e(TAG, "Unable to parse kochava init params");
            return;
        }

        final HashMap<String, Object> datamap = new HashMap<String, Object>();
        datamap.put(Feature.INPUTITEMS.KOCHAVA_APP_ID , appId );
        datamap.put(Feature.INPUTITEMS.CURRENCY , currency);

        mHandler.post(new Runnable() {
            public void run() {
                _kTracker = new Feature( Extension.mainContext, datamap);
            }
        });
    }

    public static void trackEvent(String title, String value) {
        final String myTitle = title;
        final String myValue = value;
        mHandler.post(new Runnable() {
            public void run() {
                _kTracker.event(myTitle, myValue);
            }
        });
    }


	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	public void onResume () {
		
	}
	
	
	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	public void onStart () {
		
		
		
	}
	
	
	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	public void onStop () {
		
		
		
	}
	
	
}
