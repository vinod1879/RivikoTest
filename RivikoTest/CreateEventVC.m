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
#import "EventPhotoCell.h"
#import "Utility.h"
#import "NetworkHelper.h"
#import "Event.h"

@interface CreateEventVC ()<UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, EventPhotoCellDelegate> {
    
    NSDate                  *dateOfEvent;
    NSArray <UIImage*>      *eventImages;
    NSNumber                *memberFee;
    NSNumber                *guestFee;
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

-(IBAction)addEventTapped:(id)sender
{
    [self.view endEditing:YES];
    
    Event *event = [[Event alloc] init];
    
    event.eventName         = self.eventTitle.text;
    event.eventDescription  = self.eventDescription.text;
    event.startTime         = dateOfEvent;
    event.memberFee         = memberFee;
    event.guestFee          = guestFee;
    event.images            = eventImages;
    
    if ([event isValid]) {
        
        [NetworkHelper addEvent:event completion:^(BOOL success, NSInteger eventId) {
            
        }];
    }
    
}

-(IBAction)addPhotoTapped:(id)sender
{
    NSLog(@"Add Photo");
    
    [self showImagePicker];
}

-(void)showImagePicker
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
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
        
        NSString *calDate = [Utility stringByFormattingDate:dateOfEvent inFormat:@"MMM d"];
        NSString *calTime = [Utility stringByFormattingDate:dateOfEvent inFormat:@"h:mm a"];
        NSString *dStr = [NSString stringWithFormat:@"%@ at %@", calDate, calTime];
        
        self.eventDate.text = dStr;
        [self.eventDate resignFirstResponder];
    }
}

-(void)paymentTappedDone
{
    NSLog(@"Enter Payment");
    
    PricePickerView *ppView = (PricePickerView*)self.eventPayment.inputView;
    
    self.eventPayment.attributedText = [ppView priceDescription];
    memberFee   = [NSNumber numberWithInteger:[ppView membersFeeValue]];
    guestFee    = [NSNumber numberWithInteger:[ppView guestsFeeValue]];
    
    [self.eventPayment resignFirstResponder];
}

#pragma mark - UIImagePickerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image) {
        
        [self addEventImage:image];
    }
}

-(void)addEventImage:(UIImage*)image
{
    NSMutableArray<UIImage*> *mArray = (eventImages) ? [NSMutableArray arrayWithArray:eventImages] : [NSMutableArray new];
    
    if (![mArray containsObject:image]) {
        
        [mArray addObject:image];
        eventImages = [NSArray arrayWithArray:mArray];
        [self reloadImages];
    }
}

-(void)deleteImageAtIndex:(NSInteger)index
{
    if (eventImages && eventImages.count > index) {
        
        NSMutableArray<UIImage*> *mArray = [NSMutableArray arrayWithArray:eventImages];
        
        [mArray removeObjectAtIndex:index];
        eventImages = [NSArray arrayWithArray:mArray];
        
        [self reloadImages];
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        [self.photosCollection deleteItemsAtIndexPaths:@[indexPath]];
    }
}

-(void)reloadImages
{
    [self.photosCollection setHidden:(eventImages.count == 0)];
    [self.addPhotoView setHidden:(eventImages.count != 0)];
    
    [self.photosCollection reloadData];
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
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        self.scrollView.contentInset            = UIEdgeInsetsZero;
        self.scrollView.scrollIndicatorInsets   = UIEdgeInsetsZero;
    });
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

-(void)textViewDidEndEditing:(UITextView *)textView
{
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textView.text.length == 0) {
        
        if (textView == self.eventTitle) {
            
            [self.eventTitle setText:@"Title"];
            
        } else if (textView == self.eventDescription) {
            
            [self.eventDescription setText:@"Description"];
        }
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self editingBeganOnInputView:textField];
    
    return YES;
}

#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return eventImages.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EventPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EventPhotoCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    UIImage *image = [eventImages objectAtIndex:indexPath.row];
    
    [cell setImage:image withIndex:indexPath.row];
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"AddPhotoFooter" forIndexPath:indexPath];
    
    UITapGestureRecognizer *footerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotoTapped:)];
    
    footerTap.delaysTouchesBegan = YES;
    footerTap.numberOfTapsRequired = 1;
    [reuseView addGestureRecognizer:footerTap];
    
    return reuseView;
}

#pragma mark - Event Photo Cell Delegate

-(void)eventPhotoCell:(EventPhotoCell *)eventPhotoCell deletedImageWithIndex:(NSInteger)index
{
    [self deleteImageAtIndex:index];
}

@end
