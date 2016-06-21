//
//  ViewController.m
//  RivikoTest
//
//  Created by Vinod Vishwanath on 20/06/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

#import "ViewController.h"
#import "CreateEventVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)createEvent:(id)sender {
    
    CreateEventVC *createVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventVC"];
    
    [self.navigationController pushViewController:createVC animated:YES];
}

@end
