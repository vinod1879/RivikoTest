//
//  PricePickerView.h
//  RivikoTest
//
//  Created by Vinod Vishwanath on 21/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PricePickerView : UIPickerView

-(NSAttributedString*)priceDescription;
-(NSInteger)membersFeeValue;
-(NSInteger)guestsFeeValue;

@end
