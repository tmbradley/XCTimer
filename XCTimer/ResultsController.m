//
//  ResultsController.m
//  XCTimer
//
//  Created by MBradley on 12/30/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "ResultsController.h"
#import "RaceController.h"
#import "Event+Methods.h"
#import "Race+Methods.h"
#import "EventTime.h"
#import "RaceAddEditController.h"

@interface ResultsController ()

@end

@implementation ResultsController
{
    UIBarButtonItem *addButton;
    NSMutableArray *races;
    NSMutableArray *returnArray;
    NSUserDefaults *defaults;
    int navBar;
}
@synthesize fetchedResultsController = __fetchedResultsController;

- (id)initWithContext:(NSManagedObjectContext*)objectContext
{
    self = [super init];
    if (self)
    {
        self.managedObjectContext = objectContext;
    }
    return self;
}
-(void)loadView
{
    [super loadView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
//    [self filterToCurrentResults];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
    // [self.tableView setContentOffset:CGPointZero animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navBar = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    
    self.title = @"Results";
    self.tableView.frame = CGRectMake(0,self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.RightBarButtonItem = addButton;
    races = [[NSMutableArray alloc]init];
    returnArray = [[NSMutableArray alloc]init];
    defaults = [NSUserDefaults standardUserDefaults];
    
}
- (void)addItem:(id)sender
{
    RaceAddEditController *raceAddEditController = [[RaceAddEditController alloc]initWithContext: self.managedObjectContext];
    [self.navigationController pushViewController:raceAddEditController animated:YES];
}
- (NSFetchedResultsController *)fetchedResultsController
{
    NSLog(@"FETCHING Results Controller");
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Race" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    if([defaults objectForKey:@"startDate"])
    {
        NSPredicate *range = [NSPredicate predicateWithFormat:@"date >= %@ && date =< %@",[defaults objectForKey:@"startDate"],[defaults objectForKey:@"stopDate"]];
            [fetchRequest setPredicate:range];
    }
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
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
-(NSMutableArray*)filterToCurrentResults:(Race *)r
{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Race"];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Race" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
    
    Race *tempRace = r;
    NSDate *start = [defaults objectForKey:@"startDate"];
    NSLog(@"AAAAAAA");
    NSComparisonResult result = [tempRace.date compare:start];
    if(result==NSOrderedAscending)
    {
        
    }
    else if(result==NSOrderedDescending)
    {
        NSLog(@"ASAS");
        [returnArray addObject:tempRace];
        NSLog(@"%@",returnArray);
    }
//    if(tempRace.date > [defaults objectForKey:@"startDate"])
//    {
//        
//    }
//    if([tempRace.date isEqualToDate:start])
//    {
//        NSLog(@"ASAS");
//        [returnArray addObject:tempRace];
//        NSLog(@"%@",returnArray);
//    }
    return returnArray;
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
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Race *r = [self.fetchedResultsController objectAtIndexPath:indexPath];
////    [races addObject:r];
//    races = [self filterToCurrentResults:r];
    NSLog(@"Race count:%i",[races count]);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
    cell.textLabel.text= [NSString stringWithFormat:@"%@",[r name]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Race *r = [self.fetchedResultsController objectAtIndexPath:indexPath];
    RaceController *raceController = [[RaceController alloc]initWithRace:r];
    raceController.managedObjectContext = self.managedObjectContext;
    
    [self.navigationController pushViewController:raceController animated:YES];
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
        Race *race = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:race];
        for(int i =0;i<[race.events count];i++)
        {
            NSArray *events = [race.events allObjects];
            EventTime *et = [events objectAtIndex:i];
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
