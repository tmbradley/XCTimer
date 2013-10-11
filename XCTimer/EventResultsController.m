//
//  EventResultsController.m
//  XCTimer
//
//  Created by MBradley on 1/26/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "EventResultsController.h"
#import "EventResultsEditController.h"
#import "AddEventResultController.h"
#import "Person+Methods.h"
#import "EventTime.h"
#import "Event.h"
#import "RaceResultsController.h"

@interface EventResultsController ()

@end

@implementation EventResultsController
{
    Person *person;
    NSMutableArray *people;
    NSMutableArray *times;
    UIBarButtonItem *addButton;
    UIBarButtonItem *sortButton;
    EventTime *eventTime;
    UIView *sortView;
    NSSortDescriptor *sort;
    UIButton *button3;
    UIButton *button1;
    NSString *placeString;
    NSString *bestString;
    int navBar;
}
@synthesize tableView;
@synthesize event;
@synthesize fetchedResultsController = __fetchedResultsController;

-(id)initWithEvent:(Event *)e
{
    if(self = [super init])
    {
        self.event = e;
    }
    return self;
    
}
-(UIView *)createSortView
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0,0,(self.view.frame.size.width/2)-2.5,40);
    [button1 addTarget:self action:@selector(sortByLastName) forControlEvents:UIControlEventTouchUpInside];
    [[button1 titleLabel] setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [button1 setTitle:[NSString stringWithFormat:@"%@ Last Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button1];
    ////    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ////    button2.frame = CGRectMake(self.view.frame.size.width/4,55,(self.view.frame.size.width/4)-2.5,40);
    ////    [button2 addTarget:self action:@selector(sortDateAcc) forControlEvents:UIControlEventTouchUpInside];
    ////    [button2 setTitle:@"Ascending" forState:UIControlStateNormal];
    ////    [button2 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    ////    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ////    [buttonView addSubview:button2];
    //    UILabel *nameSortLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,40,(self.view.frame.size.width/2)-2.5,15)];
    //    nameSortLabel.text= @"Sort by Date";
    //    nameSortLabel.textColor = [UIColor whiteColor];
    //    nameSortLabel.backgroundColor =[UIColor clearColor];
    //    nameSortLabel.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:nameSortLabel];
    
    button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.frame = CGRectMake(5+2*(self.view.frame.size.width/4),0,(self.view.frame.size.width/2)-2.5,40);
    [button3 addTarget:self action:@selector(sortByTime) forControlEvents:UIControlEventTouchUpInside];
    [[button3 titleLabel] setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [button3 setTitle:[NSString stringWithFormat:@"%@ Time",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button3];
    //    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    button4.frame = CGRectMake(5+3*(self.view.frame.size.width/4),55,(self.view.frame.size.width/4)-2.5,40);
    //    [button4 addTarget:self action:@selector(sortTimeAcc) forControlEvents:UIControlEventTouchUpInside];
    //    [button4 setTitle:@"Ascending ˆ" forState:UIControlStateNormal];
    //    [button4 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    //    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [buttonView addSubview:button4];
    //    UILabel *timeSortLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,40,(self.view.frame.size.width/2)-2.5,15)];
    //    timeSortLabel.text= @"Sort by Time";
    //    timeSortLabel.textColor = [UIColor whiteColor];
    //    timeSortLabel.backgroundColor =[UIColor clearColor];
    //    timeSortLabel.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:timeSortLabel];
    return buttonView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    navBar = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;

    sortView = [self createSortView];
    [self.view addSubview:sortView];
    sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0+navBar ,self.view.frame.size.width,self.view.frame.size.height)style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
//    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
//    self.navigationItem.RightBarButtonItem = addButton;
//    editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    sortButton = [[UIBarButtonItem alloc]initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sortItems:)];
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 12;
    self.navigationItem.rightBarButtonItems = @[addButton, fixedSpaceBarButtonItem,sortButton];
    self.fetchedResultsController = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [NSString stringWithFormat:@"%@",event.name];
    people = [[NSMutableArray alloc]initWithArray:[event.people allObjects]];
    for (EventTime *e in [self.event.eventTimes allObjects])
    {
        NSLog(@"EventTime Person name is:%@",e.person.name);
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"event == %@",[self.event objectID]];
        NSLog(@"The event Search is:%@",pred);
    }
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}
- (NSFetchedResultsController *)fetchedResultsController
{
    NSLog(@"FETCHING");
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"EventTime" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
//    NSString *currentEvent = [NSString stringWithFormat:@"%@",self.event.name];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"event == %@",[self.event objectID]];
//    NSPredicate *preed = [NSPredicate predicateWithFormat:@"%@ == %@",event.name,currentEvent];
//    NSPredicate *eventSearch = [NSPredicate predicateWithFormat:@"%@ == %@",[event name],[self.event name]];
//    NSString *eventName= [NSString stringWithFormat:@"event.name == %@'",self.title];
//    NSPredicate *eventSearch = [NSPredicate predicateWithFormat:eventName];
//    NSPredicate *eventSearch = [NSPredicate predicateWithFormat:@"event.name == %@",self.title];
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == '%@'",self.title];
    [fetchRequest setPredicate:pred];
    
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    // theFetchedResultsController.delegate = self;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"ERROR");
        abort();
    }
    
    return __fetchedResultsController;
    
}
-(void)sortByLastName
{
//    if([button1.titleLabel.text isEqual: @"ˇ Sort By Last Name ˇ"])
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"person.lastName" ascending:YES];
//        [button1 setTitle:@"ˆ Sort By Last Name ˆ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
//    else
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"person.lastName" ascending:NO];
//        [button1 setTitle:@"ˇ Sort By Last Name ˇ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
    if([super b1Down] == YES)
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"person.lastName" ascending:YES];
//        [button1 setTitle:@"ˆ By Last Name ˆ" forState:UIControlStateNormal];
        [button1 setTitle:[NSString stringWithFormat:@"%@ Last Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-up"] ] forState:UIControlStateNormal];
        super.b1Down = NO;
        [self sortTableView];
    }
    else
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"person.lastName" ascending:NO];
//        [button1 setTitle:@"ˇ By Last Name ˇ" forState:UIControlStateNormal];
        [button1 setTitle:[NSString stringWithFormat:@"%@ Last Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
        super.b1Down = YES;
        [self sortTableView];
    }
}
-(void)sortByTime
{
//    if([button3.titleLabel.text isEqual: @"ˇ Sort By Time ˇ"])
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:NO];
//        [button3 setTitle:@"ˆ Sort By Time ˆ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
//    else
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
//        [button3 setTitle:@"ˇ Sort By Time ˇ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
    if([super b1Down] == YES)
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
//        [button3 setTitle:@"ˆ By Time ˆ" forState:UIControlStateNormal];
        [button3 setTitle:[NSString stringWithFormat:@"%@ Time",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-up"] ] forState:UIControlStateNormal];
        super.b1Down = NO;
        [self sortTableView];
    }
    else
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:NO];
//        [button3 setTitle:@"ˇ By Time ˇ" forState:UIControlStateNormal];
        [button3 setTitle:[NSString stringWithFormat:@"%@ Time",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
        super.b1Down = YES;
        [self sortTableView];
    }
}
-(void)sortTableView
{
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}
-(NSString *)getBestTime:(EventTime *)eventTimeBest
{
    NSArray *timesBest = [eventTimeBest.person.eventTimes allObjects];
//    NSMutableArray *filteredArray = [[NSMutableArray alloc]init];
//    for(int i = 0; i< [timesBest count]; i++)
//    {
//        NSLog(@"Race for Et: %@",[[timesBest objectAtIndex:i] event].race);
//        EventTime *Ee = [timesBest objectAtIndex:i];
//        if([event.name isEqualToString:Ee.event.name])
//        {
//            [filteredArray addObject:[timesBest objectAtIndex:i]];
////            [filteredArray arrayByAddingObject:[timesBest objectAtIndex:i]];
//            NSLog(@"Event.name: %@",event.name);
//            NSLog(@"EventTimeBest.event.name: %@",eventTimeBest.event.name);
//            NSLog(@"filteredArray count:%i",[filteredArray count]);
//        }
//    }
    NSLog(@"BEFORE: %i", [timesBest count]);
    NSLog(@"%@", eventTimeBest.event);
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"event.name == %@",eventTimeBest.event.name];
    timesBest = [timesBest filteredArrayUsingPredicate:pred];
    
     NSLog(@"AFTER: %i", [timesBest count]);
    
    
    for(int i =0; i<[timesBest count];i++)
    {
        EventTime *et = [timesBest objectAtIndex:i];
        NSLog(@"Times Before:%@",et.time);
    }
    NSSortDescriptor *sortBest = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    timesBest = [timesBest sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortBest]];
    for(int i =0; i<[timesBest count];i++)
    {
        EventTime *et = [timesBest objectAtIndex:i];
        NSLog(@"Times After:%@",et.time);
    }
    if(timesBest != nil && [timesBest count] >= 1)
    {
        bestString = [[timesBest objectAtIndex:0] timeString];
        NSLog(@"%@",[timesBest objectAtIndex:0]);
    }
    return bestString;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =[[self.fetchedResultsController sections] objectAtIndex:section];
