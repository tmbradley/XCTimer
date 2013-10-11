//
//  SessionController.m
//  Conference
//
//  Created by Tyler on 9/23/12.
//  Copyright (c) 2012 Benty, LLC. All rights reserved.
//

#import "SessionController.h"
#import "SessionCell.h"
#import "SessionDetailController.h"
#import "Session.h"
#import "DaySelector.h"
#import "Day.h"
#import "Timeslot+Methods.h"
#import "WEPopoverController.h"
#import "SessionFilterController.h"
#import "UIBarButtonItem+WEPopover.h"
#import "SVSegmentedControl.h"
#import "MSCollectionViewCalendarLayout.h"


@interface SessionController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation SessionController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize tableView = _tableView;

#define FOOTERHEIGHT 40

-(void)loadView
{
    [super loadView];
    
    colorArray = [[NSArray alloc] initWithObjects:
                  [UIColor colorWithPatternImage:[UIImage imageNamed:@"bluePattern.png"]],
                  [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenPattern.png"]],nil];
    
    
    filterController = [[SessionFilterController alloc] initWithColors:colorArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterDidChange)
                                                 name:@"FILTER_CHANGED_SESSION" object:nil];
    
    
    UIView *actionButtonHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 70, 36)];
    actionButtonHolder.backgroundColor = [UIColor colorForNavigationTint];
    [actionButtonHolder.layer setShadowColor:[UIColor blackColor].CGColor];
    [actionButtonHolder.layer setShadowOpacity:0.6];
    [actionButtonHolder.layer setShadowRadius:1.0];
    [actionButtonHolder.layer setShadowOffset:CGSizeMake(-1.0, 1.0)];
    
    UILabel *actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, actionButtonHolder.frame.size.width, actionButtonHolder.frame.size.height-4)];
    actionLabel.text = @"LEGEND";
    actionLabel.textAlignment = UITextAlignmentCenter;
    actionLabel.textColor = [UIColor whiteColor];
    actionLabel.font = [UIFont fontWithName:FONTNAME size:20];
    actionLabel.backgroundColor = [UIColor clearColor];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = CGRectMake(0,0,actionButtonHolder.frame.size.width,actionButtonHolder.frame.size.height);
    actionButton.showsTouchWhenHighlighted = YES;
    [actionButton addTarget:self action:@selector(filterTable:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [actionButtonHolder addSubview:actionLabel];
    [actionButtonHolder addSubview:actionButton];
    
    
    rightButton = [[UIBarButtonItem alloc] initWithCustomView:actionButtonHolder];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    int dateBoxHeight = (IS_IPAD)?40:40;

    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sequence > 0"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptors = [NSSortDescriptor sortDescriptorWithKey:@"sequence" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptors];
    
    NSError *error;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    daySelector = [[DaySelector alloc] initWithDays:matches];
	daySelector.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
	daySelector.autoresizingMask = UIViewAutoresizingNone;
    
    [daySelector addTarget:self action:@selector(datePickerDidChange) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:daySelector];

        
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, dateBoxHeight, self.view.frame.size.width, self.view.frame.size.height-dateBoxHeight-self.navigationController.navigationBar.frame.size.height-FOOTERHEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor =[UIColor colorForBackground];
    [self.view addSubview:self.tableView];
    
    onlyFavorites = NO;
    
    [self setupFooter];
    
}
-(void)toggleView:(id)selector
{
    UITableView *tb = self.tableView;
    SVSegmentedControl *control = (SVSegmentedControl*)selector;
    if (control.selectedIndex==0)
    {
        onlyFavorites=NO;
    }
    else
    {
        onlyFavorites=YES;
    }
    if(onlyFavorites)
    {
        tb.hidden = YES;
        NSLog(@"hERE");
    }
    else
    {
        tb.hidden = NO;
    }
}

-(void)setupFooter
{
    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-FOOTERHEIGHT, self.view.frame.size.width, FOOTERHEIGHT)];
    v.backgroundColor = [UIColor colorForHeader];
    
    NSArray *segmentTitles = [NSArray arrayWithObjects:@"All",@"Favorites", nil];
    
    segmentControl = [[SVSegmentedControl alloc] initWithSectionTitles:segmentTitles];
    // sc.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentControl.tintColor = [UIColor colorWithRed:(48.0/255.0)
                                               green:(65.0/255.0)
                                                blue:(84.0/255.0)
                                               alpha:1];
    
    segmentControl.frame = CGRectMake(v.frame.size.width/6,v.frame.size.height/6,v.frame.size.width*2/3,v.frame.size.height*2/3);
    
    segmentControl.thumb.tintColor = [UIColor colorWithPatternImage:[UIImage imageForNavigationBar]];
    segmentControl.selectedIndex = 0;
    [segmentControl addTarget:self action:@selector(segmentedChanged:) forControlEvents:UIControlEventValueChanged];
    // [v addSubview:bottomBar];
    [v addSubview:segmentControl];
    
    [self.view addSubview:v];
    
}

