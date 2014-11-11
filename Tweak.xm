#import "substrate.h"
#import <UIKit/UIKit.h>

#import "Interfaces.h"
#import "ApptrayViewController.h"

#import "SettingsLoader.h"

ApptrayViewController *apptrayVC;

%group iOS8
%hook SBNotificationCenterController

%new
- (SBBulletinObserverViewController*)newSegmentViewController {

  SBBulletinObserverViewController *newView = [[%c(SBBulletinObserverViewController) alloc] initWithObserverFeed:nil];
  
  if ([[[SettingsLoader sharedInstance] tabText] length] > 0) {
    newView.title = [[SettingsLoader sharedInstance] tabText];
  } else {
    newView.title = @"Apptray";
  }
	
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

  [[SettingsLoader sharedInstance] loadSettings];

  %orig;

  NSLog(@"[Apptray]: Notification center is about to be presented.");

  SBNotificationCenterViewController* notificationCenterVC = MSHookIvar<SBNotificationCenterViewController*>(self, "_viewController");
  SBModeViewController *sbModeVC = MSHookIvar<SBModeViewController*>(notificationCenterVC, "_modeController");
  SBModeControlManager *modeControlManager = MSHookIvar<SBModeControlManager*>(sbModeVC, "_modeControl");
  
  unsigned long long numberOfSegments = [modeControlManager numberOfSegments];
  NSLog(@"Number of segments: %lld", numberOfSegments);
  
    
  SBBulletinObserverViewController *newView = [self newSegmentViewController];
  
  NSLog(@"[Apptray] - View: %@", newView.view);
  NSLog(@"[Apptray] - View: %@", newView.view.subviews);
      
  [sbModeVC _addBulletinObserverViewController:newView];  

}

%end
%end

%ctor {
  %init(iOS8)
}
