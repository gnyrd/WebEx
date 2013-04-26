//
//  URLHandler.m
//  Weberal Express
//
//  Created by Jeff Ganyard on 1/16/10.
//  Copyright Bithaus 2010 . All rights reserved.
//

#import "URLHandler.h"


@implementation URLHandler

- (void)awakeFromNib 
{
	[[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector: @selector(getURL:) forEventClass: kInternetEventClass andEventID: kAEGetURL ];

	if (![[NSUserDefaults standardUserDefaults] stringForKey:@"httpDefault"]) {	
		NSString *httpHandler = (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"http");
		[[NSUserDefaults standardUserDefaults] setObject:httpHandler forKey:@"httpDefault"];
	}

	if (![[NSUserDefaults standardUserDefaults] stringForKey:@"httpsDefault"]) {	
		NSString *httpsHandler = (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"https");
		[[NSUserDefaults standardUserDefaults] setObject:httpsHandler forKey:@"httpsDefault"];
	}

	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

	OSStatus result = LSSetDefaultHandlerForURLScheme((CFStringRef)@"http", (CFStringRef)bundleID);
	if (result < 0) {
		NSLog(@"An error occured when trying to set the http handler.\n : %i", result);
	}
	result = LSSetDefaultHandlerForURLScheme((CFStringRef)@"https", (CFStringRef)bundleID);
	if (result < 0) {
		NSLog(@"An error occured when trying to set the https handler.\n : %i", result);
	}

	DLog(@"0 http: %@ https: %@", (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"http"), (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"https"));
}

- (void)getURL:(NSAppleEventDescriptor *)event
{
	NSString *urlString = [[event paramDescriptorForKeyword:'----'] stringValue];
	NSURL *url = [NSURL URLWithString:urlString];
	
	if (url == nil){
		DLog(@"couldn't parse URL");
		return;
	}
	
	NSString *hostName = [url host];
    DLog(@"host: %@", hostName);
	// TODO: allow domain wide setting.. probably with wildcard
	
	NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.bithaus.weberal-express"];
	NSDictionary *sitesDict = [defaults objectForKey:@"sites"];
    NSString *targetBundleID = [sitesDict objectForKey:hostName];

	if (!targetBundleID) {
		if ([[url scheme] isEqualToString:@"http"]) {
			[self showURL:url withApp:[[NSUserDefaults standardUserDefaults] stringForKey:@"httpDefault"]];
		} else if ([[url scheme] isEqualToString:@"https"]) {
			[self showURL:url withApp:[[NSUserDefaults standardUserDefaults] stringForKey:@"httpsDefault"]];
		}
	} else {
        DLog(@"use: %@", targetBundleID);
		[self showURL:url withApp:targetBundleID];
	}

    //	[NSApp terminate:nil];
}

- (void)showURL:(NSURL *)url withApp:(NSString *)bundleID;
{
	OSStatus result;
	DLog(@"1 http: %@ https: %@", (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"http"), (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"https"));

	if ([[url scheme] isEqualToString:@"http"]) {
		result = LSSetDefaultHandlerForURLScheme((CFStringRef)@"http", (CFStringRef)bundleID);
		if (result < 0) {
			NSLog(@"An error occured when trying to temporarily set the http handler.\n : %i", result);
		}
	} else 	if ([[url scheme] isEqualToString:@"https"]) {
		result = LSSetDefaultHandlerForURLScheme((CFStringRef)@"https", (CFStringRef)bundleID);
		if (result < 0) {
			NSLog(@"An error occured when trying to temporarily set the https handler.\n : %i", result);
		}
	} else {
		DLog(@"An error has occured.");
	}
	DLog(@"2 http: %@ https: %@", (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"http"), (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"https"));

	[[NSWorkspace sharedWorkspace] openURL:url];

	bundleID = [[NSBundle mainBundle] bundleIdentifier];
	// reset ourself as http/s handler
	if ([[url scheme] isEqualToString:@"http"]) {
		result = LSSetDefaultHandlerForURLScheme((CFStringRef)@"http", (CFStringRef)bundleID);
		if (result < 0) {
			NSLog(@"An error occured when trying to reset the http handler.\n : %i", result);
		}
	} else 	if ([[url scheme] isEqualToString:@"https"]) {
		result = LSSetDefaultHandlerForURLScheme((CFStringRef)@"https", (CFStringRef)bundleID);
		if (result < 0) {
			NSLog(@"An error occured when trying to reset the https handler.\n : %i", result);
		}
	} else {
		DLog(@"An error has occured.");
	}

	DLog(@"3 http: %@ https: %@", (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"http"), (NSString *)LSCopyDefaultHandlerForURLScheme((CFStringRef)@"https"));
}

- (void) dealloc
{
    [super dealloc];
}

@end
