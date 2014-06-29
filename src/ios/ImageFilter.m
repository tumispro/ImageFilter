//
//  ImageFilter.m
//
//  Created by Drew Dahlman 2/25/2012. 
//  Copyright 2012 Drew Dahlman. All rights reserved.
//
//  Updated by Henry Ruhl 4/20/2014
//
//  version 1.1

/*
Copyright (c) 2012 Drew Dahlman MIT LICENSE
*/

#import "ImageFilter.h"

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@implementation ImageFilter 

@synthesize callbackID;

// For clean up purposes sometimes the apps will cache images, so this cleans things up
-(void)clean:(CDVInvokedUrlCommand*)command;
{
	NSString *result = @"Image = ";
	
	NSMutableDictionary* options = [command.arguments objectAtIndex:0];
	NSString *filePath = [options objectForKey:@"image"];
	
	result = [result stringByAppendingString:filePath];
	result = [result stringByAppendingString:@" , Directory = "];
	
    // Path to the Documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        NSError *error = nil;  
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Print out the path to verify we are in the right place
        NSString *directory = [paths objectAtIndex:0];
        NSLog(@"Directory: %@", directory);
        
		result = [result stringByAppendingString:directory];
        // For each file in the directory, create full path and delete the file
        for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error])
        {    
            NSString *filePath = [directory stringByAppendingPathComponent:file];
            NSLog(@"File : %@", filePath);
			
			 result = [result stringByAppendingString:@" , File = "];
			 result = [result stringByAppendingString:filePath];
            
            BOOL fileDeleted = [fileManager removeItemAtPath:filePath error:&error];
            
            if (fileDeleted != YES || error != nil)
            {
                
            }
        }
        
    }
	
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	
    NSLog(@"CLEAN!");
}

