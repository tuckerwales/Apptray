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
  
  NSDictionary *prefsDictionary = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.digibit.apptray.plist"];
  NSString *title;
  if ([prefsDictionary valueForKey:@"TabLabel"] != nil && ![[prefsDictionary valueForKey:@"TabLabel"] isEqual:@""]) {
	  title = [prefsDictionary valueForKey:@"TabLabel"];
  } else {
	  title = @"Apptray";
  }

  SBNotificationCenterViewController* notificationCenterVC = MSHookIvar<SBNotificationCenterViewController*>(self, "_viewController");
  SBModeViewController *sbModeVC = MSHookIvar<SBModeViewController*>(notificationCenterVC, "_modeController");  
      
  SBBulletinObserverViewController *newView = [self newSegmentViewControllerWithTitle:title];
        
  [sbModeVC _addBulletinObserverViewController:newView];  

}

%end
