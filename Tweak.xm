#import "substrate.h"
#import <UIKit/UIKit.h>

#import "Interfaces.h"
#import "ApptrayViewController.h"

ApptrayViewController *apptrayVC;

%hook SBNotificationCenterController

%new
- (SBBulletinObserverViewController*)newSegmentViewControllerWithTitle:(NSString *)title {

  SBBulletinObserverViewController *newView = [[%c(SBBulletinObserverViewController) alloc] initWithObserverFeed:nil];
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

- (void)_setupForViewPresentation {

  %orig;

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
  //[sbModeVC addViewController:[self newSegmentViewControllerWithTitle:@"Apptray"]];

}

%end
