//
//  ApptrayViewController.h
//  Apptray
//
//  Created by Joshua Lee Tucker on 07/11/2014.
//  Copyright (c) 2014 Digibit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <grid/UICollectionView+Draggable.h>
#import <grid/DraggableCollectionViewFlowLayout.h>

@interface ApptrayViewController : UIViewController <UICollectionViewDataSource_Draggable, UICollectionViewDelegate> {
	NSMutableArray *apps;
	NSDictionary *orderedDict;
	UICollectionView *collectionView;
	CGRect viewFrame;
}

- (void)setViewFrame:(CGRect)frame;

@property (nonatomic, strong) NSMutableArray *apps;
@property (nonatomic, strong) NSDictionary *orderedDict;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
