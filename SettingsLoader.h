//
//  SettingsLoader.h
//  Apptray
//
//  Created by Joshua Lee Tucker on 07/11/2014.
//  Copyright (c) 2014 Digibit Labs. All rights reserved.
//

@interface SettingsLoader : NSObject {
	NSString *tabText;
	NSNumber *iconOpacity;
}

+ (SettingsLoader*)sharedInstance;
- (void)loadSettings;

@property (nonatomic, strong) NSString *tabText;
@property (nonatomic, strong) NSNumber *iconOpacity;

@end
