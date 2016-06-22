//
//  EventPhotoCell.h
//  RivikoTest
//
//  Created by Vinod Vishwanath on 22/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventPhotoCell;

@protocol EventPhotoCellDelegate <NSObject>

-(void)eventPhotoCell:(EventPhotoCell*)eventPhotoCell deletedImageWithIndex:(NSInteger)index;

@end

@interface EventPhotoCell : UICollectionViewCell

//MARK:- Properties

@property (nonatomic, weak) id<EventPhotoCellDelegate> delegate;

//MARK:- Methods
-(void)setImage:(UIImage*)image withIndex:(NSInteger)index;

@end