//    NSLog(@"The number of sections in the EventResutlsController table are:%u",[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Here");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    EventTime *et = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    NSLog(@"The eventTime string is:%@",et.timeString);
    cell.textLabel.text= [NSString stringWithFormat:@"%@",et.person.name];
    int min = [et.time intValue]/60;
    int sec = [et.time intValue]%60;
    NSString *secString = [[NSString alloc]init];
    if(sec < 10)
    {
        secString = [NSString stringWithFormat:@"0%i",sec];
//        NSLog(@"%@",[NSString stringWithFormat:@"0%i",sec]);
    }
    else
    {
        secString = [NSString stringWithFormat:@"%i",sec];
    }
//    NSLog(@"Number of Seconds:%i",sec);
    NSString *minTimeString = [NSString stringWithFormat:@"%i:",min];
    NSString *timeString = [minTimeString stringByAppendingString:secString];
//    NSLog(@"place is:%@",et.place);
    if(et.place == NULL)
    {
        placeString = [NSString stringWithFormat:@""];
    }
    else
    {
        placeString = [NSString stringWithFormat:@"%@",et.place];
    }
    NSLog(@"ASDFSDFASDFASDF:%@",et.event.name);
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@   %@   %@",[self getBestTime:(et)],placeString,timeString];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    //    return [tableData count];
//    NSLog(@"Person count is:%i",[people count]);
//    return [people count];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
//    Person *runner = [people objectAtIndex:indexPath.row];
//    cell.textLabel.text = [runner name];
////    EventTime *et = [[pi.eventTimes allObjects] objectAtIndex:0];
//    NSPredicate *eventSearch = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"event.name like'%@'",self.event.name]];
//    EventTime *et = [runner.eventTimes filteredSetUsingPredicate:eventSearch];
////    EventTime *et = [[[pi.eventTimes filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"event == %@", event]] allObjects] objectAtIndex:0];
//    cell.detailTextLabel.text = et.timeString;
////    cell.detailTextLabel.text = pi.time;
//    NSLog(@"The Time was:%@",et.timeString);
//    return cell;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    EventTime *et = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"ETTTTTT is:%@",et);
    Person *p = et.person;
    RaceResultsController *raceResultsController = [[RaceResultsController alloc]initWithPerson:p EventTime:et];
    raceResultsController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:raceResultsController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)addItem:(id)sender
{
    AddEventResultController *addEventController = [[AddEventResultController alloc]initWithEvent:event EventTime:eventTime];
    addEventController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:addEventController animated:YES];
}
- (void)sortItems:(id)sender
{
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = self.tableView.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = 50;
                         else
                             frame.origin.y = 0;
                         self.tableView.frame = frame;
                     }
                     completion:nil];
}
-(void)edit:(id)sender
{
    EventResultsEditController *eventEditViewController = [[EventResultsEditController alloc] init];
    eventEditViewController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:eventEditViewController animated:YES];
    
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    //UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:object];
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            // Handle Error.
        }
    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
