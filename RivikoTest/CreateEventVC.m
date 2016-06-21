//
//  CreateEventVC.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 20/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "CreateEventVC.h"

@interface CreateEventVC ()<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView       *scrollView;
@property (nonatomic, weak) IBOutlet UIControl          *addPhotoView;
@property (nonatomic, weak) IBOutlet UICollectionView   *photosCollection;
@property (nonatomic, weak) IBOutlet UITextView         *eventTitle;
@property (nonatomic, weak) IBOutlet UITextView         *eventDescription;
@property (nonatomic, weak) IBOutlet UILabel            *eventDate;
@property (nonatomic, weak) IBOutlet UILabel            *eventPayment;

@end

@implementation CreateEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subscribeToKeyboardEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

-(IBAction)addPhotoTapped:(id)sender
{
    NSLog(@"Add Photo");
}

-(IBAction)dateTapped:(id)sender
{
    NSLog(@"Set Date");
}

-(IBAction)paymentTapped:(id)sender
{
    NSLog(@"Enter Payment");
}

#pragma mark - Keyboard Handling

-(void)subscribeToKeyboardEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardWillAppear:(NSNotification*)notification
{
    NSLog(@"Keyboard Will Appear");
    
    NSDictionary *info = [notification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets              = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
    
    self.scrollView.contentInset            = contentInsets;
    self.scrollView.scrollIndicatorInsets   = contentInsets;
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    NSLog(@"Keyboard Did Hide");
    
    self.scrollView.contentInset            = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets   = UIEdgeInsetsZero;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *replacement = [[textView text] stringByReplacingCharactersInRange:range withString:text];
    
    if (textView == self.eventTitle) {
        
        if (replacement.length <= 40) {
            
            return YES;
        }
        
    } else if (textView == self.eventDescription) {
        
        if (replacement.length <= 300) {
            
            return YES;
        }
    }
    
    return NO;
}

@end
