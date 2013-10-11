//
//  RosterController.m
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "RosterController.h"
#import "Person+Methods.h"
#import "RosterAddEditController.h"
#import "ProfileController.h"
#import "UniversalTableController.h"
#import <Parse/Parse.h>

@interface RosterController ()

@end

@implementation RosterController
{
    UIBarButtonItem *addButton;
    UIBarButtonItem *clearButton;
    UIBarButtonItem *sortButton;
    NSSortDescriptor *sort;
    UIView *sortView;
    NSMutableArray *people;
//    SVSegmentedControl *segmentControl;
}
@synthesize fetchedResultsController = __fetchedResultsController;

- (id)initWithContext:(NSManagedObjectContext*)objectContext
{
    self = [super init];
    if (self)
    {
        self.managedObjectContext = objectContext;
        
//        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
//        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
//        
//        for (Person *p in results)
//        {
//            [self.managedObjectContext deleteObject:p];
//        }
//        NSError *error;
//        if (![self.managedObjectContext save:&error]) {
//            // Handle Error.
//        }
////
////        NSLog(@"HERE");
//        Person *p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
//        p.firstName = @"Michael";
//        p.lastName = @"Bradley";
//        error = nil;
//        if(![self.managedObjectContext save:&error])
//        {
//            NSLog(@"PERSON SAVE ERROR: %@", error);
//        }

    }
    return self;
}

-(void)loadView
{
    [super loadView];
    people = [[NSMutableArray alloc]init];
    [self getOnlineData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
    // [self.tableView setContentOffset:CGPointZero animated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Roster";
//    sortView = [self createSortView1];
//    [self.view addSubview:sortView];
//    CGRect frame = self.tableView.frame;
//    frame.origin.y = self.view.frame.size.height*.1;
//    self.tableView.frame = frame;
    
    
//    NSArray *segmentTitles = [NSArray arrayWithObjects:@"Male",@"Female", nil];
    
//    segmentControl = [[SVSegmentedControl alloc] initWithSectionTitles:segmentTitles];
//    // sc.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentControl.tintColor = [UIColor colorWithRed:(48.0/255.0)
//                                               green:(65.0/255.0)
//                                                blue:(84.0/255.0)
//                                               alpha:1];
//    
//    segmentControl.thumb.tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seaFoam.png"]];
//    segmentControl.selectedIndex = 0;
//    [segmentControl addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
//    segmentControl.frame =  CGRectMake(0, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height- ( self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height));
//    [self.view addSubview:segmentControl];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seaFoam.png"]];
    self.tableView.frame = CGRectMake(0,self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);//-segmentControl.frame.size.height);
//    self.tableView.backgroundColor = [UIColor whiteColor];
    sort = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    clearButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearItem:)];
//    sortButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(sortItems:)];
    sortButton = [[UIBarButtonItem alloc]initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sortItems:)];
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 2;
    self.navigationItem.rightBarButtonItems = @[addButton,fixedSpaceBarButtonItem,sortButton,fixedSpaceBarButtonItem];
