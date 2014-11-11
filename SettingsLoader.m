//
//  SettingsLoader.m
//  Apptray
//
//  Created by Joshua Lee Tucker on 07/11/2014.
//  Copyright (c) 2014 Digibit Labs. All rights reserved.
//

#import "SettingsLoader.h"

@interface SettingsLoader ()
@end

@implementation SettingsLoader

@synthesize tabText;
@synthesize iconOpacity;

+ (SettingsLoader*)sharedInstance {
    static SettingsLoader *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SettingsLoader alloc] init];
    });
    return singleton;
}

- (void)loadSettings {
	NSString *path = @"/var/mobile/Library/Preferences/com.digibit.apptray.plist";
	NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:path];

	if ([plistData valueForKey:@"TabLabel"] != nil) {
		self.tabText = [NSString stringWithFormat:@"%@", [plistData valueForKey:@"TabLabel"]];
	}

	if ([plistData valueForKey:@"IconOpacity"] != nil) {
		self.iconOpacity = [NSNumber numberWithFloat:[[plistData valueForKey:@"IconOpacity"] floatValue]];
	}

}

@end