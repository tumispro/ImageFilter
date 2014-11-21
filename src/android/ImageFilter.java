package com.plugin.imageFilter;

import org.json.JSONArray;

import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;


public class ImageFilter extends CordovaPlugin {
	
	@Override
	public boolean execute(String action, JSONArray data, CallbackContext callbackContext) {
		boolean result = false;
		
		final Filters filters = new Filters();
		
		if(action.equalsIgnoreCase("none")){
			 String fileInfo = filters.none(optionsArr);
			 //result = new PluginResult(Status.OK, fileInfo);
			 
			 result = true;
			 callbackContext.success(fileInfo);
		}
		if(action.equalsIgnoreCase("stark")){
			 String fileInfo = filters.stark(optionsArr);
			// result = new PluginResult(Status.OK, fileInfo);
			 
			 result = true;
			 callbackContext.success(fileInfo);
		}
		if(action.equalsIgnoreCase("sunnySide")){
			 String fileInfo = filters.sunnyside(optionsArr);
			 //result = new PluginResult(Status.OK, fileInfo);
			 
			 result = true;
			 callbackContext.success(fileInfo);
		}
		
		if(action.equalsIgnoreCase("vintage")){
			 String fileInfo = filters.vintage(optionsArr);
			 //result = new PluginResult(Status.OK, fileInfo);
			 
			 result = true;
			 callbackContext.success(fileInfo);
		}
		if(action.equalsIgnoreCase("worn")){
			 String fileInfo = filters.worn(optionsArr);
			 //result = new PluginResult(Status.OK, fileInfo);
			 
			 result = true;
			 callbackContext.success(fileInfo);
		}

		return result;
	}
	
}