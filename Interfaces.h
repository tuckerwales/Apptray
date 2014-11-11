@class SBModeViewController;
@class SBModeControlManager;

@interface SBUIController : NSObject {}
+ (id)sharedInstance;
- (void)activateApplicationAnimated:(id)arg1;
@end

@interface SBApplicationIcon : NSObject {}
- (id)application;
- (UIImage*)generateIconImage:(int)arg1;
@end

@interface SBIconModel : NSObject {}
- (id)applicationIconForBundleIdentifier:(id)arg1;
@end

@interface SBIconController : NSObject {}
+ (id)sharedInstance;
- (id)model;
- (void)_launchIcon:(id)arg1;
@end

@interface SBBulletinObserverViewController : UIViewController {}
-(id)initWithObserverFeed:(id)arg1;
@end

@interface SBNotificationCenterViewController : NSObject {}
- (SBBulletinObserverViewController*)newSegmentViewController;
@end

@interface SBModeViewController : NSObject {
}
- (void)addViewController:(id)arg1;
- (_Bool)_addBulletinObserverViewController:(id)arg1;
@end

@interface SBModeControlManager : NSObject {
}
@property(readonly, nonatomic) unsigned long long numberOfSegments;
- (void)insertSegmentWithTitle:(id)arg1 atIndex:(unsigned long long)arg2 animated:(_Bool)arg3;
@end

@interface SBNotificationCenterController : NSObject {}
- (SBBulletinObserverViewController*)newSegmentViewController;
@end