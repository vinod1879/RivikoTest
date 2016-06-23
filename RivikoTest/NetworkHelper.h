//
//  NetworkHelper.h
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event;

@interface NetworkHelper : NSObject

+(void)fetchEventsWithPageNumber:(NSInteger)pNumber completion:(void (^)(BOOL success, NSArray<Event*>* events))completion;

+(void)addEent:(Event*)event completion:(void (^)(BOOL success, NSInteger eventId))completion;

@end
