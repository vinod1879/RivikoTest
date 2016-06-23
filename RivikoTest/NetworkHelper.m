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
#import <AWSS3/AWSS3.h>

@implementation NetworkHelper

+(void)fetchEventsWithPageNumber:(NSInteger)pNumber completion:(void (^)(BOOL success, NSArray<Event*>* events))completion
{
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    
    NSDictionary *parameters = @{@"page" : @(pNumber)};
    
    [[lambdaInvoker invokeFunction:@"event-getEvent"
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

+(void)addEvent:(Event*)event completion:(void (^)(BOOL success, NSInteger eventId))completion
{
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    
    NSDictionary *parameters = [event dictionaryRepresentation];
    
    [[lambdaInvoker invokeFunction:@"event-addEvent"
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
            
            [self saveImages:event.images withEventID:eventId];
            
            completion(YES, eventId);
            
        } else {
            
            completion(NO, 0);
        }
        return nil;
    }];
}

+(void)saveImages:(NSArray<UIImage*>*)images withEventID:(NSInteger)eventID
{
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.bucket = @"cdn.eventapp.riviko.com";
    uploadRequest.key = @"myTestFile.txt";
    uploadRequest.body = @"";
    
    
    
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    
    NSDictionary *parameters = @{@"page" : @(1)};
    
    [[lambdaInvoker invokeFunction:@"event-getEvent"
                        JSONObject:parameters] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        if (task.exception) {
            NSLog(@"Exception: %@", task.exception);
        }
        
        if (task.result) {
            
            NSLog(@"Result: %@", task.result);
            
        }
        
        return nil;
    }];
}

@end
