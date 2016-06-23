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
#import "EventCell.h"
#import "Event.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

//MARK:- Outlets

@property (nonatomic, weak) IBOutlet UITableView                *eventsTable;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView    *activityIndicator;

//MARK:- Properties

@property (nonatomic) NSArray<Event*> *events;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Events";
    self.eventsTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self fetchEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchEvents
{
    [self.eventsTable setHidden:YES];
    [self.activityIndicator startAnimating];
    
    [NetworkHelper fetchEventsWithPageNumber:1 completion:^(BOOL success, NSArray<Event *> *events) {
       
        self.events = events;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.activityIndicator stopAnimating];
            [self.eventsTable setHidden:NO];
            [self.eventsTable reloadData];
        });
    
    }];
}

-(IBAction)refresh:(id)sender
{
    [self fetchEvents];
}

-(IBAction)createEvent:(id)sender {
    
    CreateEventVC *createVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventVC"];
    
    [self.navigationController pushViewController:createVC animated:YES];
}

#pragma UITableView Delegate/DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    
    Event *event = [self.events objectAtIndex:indexPath.row];
    [cell showDetailsOfEvent:event];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.events.count == 0) {
        
        return @"No events found in your locality";
    }
    
    return nil;
}

@end
