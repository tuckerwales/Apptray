#import <Preferences/Preferences.h>
#import <Preferences/PSTableCell.h>

@interface HeaderCell : PSTableCell {
	UIImageView *_background;
}
@end

@implementation HeaderCell

	- (id)initWithSpecifier:(PSSpecifier *)specifier{
	    self = (HeaderCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
	    if (self) {
			UIImage *bkIm = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/ApptrayPrefs.bundle"] pathForResource:@"logo" ofType:@"png"]];
			_background = [[UIImageView alloc] initWithImage:bkIm];
			[self addSubview:_background];
	    }

	    return self;
	}

	- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
	    return 164.f;
	}
@end

@interface ApptrayPrefsListController: PSListController {
}

- (id)getValueForSpecifier:(PSSpecifier*)specifier;
- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;

@end

#define kPrefs_Path @"/var/mobile/Library/Preferences"
#define kPrefs_KeyName_Key @"key"
#define kPrefs_KeyName_Defaults @"defaults"

@implementation ApptrayPrefsListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ApptrayPrefs" target:self] retain];
	}
	return _specifiers;
}

- (id)getValueForSpecifier:(PSSpecifier*)specifier
{
	id value = nil;
	
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
	

		// get 'value' from 'defaults' plist (if 'defaults' key and file exists)
		NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
		#if ! __has_feature(objc_arc)
		plistPath = [plistPath autorelease];
		#endif
		if (plistPath)
		{
			NSDictionary *dict = (NSDictionary*)[self initDictionaryWithFile:&plistPath asMutable:NO];
			
			id objectValue = [dict objectForKey:specifierKey];
			
			if (objectValue)
			{
				value = [NSString stringWithFormat:@"%@", objectValue];
				NSLog(@"read key '%@' with value '%@' from plist '%@'", specifierKey, value, plistPath);
			}
			else
			{
				NSLog(@"key '%@' not found in plist '%@'", specifierKey, plistPath);
			}
			
			#if ! __has_feature(objc_arc)
			[dict release];
			#endif
		}
		
	return value;
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier*)specifier;
{
	NSDictionary *specifierProperties = [specifier properties];
	NSString *specifierKey = [specifierProperties objectForKey:kPrefs_KeyName_Key];
	
		// save 'value' to 'defaults' plist (if 'defaults' key exists)
		NSMutableString *plistPath = [[NSMutableString alloc] initWithString:[specifierProperties objectForKey:kPrefs_KeyName_Defaults]];
		#if ! __has_feature(objc_arc)
		plistPath = [plistPath autorelease];
		#endif
		if (plistPath)
		{
			NSMutableDictionary *dict = (NSMutableDictionary*)[self initDictionaryWithFile:&plistPath asMutable:YES];
			[dict setObject:value forKey:specifierKey];
			[dict writeToFile:plistPath atomically:YES];
			#if ! __has_feature(objc_arc)
			[dict release];
			#endif

			NSLog(@"saved key '%@' with value '%@' to plist '%@'", specifierKey, value, plistPath);
		}
		
}

- (id)initDictionaryWithFile:(NSMutableString**)plistPath asMutable:(BOOL)asMutable
{
	if ([*plistPath hasPrefix:@"/"])
		*plistPath = [NSMutableString stringWithFormat:@"%@.plist", *plistPath];
	else
		*plistPath = [NSMutableString stringWithFormat:@"%@/%@.plist", kPrefs_Path, *plistPath];
	
	Class className;
	if (asMutable)
		className = [NSMutableDictionary class];
	else
		className = [NSDictionary class];
	
	id dict;	
	if ([[NSFileManager defaultManager] fileExistsAtPath:*plistPath])
		dict = [[className alloc] initWithContentsOfFile:*plistPath];	
	else
		dict = [[className alloc] init];
	
	return dict;
}

/* Actions */

- (void)followOnTwitter:(PSSpecifier*)specifier
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/DarkMalloc"]];
}
@end
