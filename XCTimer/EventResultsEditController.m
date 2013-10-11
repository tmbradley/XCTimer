//
//  EventResultsEditController.m
//  XCTimer
//
//  Created by MBradley on 1/26/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "EventResultsEditController.h"
#import "AddEventResultController.h"

@interface EventResultsEditController ()

@end

@implementation EventResultsEditController
{
    UIBarButtonItem *addButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.RightBarButtonItem = addButton;
}
- (void)addItem:(id)sender
{
    AddEventResultController *addEventController = [[AddEventResultController alloc]init];
    addEventController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:addEventController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