//    
//    UIToolbar *topBarView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*.1)];
//    topBarView.barStyle = UIBarStyleBlackTranslucent;
//    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(filterRoster:)];
//    UIBarButtonItem *sortLastNameButton = [[UIBarButtonItem alloc]initWithTitle:@"ˇ Sort By Last Name ˇ" style:UIBarButtonItemStyleBordered target:self action:@selector(sortByName)];
//    UIBarButtonItem *sortFirstNameButton = [[UIBarButtonItem alloc]initWithTitle:@"ˇ Sort By First Name ˇ" style:UIBarButtonItemStyleBordered target:self action:@selector(sortByFirstName)];
//    NSArray *itemArray = [NSArray arrayWithObjects:flexButton,sortFirstNameButton,sortLastNameButton,filterButton, nil];
//    [topBarView setItems:itemArray];
//    [self.view addSubview:topBarView];
}
- (void)addItem:(id)sender
{
    RosterAddEditController *addViewController = [[RosterAddEditController alloc]init];
    addViewController.managedObjectContext = self.managedObjectContext;
//    [addViewController createNewPerson];
    [self.navigationController pushViewController:addViewController animated:YES];
}
- (void)clearItem:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Roster" message:@"Are you sure you want to delete this roster" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
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
- (void)filterRoster:(id)sender
{
    
}
-(void)sortByName
{
//    if([super.button1.titleLabel.text isEqual: @"ˇ Sort By Last Name ˇ"])
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:NO];
//        [super.button1 setTitle:@"ˆ Sort By Last Name ˆ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
//    else
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
//        [super.button1 setTitle:@"ˇ Sort By Last Name ˇ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
    if([super b1Down] == YES)
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:NO];
        [super.button1 setTitle:[NSString stringWithFormat:@"%@ Last Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-up"] ] forState:UIControlStateNormal];
        super.b1Down = NO;
        [self sortTableView];
    }
    else
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
        [super.button1 setTitle:[NSString stringWithFormat:@"%@ Last Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
        super.b1Down = YES;
        [self sortTableView];
    }
}
-(void)sortByFirstName
{
//    if([super.button2.titleLabel.text isEqual: @"ˇ Sort By First Name ˇ"])
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:NO];
//        [super.button2 setTitle:@"ˆ Sort By First Name ˆ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
//    else
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
//        [super.button2 setTitle:@"ˇ Sort By First Name ˇ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
    if([super b2Down] == YES)
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:NO];
        [super.button2 setTitle:[NSString stringWithFormat:@"%@ First Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-up"] ] forState:UIControlStateNormal];
        super.b2Down = NO;
        [self sortTableView];
    }
    else
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
        [super.button2 setTitle:[NSString stringWithFormat:@"%@ First Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
        super.b2Down = YES;
        [self sortTableView];
    }
}
-(void)sortTableView
{
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self.tableView reloadData];
        
    }
}
-(void)getOnlineData
{
//    PFQuery *query = [PFQuery queryWithClassName:@"Person"];
//    [query getObjectInBackgroundWithId:@"xWMyZ4YEGZ" block:^(PFObject *gameScore, NSError *error) {
//        // Do something with the returned PFObject in the gameScore variable.
//        NSLog(@"%@", gameScore);
//    }];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Person"];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        if (!object)
//        {
//            NSLog(@"if");
//            // Did not find any UserStats for the current user
//        }
//        else
//        {
//            NSLog(@"else");
//            [people addObject:object];
//            NSLog(@"people count:%i",[people count]);
////            int highScore = [[object objectForKey:@"highScore"] intValue];
//        }
//    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Person"];
    [query findObjectsInBackgroundWithBlock:
     ^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            people = [NSMutableArray arrayWithArray:objects];
            NSLog(@"people count:%i",[people count]);
//            [self saveOnlineToLocal];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(void)saveOnlineToLocal
{
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *allPeople = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    for (NSManagedObject *person in allPeople)
    {
        Person *p = (Person*)person;
        NSArray *personTimes = [p.eventTimes allObjects];
        for(int i =0;i<[personTimes count];i++)
        {
            NSManagedObject *et = [personTimes objectAtIndex:i];
            [self.managedObjectContext deleteObject:et];
        }
        [self.managedObjectContext deleteObject:p];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    //more error handling here
    
    

    for(int i=0;i<[people count];i++)
    {
        Person *person = (Person*)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        NSString *firstName = [[people objectAtIndex:i] objectForKey:@"firstName"];
        NSString *lastName = [[people objectAtIndex:i] objectForKey:@"lastName"];
        person.firstName =firstName;
        person.lastName = lastName;
        NSLog(@"%@",person.firstName);
        NSLog(@"%@",person.lastName);
        NSError *error;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"PERSON SAVE ERROR: %@", error);
        }
    }
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
                                   entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =[[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"%u",[sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Here");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    Person *p = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text= [NSString stringWithFormat:@"%@",[p name]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seaFoam.png"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *p = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ProfileController *profileController = [[ProfileController alloc]initWithPerson:p];
    profileController.managedObjectContext = self.managedObjectContext;
    
    [self.navigationController pushViewController:profileController animated:YES];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{

    UITableView *tableView = self.tableView;

    switch(type)
    {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
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
        Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSArray *personTimes = [person.eventTimes allObjects];
        for(int i =0;i<[personTimes count];i++)
        {
            NSManagedObject *et = [personTimes objectAtIndex:i];
            [self.managedObjectContext deleteObject:et];
        }
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
