//
//  RaceController.m
//  XCTimer
//
//  Created by MBradley on 12/31/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "RaceController.h"
#import "ResultsController.h"
#import "RaceAddEditController.h"
#import "EventResultsController.h"
#import "Event+Methods.h"
#import "Race+Methods.h"

@interface RaceController ()

@end

@implementation RaceController
{
    Race *race;
    NSMutableArray *events;
}
@synthesize tableView;
-(id)initWithRace:(Race *)r
{
    if(self = [super init])
    {
        race = r;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    self.navigationItem.RightBarButtonItem = editButton;
    int imageHeight = self.view.frame.size.width/3;
    raceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight/2, imageHeight/4,imageHeight*2, imageHeight/4)];
    raceNameLabel.backgroundColor = [UIColor clearColor];
    raceNameLabel.textColor = [UIColor whiteColor];
    raceNameLabel.textAlignment = NSTextAlignmentCenter;
    raceNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    [self.view addSubview:raceNameLabel];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, raceNameLabel.frame.origin.y+raceNameLabel.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-(raceNameLabel.frame.origin.y+raceNameLabel.frame.size.height))style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
    events = [[NSMutableArray alloc]initWithArray:[race.events allObjects]];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [NSString stringWithFormat:@"%@",race.name];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    raceNameLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:race.date]];
    events = [[NSMutableArray alloc]initWithArray:[race.events allObjects]];
    [tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [tableData count];
    return [events count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
    cell.textLabel.text = [[events objectAtIndex:indexPath.row] name];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    EventResultsController *eventViewController = [[EventResultsController alloc] initWithEvent:[events objectAtIndex:indexPath.row]];
    eventViewController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:eventViewController animated:YES];
}
-(void)edit
{
    RaceAddEditController *editViewController = [[RaceAddEditController alloc] initWithRace:race];
    editViewController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:editViewController animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
