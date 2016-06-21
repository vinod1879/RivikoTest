//
//  CommonKeyboardAccessoryView.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 21/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "CommonKeyboardAccessoryView.h"

@interface CommonKeyboardAccessoryView () {
    
    UIBarButtonItem *previousButton;
    UIBarButtonItem *nextButton;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *titleButton;
}

@end

@implementation CommonKeyboardAccessoryView

-(instancetype)init
{
    self = [super init];
    
    [self setupSubviews];
    
    return self;
}

#pragma Public API

-(void)changeAccessoryButton:(CustomKeyboardAccessoryButton)accButton toEnabled:(BOOL)enabled
{
    UIBarButtonItem *targetButton = [self targetButton:accButton];
    
    UIButton *button = targetButton.customView;
    
    if ([button isMemberOfClass:[UIButton class]]) {
        
        button.enabled = enabled;
    }
}

-(void)addTarget:(id)target selector:(SEL)selector forAccessoryButton:(CustomKeyboardAccessoryButton)accButton
{
    
    UIBarButtonItem *targetButton = [self targetButton:accButton];
    
    UIButton *button = targetButton.customView;
    
    if ([button isMemberOfClass:[UIButton class]]) {
        
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)setTitle:(NSString*)title
{
    UILabel *label = titleButton.customView;
    
    if (label && [label isMemberOfClass:[UILabel class]])
    {
        label.text = title;
        [label sizeToFit];
    }
}

#pragma Private API

-(UIBarButtonItem*)targetButton:(CustomKeyboardAccessoryButton)accButton
{
    UIBarButtonItem *targetButton;
    
    switch (accButton) {
            
        case CustomKeyboardAccessoryButtonDone:
            
            targetButton = doneButton;
            break;
            
        case CustomKeyboardAccessoryButtonNext:
            
            targetButton = nextButton;
            break;
            
        case CustomKeyboardAccessoryButtonPrevious:
            
            targetButton = previousButton;
            break;
    }
    
    return targetButton;
}

-(void)setupSubviews
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem *flexi1 = [self flexibleBarButtonItem];
    UIBarButtonItem *flexi2 = [self flexibleBarButtonItem];
    
    previousButton  = [self barButtonItemWithEnabledImageName:@"Back" disabledImageName:@"Back2"];
    nextButton      = [self barButtonItemWithEnabledImageName:@"forward" disabledImageName:@"forward2"];
    titleButton     = [self labelBarButtonItem];
    doneButton      = [self barButtonItemWithEnabledImageName:@"check" disabledImageName:@"check"];
    
    NSArray *bbItems = [NSArray arrayWithObjects:previousButton, nextButton, flexi1, titleButton, flexi2, doneButton, nil];
    
    [toolbar setItems:bbItems];
    [toolbar sizeToFit];
    self.frame = toolbar.bounds;
    [self addSubview:toolbar];
}

-(UIBarButtonItem*)barButtonItemWithEnabledImageName:(NSString*)selImage disabledImageName:(NSString*)disImage
{
    UIImage *selectedImage = [UIImage imageNamed:selImage];
    UIImage *deselectedImage = [UIImage imageNamed:disImage];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:selectedImage forState:UIControlStateNormal];
    [button setImage:deselectedImage forState:UIControlStateDisabled];
    
    [button sizeToFit];
    
    UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return bbItem;
}

-(UIBarButtonItem*)flexibleBarButtonItem
{
    UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    return bbItem;
}

-(UIBarButtonItem*)labelBarButtonItem
{
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"Title Goes Here";
    label.font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightSemibold];
    
    [label sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:label];
}

@end
