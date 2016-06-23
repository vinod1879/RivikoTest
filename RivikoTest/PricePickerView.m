//
//  PricePickerView.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 21/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "PricePickerView.h"
#import "Utility.h"

@interface PricePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation PricePickerView

-(instancetype)init
{
    self = [super init];
 
    self.backgroundColor    = [UIColor blackColor];
    self.dataSource = self;
    self.delegate   = self;
    
    return self;
}

#pragma mark - Public API

-(NSAttributedString*)priceDescription
{
    NSInteger memValue = [self selectedRowInComponent:1];
    NSString *memFee = [Utility descriptionForPrice:memValue];
    
    NSInteger guesValue = [self selectedRowInComponent:3];
    NSString *guesFee = [Utility descriptionForPrice:guesValue];
    
    NSString *string = [NSString stringWithFormat:@"Members %@ ● Guests %@", memFee, guesFee];
    
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


#pragma mark - Picker View Datasource


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 1 || component == 3)
    {
        return 100;
    }
    
    return 1;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (component == 0) {
        
        return [self simpleLabelWithText:@"Members"];
        
    } else if (component == 2) {
        
        return [self simpleLabelWithText:@"Guests"];
        
    } else {
        
        if (row == 0) {
            
            return [self priceLabelWithText:@"Free"];
            
        } else {
            
            NSString *title = [NSString stringWithFormat:@"$ %ld", (long)row];
            return [self priceLabelWithText:title];
        }
    }
}

#pragma mark - Helper Methods

-(UILabel*)simpleLabelWithText:(NSString*)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    
    label.font      =   [UIFont systemFontOfSize:12.0f];
    label.textColor  =  [UIColor colorWithWhite:0.48 alpha:1.0];
    
    [label sizeToFit];
    
    return label;
}

-(UILabel*)priceLabelWithText:(NSString*)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    
    label.frame             =   CGRectMake(0, 0, 80, 50);
    label.font              =   [UIFont systemFontOfSize:12.0f];
    label.textColor         =   [UIColor colorWithWhite:0.95 alpha:1.0];
    label.backgroundColor   =   [UIColor colorWithWhite:0.24 alpha:1.0];
    label.textAlignment     =   NSTextAlignmentCenter;
    
    label.layer.cornerRadius    = 2.0f;
    label.layer.masksToBounds   = YES;
    
    return label;
}

@end
