//
//  ViewController.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 20/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "ViewController.h"
#import "CreateEventVC.h"
#import "NetworkHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchEvents
{
    [NetworkHelper fetchEventsWithPageNumber:1 completion:^(BOOL success, NSArray<Event *> *events) {
       
        
    }];
}

-(IBAction)createEvent:(id)sender {
    
    CreateEventVC *createVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventVC"];
    
    [self.navigationController pushViewController:createVC animated:YES];
}

@end
