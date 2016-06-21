//
//  CommonKeyboardAccessoryView.h
//  RivikoTest
//
//  Created by Vinod Vishwanath on 21/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomKeyboardAccessoryButton) {
    
    CustomKeyboardAccessoryButtonPrevious,
    CustomKeyboardAccessoryButtonNext,
    CustomKeyboardAccessoryButtonDone
};

@interface CommonKeyboardAccessoryView : UIView

-(void)addTarget:(id)target selector:(SEL)selector forAccessoryButton:(CustomKeyboardAccessoryButton)accButton;
-(void)changeAccessoryButton:(CustomKeyboardAccessoryButton)accButton toEnabled:(BOOL)enabled;
-(void)setTitle:(NSString*)title;

@end
