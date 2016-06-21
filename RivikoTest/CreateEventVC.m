//
//  CreateEventVC.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 20/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "CreateEventVC.h"
#import "PricePickerView.h"
#import "CommonKeyboardAccessoryView.h"

@interface CreateEventVC ()<UITextViewDelegate, UITextFieldDelegate> {
    
    NSDate *dateOfEvent;
}

@property (nonatomic, weak) IBOutlet UIScrollView       *scrollView;
@property (nonatomic, weak) IBOutlet UIControl          *addPhotoView;
@property (nonatomic, weak) IBOutlet UICollectionView   *photosCollection;
@property (nonatomic, weak) IBOutlet UITextView         *eventTitle;
@property (nonatomic, weak) IBOutlet UITextView         *eventDescription;
@property (nonatomic, weak) IBOutlet UITextField        *eventDate;
@property (nonatomic, weak) IBOutlet UITextField        *eventPayment;

@end

@implementation CreateEventVC

#define TITLE_CHAR_LIMIT 40
#define DESC_CHAR_LIMIT 300

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureKeyboardInputs];
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

-(void)updateCharacterCountForInputView:(id)inputView
{
    CommonKeyboardAccessoryView *kbAccessory = (CommonKeyboardAccessoryView*)self.eventDate.inputAccessoryView;
    
    if (inputView == self.eventTitle) {
        
        if (self.eventTitle.text.length == 0) {
            
            [kbAccessory setTitle:@"set event title"];
            
        } else {
            
            NSInteger diff = TITLE_CHAR_LIMIT - self.eventTitle.text.length;
            
            [kbAccessory setTitle:[NSString stringWithFormat:@"%ld chars left", (long)diff]];
        }
        
        
    } else if (inputView == self.eventDescription) {
        
        if (self.eventDescription.text.length == 0) {
            
            [kbAccessory setTitle:@"set event description"];
            
        } else {
            
            NSInteger diff = DESC_CHAR_LIMIT - self.eventDescription.text.length;
            
            [kbAccessory setTitle:[NSString stringWithFormat:@"%ld chars left", (long)diff]];
        }
    }
}

-(void)editingBeganOnInputView:(id)inputView
{
    CommonKeyboardAccessoryView *kbAccessory = (CommonKeyboardAccessoryView*)self.eventDate.inputAccessoryView;
    
    if (inputView == self.eventDate ) {
        
        [kbAccessory setTitle:@"set date and time"];
        
    } else if (inputView == self.eventPayment ) {
        
        [kbAccessory setTitle:@"set event fees"];
        
    } else if (inputView == self.eventTitle) {
        
        if ([self.eventTitle.text isEqualToString:@"Title"]) {
            
            self.eventTitle.text = nil;
            
            [kbAccessory setTitle:@"set event title"];
            
        } else {
            
            [self updateCharacterCountForInputView:inputView];
        }
        
    } else if (inputView == self.eventDescription) {
        
        if ([self.eventDescription.text isEqualToString:@"Description"]) {
            
            self.eventDescription.text = nil;
            
            [kbAccessory setTitle:@"set event description"];
            
        } else {
            
            [self updateCharacterCountForInputView:inputView];
        }
        
    }
}

-(void)keyboardPrevious:(id)sender
{
    if ([self.eventDescription isFirstResponder]) {
      
        [self.eventTitle becomeFirstResponder];
        
    } else if ([self.eventDate isFirstResponder]) {
        
        [self.eventDescription becomeFirstResponder];
        
    } else if ([self.eventPayment isFirstResponder]) {
        
        [self.eventDate becomeFirstResponder];
    }
}

-(void)keyboardNext:(id)sender
{
    if ([self.eventTitle isFirstResponder]) {
        
        [self.eventDescription becomeFirstResponder];
        
    } else if ([self.eventDescription isFirstResponder]) {
        
        [self.eventDate becomeFirstResponder];
        
    } else if ([self.eventDate isFirstResponder]) {
        
        [self.eventPayment becomeFirstResponder];
    }
}

-(void)keyboardDone:(id)sender
{
    if ([self.eventDate isFirstResponder]) {
        
        [self dateTappedDone];
        
    } else if ([self.eventPayment isFirstResponder]) {
        
        [self paymentTappedDone];
        
    } else {
        
        [self.view endEditing:YES];
    }
}

-(void)dateTappedDone
{
    NSLog(@"Set Date");
    
    UIDatePicker *datePicker = (UIDatePicker*)self.eventDate.inputView;
    
    if ([datePicker isMemberOfClass:[UIDatePicker class]])
    {
        dateOfEvent = [datePicker date];
        
        NSString *calDate = [self stringByFormattingDate:dateOfEvent inFormat:@"MMM d"];
        NSString *calTime = [self stringByFormattingDate:dateOfEvent inFormat:@"h:mm a"];
        NSString *dStr = [NSString stringWithFormat:@"%@ at %@", calDate, calTime];
        
        self.eventDate.text = dStr;
        [self.eventDate resignFirstResponder];
    }
}

-(void)paymentTappedDone
{
    NSLog(@"Enter Payment");
    
    PricePickerView *ppView = (PricePickerView*)self.eventPayment.inputView;
    
    self.eventPayment.text = [ppView priceDescription];
    [self.eventPayment resignFirstResponder];
}

#pragma mark - Configure Inputs

-(void)configureKeyboardInputs
{
    [self configureDatePickerView];
    [self configurePricePickerView];
    
    CommonKeyboardAccessoryView *kbAccessory = [[CommonKeyboardAccessoryView alloc] init];
    
    self.eventTitle.inputAccessoryView          =   kbAccessory;
    self.eventDescription.inputAccessoryView    =   kbAccessory;
    self.eventDate.inputAccessoryView           =   kbAccessory;
    self.eventPayment.inputAccessoryView        =   kbAccessory;
    
    [kbAccessory addTarget:self selector:@selector(keyboardPrevious:) forAccessoryButton:CustomKeyboardAccessoryButtonPrevious];
    [kbAccessory addTarget:self selector:@selector(keyboardNext:) forAccessoryButton:CustomKeyboardAccessoryButtonNext];
    [kbAccessory addTarget:self selector:@selector(keyboardDone:) forAccessoryButton:CustomKeyboardAccessoryButtonDone];
}

-(void)configureDatePickerView
{
    UIDatePicker *dPicker   = [[UIDatePicker alloc] init];
    dPicker.minuteInterval  = 15;
    
    NSDate *currentDate = [NSDate date];
    
    [dPicker setDate:currentDate];
    [dPicker setMinimumDate:currentDate];
    
    self.eventDate.inputView = dPicker;
}

-(void)configurePricePickerView
{
    PricePickerView *ppView = [[PricePickerView alloc] init];
    ppView.showsSelectionIndicator = NO;
    
    self.eventPayment.inputView = ppView;
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

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *replacement = [[textView text] stringByReplacingCharactersInRange:range withString:text];
    
    if (textView == self.eventTitle) {
        
        if (replacement.length <= TITLE_CHAR_LIMIT) {
            
            return YES;
        }
        
    } else if (textView == self.eventDescription) {
        
        if (replacement.length <= DESC_CHAR_LIMIT) {
            
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self editingBeganOnInputView:textView];
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self updateCharacterCountForInputView:textView];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self editingBeganOnInputView:textField];
    
    return YES;
}

#pragma mark - Utilities

-(NSString*)stringByFormattingDate:(NSDate*)date inFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = format;
    
    return [dateFormatter stringFromDate:date];
}

@end
