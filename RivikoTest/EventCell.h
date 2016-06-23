//
//  EventCell.h
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;

@interface EventCell : UITableViewCell

-(void)showDetailsOfEvent:(Event*)event;

@end
