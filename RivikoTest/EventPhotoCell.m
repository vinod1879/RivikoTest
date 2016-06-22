//
//  EventPhotoCell.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 22/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "EventPhotoCell.h"

@interface EventPhotoCell ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic) NSInteger index;

-(IBAction)deletePhotoTapped:(id)sender;

@end

@implementation EventPhotoCell

-(void)setImage:(UIImage*)image withIndex:(NSInteger)index
{
    [self.imageView setImage:image];
    
    self.index = index;
}

-(IBAction)deletePhotoTapped:(id)sender
{
    [self.delegate eventPhotoCell:self deletedImageWithIndex:self.index];
}

@end
