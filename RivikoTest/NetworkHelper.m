//
//  NetworkHelper.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 23/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "NetworkHelper.h"

#import "Event.h"
#import <AWSLambda/AWSLambda.h>

@implementation NetworkHelper

+(void)fetchEventsWithPageNumber:(NSInteger)pNumber completion:(void (^)(BOOL success, NSArray<Event*>* events))completion
{
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    
    NSDictionary *parameters = @{@"page" : @(pNumber)};
    
    [[lambdaInvoker invokeFunction:@"event-getEvents"
                        JSONObject:parameters] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        
        if (task.result) {
            
            NSLog(@"Result: %@", task.result);
            NSArray *dictionaries = task.result;
            
            NSMutableArray<Event*> *events = [NSMutableArray new];
            
            for(NSDictionary *dict in dictionaries) {
                
                [events addObject:[[Event alloc] initWithDictionary:dict]];
            }
            
            completion(YES, [NSArray arrayWithArray:events]);
            
        } else {
            
            completion(NO, nil);
        }
        return nil;
    }];
}

+(void)addEent:(Event*)event completion:(void (^)(BOOL success, NSInteger eventId))completion
{
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    
    NSDictionary *parameters = [event dictionaryRepresentation];
    
    [[lambdaInvoker invokeFunction:@"event-getEvents"
                        JSONObject:parameters] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        
        if (task.result) {
            
            NSLog(@"Result: %@", task.result);
            
            NSInteger eventId = (NSInteger)task.result;
            
            completion(YES, eventId);
            
        } else {
            
            completion(NO, 0);
        }
        return nil;
    }];
}

@end
