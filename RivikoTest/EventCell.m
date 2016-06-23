//
//  EventCell.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "EventCell.h"
#import "Event.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EventCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel            *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel            *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel            *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel            *priceLabel;
@property (nonatomic, weak) IBOutlet UICollectionView   *photosCollection;

@property (nonatomic) Event *shownEvent;

@end

@implementation EventCell

-(void)showDetailsOfEvent:(Event*)event
{
    self.shownEvent = event;
    
    [self updateView];
}

-(void)updateView
{
    self.dateLabel.text = [Utility friendlyDescriptionOfDate:self.shownEvent.startTime];
    self.timeLabel.text = [Utility stringByFormattingDate:self.shownEvent.startTime inFormat:@"H:mm a"];
    self.titleLabel.text = self.shownEvent.eventName;
    
    self.priceLabel.attributedText = [Utility attributedDescriptionForMemberFee:self.shownEvent.memberFee guestFee: self.shownEvent.guestFee];
    
    [_photosCollection reloadData];
}

#pragma mark - UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shownEvent.imagePaths.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventThumbnailCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [cell viewWithTag:100];
    
    if ([imageView isMemberOfClass:[UIImageView class]]) {
        
        NSString *path = [self.shownEvent.imagePaths objectAtIndex:indexPath.row];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:path]];
    }
    
    return cell;
}

@end
