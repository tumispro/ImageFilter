//
//  ImageFilter.h
//
//  Created by Drew Dahlman 2/25/2012. 
//  Copyright 2012 Drew Dahlman. All rights reserved.
//
//  Updated by Henry Ruhl 4/20/2014
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
- (void)clean:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

// FILTERS
- (void)none:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)stark:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)sunnySide:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)worn:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void)vintage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end