//
//  Event.h
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Event : NSObject

@property (nonatomic) NSString              *eventName;
@property (nonatomic) NSString              *eventDescription;
@property (nonatomic) NSDate                *startTime;
@property (nonatomic) NSNumber              *memberFee;
@property (nonatomic) NSNumber              *guestFee;
@property (nonatomic) NSArray<UIImage*>     *images;

-(NSDictionary*)dictionaryRepresentation;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(BOOL)isValid;

@end
