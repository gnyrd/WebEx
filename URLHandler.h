//
//  URLHandler.h
//  Weberal Express
//
//  Created by Jeff Ganyard on 1/16/10.
//  Copyright Bithaus 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface URLHandler : NSObject

- (void)getURL:(NSAppleEventDescriptor *)event;
- (void)showURL:(NSURL *)url withApp:(NSString *)bundleID;

@end
