//
//  Utility.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>

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

+(NSString*)friendlyDescriptionOfDate:(NSDate*)date
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSDate *startDate, *endDate;
    
    [currentCalendar rangeOfUnit:NSCalendarUnitDay startDate:&startDate interval:nil forDate:currentDate];
    [currentCalendar rangeOfUnit:NSCalendarUnitDay startDate:&endDate interval:nil forDate:date];
    
    NSDateComponents *comps = [currentCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
    
    if (comps.day == 1) {
        
        return @"Tomorrow";
    }
    
    if (comps.day == 0) {
        
        return @"Today";
    }
    
    return [self stringByFormattingDate:date inFormat:@"MMM d"];
}

+(NSString*)descriptionForPrice:(NSInteger)price
{
    NSString *desc = price == 0 ? @"Free" : [NSString stringWithFormat:@"$%ld", (long)price];
    
    return desc;
}

+(NSAttributedString*)attributedDescriptionForMemberFee:(NSString*)memFee guestFee:(NSString*)guestFee
{
    NSString *string = [NSString stringWithFormat:@"Members %@ ● Guests %@", memFee, guestFee];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    
    UIColor *textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    UIColor *priceColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    [attr setAttributes:@{NSForegroundColorAttributeName:priceColor} range:NSMakeRange(0, string.length)];
    
    NSRange range1 = [string rangeOfString:@"Members"];
    NSRange range2 = [string rangeOfString:@"Guests"];
    [attr setAttributes:@{NSForegroundColorAttributeName:textColor} range:range1];
    [attr setAttributes:@{NSForegroundColorAttributeName:textColor} range:range2];
    
    return [[NSAttributedString alloc] initWithAttributedString:attr];
}

@end
