//
//  Utility.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(NSString*)stringByFormattingDate:(NSDate*)date inFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = format;
    
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)dateFromString:(NSString*)string inFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = format;
    
    return [dateFormatter dateFromString:string];
}

+(NSString*)descriptionForPrice:(NSInteger)price
{
    NSString *desc = price == 0 ? @"Free" : [NSString stringWithFormat:@"$%ld", (long)price];
    
    return desc;
}

@end
