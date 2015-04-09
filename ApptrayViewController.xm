//
//  ApptrayViewController.m
//  Apptray
//
//  Created by Joshua Lee Tucker on 07/11/2014.
//  Copyright (c) 2014 Digibit Labs. All rights reserved.
//

#import "ApptrayViewController.h"
#import "Interfaces.h"

@interface ApptrayViewController ()
@end

@implementation ApptrayViewController

float alpha;

@synthesize apps, collectionView, orderedDict;

- (id)init {
	self = [super init];
	if (self) {
		[self loadApps];
		[self syncPlists];
		[self loadPrefs];
	}
	return self;
}

- (void)syncPlists {

	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.digibit.apptray.applist.ordered.plist"]) {

		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

		for (int i = 0; i < [self.apps count]; ++i) {
			
			[dict setValue:[self.apps objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d", i]];

		}

		[dict writeToFile:@"/var/mobile/Library/Preferences/com.digibit.apptray.applist.ordered.plist" atomically:YES];


	} else {

		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.digibit.apptray.applist.ordered.plist"];

		for (NSString *num in dict) {
			NSString *ident = [dict valueForKey:num];
			if (![self.apps containsObject:ident]) {
				[dict removeObjectForKey:num];
			}
		}

	}

}

- (void)loadPrefs {
	NSDictionary *prefsDictionary = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.digibit.apptray.plist"];
  	if ([prefsDictionary valueForKey:@"IconOpacity"] != nil) {
	  alpha = [[prefsDictionary valueForKey:@"IconOpacity"] floatValue];
	} else {
		alpha = 1.0;
	}
}

- (void)loadApps {
	NSString *path = @"/var/mobile/Library/Preferences/com.digibit.apptray.applist.plist";
	NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:path];
	self.apps = [[NSMutableArray alloc] init];
	for (NSString *key in [plistData allKeys]) {
		if ([[plistData objectForKey:key] boolValue] == YES) {
			[self.apps addObject:key];
			NSLog(@"Identifier: %@", key);
		}
	}
}

- (void)setViewFrame:(CGRect)frame {
	CGRect newFrame = frame;
	newFrame.size.height = newFrame.size.height - 100;
	viewFrame = newFrame;
}

- (id)getApplicationIconForIdentifier:(NSString*)ident {
	SBIconModel *model = (SBIconModel*)[[%c(SBIconController) sharedInstance] model];
	SBApplicationIcon *appIcon = [model applicationIconForBundleIdentifier:ident];
	return appIcon;
}

- (UIImage*)getIconForIdentifier:(NSString*)ident {
	SBIconModel *model = (SBIconModel*)[[%c(SBIconController) sharedInstance] model];
	SBApplicationIcon *appIcon = [model applicationIconForBundleIdentifier:ident];
	UIImage *img = [appIcon generateIconImage:2];
	return img;
	[appIcon release];
	[model release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view = [[UIView alloc] initWithFrame:viewFrame];
	DraggableCollectionViewFlowLayout *layout = [[DraggableCollectionViewFlowLayout alloc] init];
	layout.minimumInteritemSpacing = 20;
	layout.minimumLineSpacing = 20;
	self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
	self.collectionView.draggable = YES;
	[self.collectionView setDataSource:self];
	[self.collectionView setDelegate:self];
	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"IconCell"];
	[self.collectionView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [apps count]; 
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"IconCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
	UIImage *img = [self getIconForIdentifier:[apps objectAtIndex:indexPath.row]];
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, img.size.width, img.size.height)];
	btn.userInteractionEnabled = NO;
	[btn setBackgroundImage:img forState:UIControlStateNormal];
	btn.alpha = alpha;
	[cell setBackgroundView:btn];
	cell.userInteractionEnabled = YES;
    return cell; 
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath 
{
	NSLog(@"Selected: %@", [self.apps objectAtIndex:indexPath.row]);
	SBUIController *sbController = [%c(SBUIController) sharedInstance];
	[sbController activateApplicationAnimated:[(SBApplicationIcon*)[self getApplicationIconForIdentifier:[self.apps objectAtIndex:indexPath.row]] application]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(62, 62);
	return retval;
}
 
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 35, 20, 35); 
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(LSCollectionViewHelper *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *identifier = [[self.apps objectAtIndex:fromIndexPath.item] retain];
    [self.apps removeObjectAtIndex:fromIndexPath.item];
    [self.apps insertObject:identifier atIndex:toIndexPath.item];
    [identifier release];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"did end drag");
}

/*- (UICollectionReusableView *)collectionView:
(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [[UICollectionReusableView alloc] init];
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
