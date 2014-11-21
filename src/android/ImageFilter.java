package com.plugin.imageFilter;

import org.json.JSONArray;

import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.PluginResult.Status;


public class ImageFilter extends CordovaPlugin {
	
	@Override
	public PluginResult execute(String action, JSONArray optionsArr, String callBackId){
		Log.d("imageFilter", "PLUGIN execute called with action: "+ action);	
		PluginResult result = null;
		
		final Filters filters = new Filters();
		
		if(action.equalsIgnoreCase("none")){
			 String fileInfo = filters.none(optionsArr);
			 result = new PluginResult(Status.OK, fileInfo);
		}
		if(action.equalsIgnoreCase("stark")){
			 String fileInfo = filters.stark(optionsArr);
			 result = new PluginResult(Status.OK, fileInfo);
		}
		if(action.equalsIgnoreCase("sunnySide")){
			 String fileInfo = filters.sunnyside(optionsArr);
			 result = new PluginResult(Status.OK, fileInfo);
		}
		if(action.equalsIgnoreCase("pinhole")){
			 String fileInfo = filters.pinhole(optionsArr);
			 result = new PluginResult(Status.OK, fileInfo);
		}
		if(action.equalsIgnoreCase("vintage")){
			 String fileInfo = filters.vintage(optionsArr);
			 result = new PluginResult(Status.OK, fileInfo);
		}
		if(action.equalsIgnoreCase("worn")){
			 String fileInfo = filters.worn(optionsArr);
			 result = new PluginResult(Status.OK, fileInfo);
		}

		return result;
	}
	
}