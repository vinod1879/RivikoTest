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
            
            NSDictionary *result = task.result;
            
            if ([[result objectForKey:@"status"] isEqualToString:@"success"]) {
                
                NSArray *dictionaries = [result objectForKey:@"data"];
                
                NSMutableArray<Event*> *events = [NSMutableArray new];
                
                for(NSDictionary *dict in dictionaries) {
                    
                    [events addObject:[[Event alloc] initWithDictionary:dict]];
                }
                
                completion(YES, [NSArray arrayWithArray:events]);
                
            } else {
                
                completion(NO, nil);
            }            
            
        } else {
            
            completion(NO, nil);
        }
        return nil;
    }];
}

+(void)addEvent:(Event*)event completion:(void (^)(BOOL success, NSString *eventId))completion
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
            
            NSString *eventId = task.result;
            
            [self saveImages:event.images withEventID:eventId];
            
            completion(YES, eventId);
            
        } else {
            
            completion(NO, 0);
        }
        return nil;
    }];
}

+(void)saveImages:(NSArray<UIImage*>*)images withEventID:(NSString*)eventID
{
    for (NSInteger index=0; index < images.count; index++) {
        
        UIImage *image = images[index];
        
        AWSS3TransferUtility *transferUtility = [AWSS3TransferUtility defaultS3TransferUtility];
        
        NSData      *PNGData    = UIImagePNGRepresentation(image);
        NSString    *fileName   = [NSString stringWithFormat:@"event-%@-image-%ld", eventID, (long)index];
        
        [transferUtility uploadData:PNGData
                             bucket:@"cdn.eventapp.riviko.com"
                                key:fileName
                        contentType:@"image/png"
                         expression:nil
                   completionHander:^(AWSS3TransferUtilityUploadTask * _Nonnull task, NSError * _Nullable error) {
                       
                   }];
    }
}

+(void)addImageName:(NSString*)imageName toEventID:(NSString*)eventID
{
    AWSLambdaInvoker *lambdaInvoker = [AWSLambdaInvoker defaultLambdaInvoker];
    
    NSDictionary *parameters = @{@"imageName" : imageName,
                                 @"eventId": eventID};
    
    [[lambdaInvoker invokeFunction:@"event-addImage"
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
