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
             @"eventMemberFee": [Utility descriptionForPrice:self.memberFee.integerValue],
             @"eventGuestFee": [Utility descriptionForPrice:self.guestFee.integerValue]};
}

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    
    NSString *dateStr = [dictionary objectForKey:@"startTime"];
    
    self.eventName          = [dictionary objectForKey:@"title"];
    self.eventDescription   = [dictionary objectForKey:@"description"];
    
    self.startTime          = [Utility dateFromString:dateStr inFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.memberFee          = [dictionary objectForKey:@"memberFee"];
    self.guestFee           = [dictionary objectForKey:@"guestFee"];
    
    return self;
}

-(BOOL)isValid
{
    if (self.eventName.length == 0 ||
        self.eventDescription.length == 0 ||
        !self.startTime ||
        !self.memberFee ||
        !self.guestFee ||
        !self.images ||
        self.images.count == 0) {
        
            return NO;
        }
    
    
    return YES;;
}

@end
