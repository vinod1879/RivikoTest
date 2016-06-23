//
//  Event.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "Event.h"
#import "Utility.h"

@implementation Event

-(NSDictionary*)dictionaryRepresentation
{
    return @{@"eventName": self.eventName,
             @"eventDescription": self.eventDescription,
             @"eventStartTime": [Utility stringByFormattingDate:self.startTime inFormat:@"yyyy-MM-dd HH:mm:ss"],
             @"eventMemberFee": [Utility descriptionForPrice:self.memberFee],
             @"eventGuestFee": [Utility descriptionForPrice:self.guestFee]};
}

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    
    NSString *dateStr = [dictionary objectForKey:@"eventStartTime"];
    
    self.eventName          = [dictionary objectForKey:@"eventName"];
    self.eventDescription   = [dictionary objectForKey:@"eventDescription"];
    
    self.startTime          = [Utility dateFromString:dateStr inFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.memberFee          = [[dictionary objectForKey:@"eventMemberFee"] integerValue];
    self.guestFee           = [[dictionary objectForKey:@"eventGuestFee"] integerValue];
    
    return self;
}

@end
