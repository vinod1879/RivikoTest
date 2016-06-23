//
//  Utility.h
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(NSString*)stringByFormattingDate:(NSDate*)date inFormat:(NSString*)format;
+(NSDate*)dateFromString:(NSString*)string inFormat:(NSString*)format;
+(NSString*)descriptionForPrice:(NSInteger)price;

@end