// FILTERS
// Each filter uses the CoreImage Framework, and can be changed and added to.
// If you wish to create a new filter use the none as a template.
-(void)none:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    // Start by getting path to image
    NSString *filePath = [options objectForKey:@"image"];
    // CREATE NSURL
    NSURL *fileNameAndPath = [NSURL URLWithString:filePath];
    NSLog(@"FILE PATH: %@",fileNameAndPath);
    
    // DEFINE OUR CIImage
    CIImage *beginImage = 
    [CIImage imageWithContentsOfURL:fileNameAndPath];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // DO ALL MODIFICATIONS HERE.
    
    
    // CREATE CIIMageRef from our CIImage
    // Be sure to reference the correct CIImage in both the createCGIImage and fromRect
    CGImageRef cgimg = 
    [context createCGImage:beginImage fromRect:[beginImage extent]];
    
    // CREATE UIImage out of CIImage
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    // GET IMAGE DATA AND CONSTRUCT URL TO THE APPS DOCUMENT FOLDER
    NSData *imageData = UIImageJPEGRepresentation(newImg,1.0);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSString *documentsPath = [paths objectAtIndex:0]; 
    NSString *filePathB = [documentsPath stringByAppendingPathComponent:@"none.jpg"]; 
    
    // SAVE IMAGE DATA TO DOCUMENTS FOLDER
    [imageData writeToFile:filePathB atomically:YES];
    
    // CHECK IF THE SAVE KEY IS SET TO TRU
    NSString *save = [options objectForKey:@"save"];
    NSLog(@"SAVED: %@",save);
    
    // IF TRUE THEN SAVE IMAGE TO CAMERA ROLL
    if([save isEqualToString:@"true"]){
        UIImageWriteToSavedPhotosAlbum(newImg, nil, nil, nil);
    }
    
    // RELEASE OUR IMAGE AND DONE
    CGImageRelease(cgimg);
    
    // CALLBACK TO JAVASCRIPT WITH IMAGE URI
    self.callbackID = [arguments pop];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK 
                                                messageAsString:filePathB];
    
    /* Create JS to call the success function with the result */
    NSString *successScript = [pluginResult toSuccessCallbackString:self.callbackID];
    /* Output the script */
    [self writeJavascript:successScript];

    
    
}
-(void)stark:(CDVInvokedUrlCommand*)command;
{
    // get options
	NSMutableDictionary* options = [command.arguments objectAtIndex:0];

	// get file path
	NSString *filePath = [options objectForKey:@"image"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *oDocumentsPath = [paths objectAtIndex:0];
	oDocumentsPath = [oDocumentsPath stringByAppendingString:filePath];
	
	// convert file path to imageurl
	NSURL *fileNameAndPath = [NSURL fileURLWithPath:oDocumentsPath];  
	
	// do the filtering
    CIImage *beginImage = 
    [CIImage imageWithContentsOfURL:fileNameAndPath];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls" 
                                  keysAndValues: kCIInputImageKey, beginImage, 
                        @"inputSaturation", [NSNumber numberWithFloat:.1],
                        @"inputContrast", [NSNumber numberWithFloat:1], 
                        nil];
    CIImage *outputImage = [filter outputImage];
    
    CIFilter *filterB = [CIFilter filterWithName:@"CIGammaAdjust" 
                                  keysAndValues: kCIInputImageKey, outputImage, 
                        @"inputPower", [NSNumber numberWithFloat:1.5], 
                        nil];
    
    CIImage *outputImageB = [filterB outputImage];
    
    // convert the filtered image to a UIImage
    CGImageRef cgimg = [context createCGImage:outputImageB fromRect:[outputImageB extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
	// store the file in the docs directory
	NSData *imageData = UIImageJPEGRepresentation(newImg,1.0);
	NSString *documentsPath = [paths objectAtIndex:0];
	
    int r = arc4random() % 5000;
	NSString *random = [NSString stringWithFormat:@"%d", r];
	NSString *tPathA = [documentsPath stringByAppendingPathComponent:@"stark"];
	NSString *tPathB = [tPathA stringByAppendingString:random];
	NSString *filePathB = [tPathB stringByAppendingString:@".jpg"];
    
    [imageData writeToFile:filePathB atomically:YES];
    
	// save the file if requested
    NSString *save = [options objectForKey:@"save"];
    if([save isEqualToString:@"true"]){
        UIImageWriteToSavedPhotosAlbum(newImg, nil, nil, nil);
    }
	
	//release the image
    CGImageRelease(cgimg);
    
	//callback with path
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:filePathB];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
-(void)sunnySide:(CDVInvokedUrlCommand*)command;
{
	// get options
	NSMutableDictionary* options = [command.arguments objectAtIndex:0];

	// get file path
	NSString *filePath = [options objectForKey:@"image"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *oDocumentsPath = [paths objectAtIndex:0];
	oDocumentsPath = [oDocumentsPath stringByAppendingString:filePath];
	
	// convert file path to imageurl
	NSURL *fileNameAndPath = [NSURL fileURLWithPath:oDocumentsPath];  
	
	// do the filtering
    CIImage *beginImage = 
    [CIImage imageWithContentsOfURL:fileNameAndPath];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIWhitePointAdjust" 
                                  keysAndValues: kCIInputImageKey, beginImage, 
                        @"inputColor",[CIColor colorWithRed:254 green:197 blue:0 alpha:1],
                        nil];
    CIImage *outputImage = [filter outputImage];
    
    CIFilter *filterB = [CIFilter filterWithName:@"CITemperatureAndTint" 
                                keysAndValues: kCIInputImageKey, outputImage, 
                        @"inputNeutral",[CIVector vectorWithX:5500 Y:1300 Z:0],
                        @"inputTargetNeutral",[CIVector vectorWithX:4000 Y:0 Z:0],
                        nil];
    CIImage *outputImageB = [filterB outputImage];
    
    // convert the filtered image to a UIImage
    CGImageRef cgimg = [context createCGImage:outputImageB fromRect:[outputImageB extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
	// store the file in the docs directory
	NSData *imageData = UIImageJPEGRepresentation(newImg,1.0);
	NSString *documentsPath = [paths objectAtIndex:0];
	
    int r = arc4random() % 5000;
	NSString *random = [NSString stringWithFormat:@"%d", r];
	NSString *tPathA = [documentsPath stringByAppendingPathComponent:@"sunnyside"];
	NSString *tPathB = [tPathA stringByAppendingString:random];
	NSString *filePathB = [tPathB stringByAppendingString:@".jpg"];
    
    [imageData writeToFile:filePathB atomically:YES];
    
	// save the file if requested
    NSString *save = [options objectForKey:@"save"];
    if([save isEqualToString:@"true"]){
        UIImageWriteToSavedPhotosAlbum(newImg, nil, nil, nil);
    }
	
	//release the image
    CGImageRelease(cgimg);
    
	//callback with path
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:filePathB];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
-(void)worn:(CDVInvokedUrlCommand*)command;
{
	// get options
	NSMutableDictionary* options = [command.arguments objectAtIndex:0];

	// get file path
	NSString *filePath = [options objectForKey:@"image"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *oDocumentsPath = [paths objectAtIndex:0];
	oDocumentsPath = [oDocumentsPath stringByAppendingString:filePath];
	
	// convert file path to imageurl
	NSURL *fileNameAndPath = [NSURL fileURLWithPath:oDocumentsPath];  
	
	// do the filtering
    CIImage *beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    CIContext *context = [CIContext contextWithOptions:nil];
   
    CIFilter *filter = [CIFilter filterWithName:@"CIWhitePointAdjust" 
                                  keysAndValues: kCIInputImageKey, beginImage, 
                        @"inputColor",[CIColor colorWithRed:212 green:235 blue:241 alpha:1],
                        nil];
    CIImage *outputImage = [filter outputImage];
    
    CIFilter *filterB = [CIFilter filterWithName:@"CIColorControls" 
                                   keysAndValues: kCIInputImageKey, outputImage, 
                         @"inputSaturation", [NSNumber numberWithFloat:.6],
                         @"inputContrast", [NSNumber numberWithFloat:1], 
                         nil];
    CIImage *outputImageB = [filterB outputImage];
    
    CIFilter *filterC = [CIFilter filterWithName:@"CITemperatureAndTint" 
                                   keysAndValues: kCIInputImageKey, outputImageB, 
                         @"inputNeutral",[CIVector vectorWithX:6500 Y:2000 Z:0],
                         @"inputTargetNeutral",[CIVector vectorWithX:5200 Y:0 Z:0],
                         nil];
    CIImage *outputImageC = [filterC outputImage];
    
    // convert the filtered image to a UIImage
    CGImageRef cgimg = [context createCGImage:outputImageC fromRect:[outputImageC extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
	// store the file in the docs directory
	NSData *imageData = UIImageJPEGRepresentation(newImg,1.0);
	NSString *documentsPath = [paths objectAtIndex:0];
	
    int r = arc4random() % 5000;
	NSString *random = [NSString stringWithFormat:@"%d", r];
	NSString *tPathA = [documentsPath stringByAppendingPathComponent:@"worn"];
	NSString *tPathB = [tPathA stringByAppendingString:random];
	NSString *filePathB = [tPathB stringByAppendingString:@".jpg"];
    
    [imageData writeToFile:filePathB atomically:YES];
    
	// save the file if requested
    NSString *save = [options objectForKey:@"save"];
    if([save isEqualToString:@"true"]){
        UIImageWriteToSavedPhotosAlbum(newImg, nil, nil, nil);
    }
	
	//release the image
    CGImageRelease(cgimg);
    
	//callback with path
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:filePathB];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
-(void)vintage:(CDVInvokedUrlCommand*)command;
{
	// get options
	NSMutableDictionary* options = [command.arguments objectAtIndex:0];

	// get file path
	NSString *filePath = [options objectForKey:@"image"];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *oDocumentsPath = [paths objectAtIndex:0];
	oDocumentsPath = [oDocumentsPath stringByAppendingString:filePath];
	
	// convert file path to imageurl
	NSURL *fileNameAndPath = [NSURL fileURLWithPath:oDocumentsPath];  
	
	// do the filtering
    CIImage *beginImage = 
    [CIImage imageWithContentsOfURL:fileNameAndPath];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIWhitePointAdjust" 
                                  keysAndValues: kCIInputImageKey, beginImage, 
                        @"inputColor",[CIColor colorWithRed:121 green:195 blue:219 alpha:1],
                        nil];
    CIImage *outputImage = [filter outputImage];
    
    CIFilter *filterB = [CIFilter filterWithName:@"CIColorControls" 
                                   keysAndValues: kCIInputImageKey, outputImage, 
                         @"inputSaturation", [NSNumber numberWithFloat:.6],
                         @"inputContrast", [NSNumber numberWithFloat:1.1], 
                         nil];
    CIImage *outputImageB = [filterB outputImage];
    
    // convert the filtered image to a UIImage
    CGImageRef cgimg = [context createCGImage:outputImageB fromRect:[outputImageB extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
	// store the file in the docs directory
	NSData *imageData = UIImageJPEGRepresentation(newImg,1.0);
	NSString *documentsPath = [paths objectAtIndex:0];
	
    int r = arc4random() % 5000;
	NSString *random = [NSString stringWithFormat:@"%d", r];
	NSString *tPathA = [documentsPath stringByAppendingPathComponent:@"vintage"];
	NSString *tPathB = [tPathA stringByAppendingString:random];
	NSString *filePathB = [tPathB stringByAppendingString:@".jpg"];
    
    [imageData writeToFile:filePathB atomically:YES];
    
	// save the file if requested
    NSString *save = [options objectForKey:@"save"];
    if([save isEqualToString:@"true"]){
        UIImageWriteToSavedPhotosAlbum(newImg, nil, nil, nil);
    }
	
	//release the image
    CGImageRelease(cgimg);
    
	//callback with path
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:filePathB];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end