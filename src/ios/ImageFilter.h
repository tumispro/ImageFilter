//
//  ImageFilter.h
//
//  Created by Drew Dahlman 2/25/2012.
//  Copyright 2012 Drew Dahlman. All rights reserved.
//
//  Updated by Thomas Moeskops 11/23/2014
//
//  version 1.1

//  Current Filters:
//  none
//  stark
//  sunnySide
//  worn
//  vintage

/*
 Copyright (c) 2012 Drew Dahlman MIT LICENSE
 */


#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

@interface ImageFilter : CDVPlugin
{
    NSString* callbackID;
}

@property (nonatomic, retain) NSString* callbackID;

// GARBAGE
-(void)clean:(CDVInvokedUrlCommand*)command;

// FILTERS
-(void)none:(CDVInvokedUrlCommand*)command;
-(void)stark:(CDVInvokedUrlCommand*)command;
-(void)sunnySide:(CDVInvokedUrlCommand*)command;
-(void)worn:(CDVInvokedUrlCommand*)command;
-(void)vintage:(CDVInvokedUrlCommand*)command;
@end