-(void)segmentedChanged:(id)selector
{
    SVSegmentedControl *control = (SVSegmentedControl*)selector;
    if (control.selectedIndex==0)
    {
        onlyFavorites=NO;
    }
    else
    {
        onlyFavorites=YES;
    }
    self.fetchedResultsController = nil;
    [self.tableView reloadData];

}

-(void)filterDidChange
{
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

-(void)filterTable:(id)selector
{
    NSLog(@"FILTER TABLE");
    if (!popoverController) {
        
		popoverController = [[WEPopoverController alloc] initWithContentViewController:filterController];
		popoverController.delegate = self;
		popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
		
		[popoverController presentPopoverFromBarButtonItem:rightButton
                                  permittedArrowDirections:UIPopoverArrowDirectionUp
                                                  animated:YES];
        
	}
    else {
		[popoverController dismissPopoverAnimated:YES];
		popoverController = nil;
	}
    
    // [self.tableView reloadData];
}


-(void)datePickerDidChange
{
    NSLog(@"Date Change");
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
   // [self.tableView setContentOffset:CGPointZero animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (popoverController)
    {
        [popoverController dismissPopoverAnimated:YES];
        popoverController = nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"SESSION";
	// Do any additional setup after loading the view.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (IS_IPAD)? 140:80;
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SessionCell";
    
    SessionCell *cell = (SessionCell*)[localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SessionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   
    cell.contentDividerTop.backgroundColor = [UIColor colorForCellPrimary];
    cell.contentDividerBottom.backgroundColor = [UIColor colorForCellPrimary];
    cell.timeDividerTop.backgroundColor = [UIColor whiteColor];
    cell.timeDividerBottom.backgroundColor = [UIColor whiteColor];
    
    NSInteger rowsAmount = [localTableView numberOfRowsInSection:[indexPath section]];
    if ([indexPath row] == rowsAmount - 1)
    {
        cell.contentDividerBottom.backgroundColor = [UIColor clearColor];
        cell.timeDividerBottom.backgroundColor = [UIColor clearColor];
    }
    
    if ([indexPath row] == 0)
    {
        cell.contentDividerTop.backgroundColor = [UIColor clearColor];
        cell.timeDividerTop.backgroundColor = [UIColor clearColor];


    }

    Session *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.timeLabel.text = [session.timeslot startTime];
    cell.primaryLabel.text = session.title;
    cell.secondaryLabel.text = session.subtitle;
    
    [cell setTypeValue:session.type];
    
    if ([session.isFavorite boolValue])
        [cell showRibbon];
    else
        [cell hideRibbon];
    
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // NSLog(@"Sections: %d", [self.sectionsArray count]);
    //return [self.sectionsArray count];
    return 1;
   // return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tempTableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    //return 6;
    return [sectionInfo numberOfObjects];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Session *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    SessionDetailController *detail = [[SessionDetailController alloc] initWithSession:session];
    detail.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:self.managedObjectContext];
    
    
    [fetchRequest setEntity:entity];
    NSPredicate * predicate;
//    predicate = [NSPredicate predicateWithFormat:@"deleted == 0 && day.dayID == %@ ",[[daySelector getDay] dayID]];

    if (!filterController)
    {
       if (onlyFavorites)
           predicate = [NSPredicate predicateWithFormat:@"deleted == 0 && day.dayID == %@ && isFavorite == %@",[[daySelector getDay] dayID], [NSNumber numberWithBool:YES]];
       else
           predicate = [NSPredicate predicateWithFormat:@"deleted == 0 && day.dayID == %@ ",[[daySelector getDay] dayID]];
    }
    else
    {
         if (onlyFavorites)
             predicate = [NSPredicate predicateWithFormat:@"deleted == 0 && day.dayID == %@ && type IN %@ && isFavorite == %@",[[daySelector getDay] dayID],[filterController selectedObjects], [NSNumber numberWithBool:YES]];
         else
             predicate = [NSPredicate predicateWithFormat:@"deleted == 0 && day.dayID == %@ && type IN %@",[[daySelector getDay] dayID],[filterController selectedObjects]];
    }
    
    [fetchRequest setPredicate: predicate];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeslot.sequence" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"sessionID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return __fetchedResultsController; 
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tempTableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tempTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tempTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tempTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tempTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
//    Session *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//  //  [(SessionCell*)cell removeTime];
//  //  [(SessionCell*)cell removeTypeBox];
//    
//    
//    cell.timeLabel.text = @"9:00 AM";
//    cell.primaryLabel.text = @"EDUCATION LEARNING";
//    cell.secondaryLabel.text = @"AN IN-DEPTH LOOK AT WHAT TECHNOLOGY CAN BE USED FOR IN TODAY’S AGE";
//    
//    
//    cell.textLabel.text = session.title;
//    cell.detailTextLabel.text = event.location;
//    [(SessionCell*)cell setTime:[NSString stringWithFormat:@"%@\n%@",event.startTime,event.endTime]];
//    [(SessionCell*)cell setType:event.type color:[colorArray objectAtIndex:[event.type intValue]-1]];
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

@end
