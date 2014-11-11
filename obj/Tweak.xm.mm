#line 1 "Tweak.xm"
#import "substrate.h"
#import <UIKit/UIKit.h>

#import "Interfaces.h"
#import "ApptrayViewController.h"

ApptrayViewController *apptrayVC;

#include <logos/logos.h>
#include <substrate.h>
@class SBNotificationCenterController; @class SBBulletinObserverViewController; 
static SBBulletinObserverViewController* _logos_method$_ungrouped$SBNotificationCenterController$newSegmentViewControllerWithTitle$(SBNotificationCenterController*, SEL, NSString *); static void (*_logos_orig$_ungrouped$SBNotificationCenterController$_setupForViewPresentation)(SBNotificationCenterController*, SEL); static void _logos_method$_ungrouped$SBNotificationCenterController$_setupForViewPresentation(SBNotificationCenterController*, SEL); 
static __inline__ __attribute__((always_inline)) Class _logos_static_class_lookup$SBBulletinObserverViewController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBBulletinObserverViewController"); } return _klass; }
#line 9 "Tweak.xm"



static SBBulletinObserverViewController* _logos_method$_ungrouped$SBNotificationCenterController$newSegmentViewControllerWithTitle$(SBNotificationCenterController* self, SEL _cmd, NSString * title) {

    SBBulletinObserverViewController *newView = [[_logos_static_class_lookup$SBBulletinObserverViewController() alloc] initWithObserverFeed:nil];
    newView.title = title;
	
	
	
    id sbVC = MSHookIvar<id>(self, "_viewController");
    UIView *contentView = MSHookIvar<UIView*>(sbVC, "_contentView");
	
    UIView *view = [[UIView alloc] initWithFrame:contentView.frame];
	view.backgroundColor = [UIColor clearColor];
    newView.view = view;
	
	apptrayVC = [[ApptrayViewController alloc] init];
	[apptrayVC setViewFrame:view.frame];
	[newView.view addSubview:apptrayVC.view];
	
	return newView;

}

static void _logos_method$_ungrouped$SBNotificationCenterController$_setupForViewPresentation(SBNotificationCenterController* self, SEL _cmd) {

  _logos_orig$_ungrouped$SBNotificationCenterController$_setupForViewPresentation(self, _cmd);

  NSLog(@"[Apptray]: Notification center is about to be presented.");

  SBNotificationCenterViewController* notificationCenterVC = MSHookIvar<SBNotificationCenterViewController*>(self, "_viewController");
  SBModeViewController *sbModeVC = MSHookIvar<SBModeViewController*>(notificationCenterVC, "_modeController");
  SBModeControlManager *modeControlManager = MSHookIvar<SBModeControlManager*>(sbModeVC, "_modeControl");
  
  unsigned long long numberOfSegments = [modeControlManager numberOfSegments];
  NSLog(@"Number of segments: %lld", numberOfSegments);
  
    
  SBBulletinObserverViewController *newView = [self newSegmentViewControllerWithTitle:@"Apptray"];
  
  NSLog(@"[Apptray] - View: %@", newView.view);
  NSLog(@"[Apptray] - View: %@", newView.view.subviews);
      
	[sbModeVC _addBulletinObserverViewController:newView];  
  

}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBNotificationCenterController = objc_getClass("SBNotificationCenterController"); { char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBBulletinObserverViewController*), strlen(@encode(SBBulletinObserverViewController*))); i += strlen(@encode(SBBulletinObserverViewController*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBNotificationCenterController, @selector(newSegmentViewControllerWithTitle:), (IMP)&_logos_method$_ungrouped$SBNotificationCenterController$newSegmentViewControllerWithTitle$, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$SBNotificationCenterController, @selector(_setupForViewPresentation), (IMP)&_logos_method$_ungrouped$SBNotificationCenterController$_setupForViewPresentation, (IMP*)&_logos_orig$_ungrouped$SBNotificationCenterController$_setupForViewPresentation);} }
#line 59 "Tweak.xm"
