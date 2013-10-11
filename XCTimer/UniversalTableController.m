//
//  UniversalTableController.m
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "UniversalTableController.h"
#import "Person+Methods.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"

@interface UniversalTableController ()
{
    
}
@end

@implementation UniversalTableController
{

}
@synthesize tableView = _tableView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize button1;
@synthesize button2;

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    UIView *sortView = [self createSortView1];
    [self.view addSubview:sortView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(UIView *)createSortView
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0,55,(self.view.frame.size.width/4)-2.5,40);
    [button1 addTarget:self action:@selector(sortNameDec) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:@"Decending" forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button1];
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(self.view.frame.size.width/4,55,(self.view.frame.size.width/4)-2.5,40);
    [button2 addTarget:self action:@selector(sortNameAcc) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"Ascending" forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button2];
    UILabel *nameSortLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,40,(self.view.frame.size.width/2)-2.5,15)];
    nameSortLabel.text= @"Sort by Last Name";
    nameSortLabel.textColor = [UIColor whiteColor];
    nameSortLabel.backgroundColor =[UIColor clearColor];
    nameSortLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameSortLabel];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.frame = CGRectMake(5+2*(self.view.frame.size.width/4),55,(self.view.frame.size.width/4)-2.5,40);
    [button3 addTarget:self action:@selector(sortFNameDec) forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitle:@"Decending" forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button3];
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button4.frame = CGRectMake(5+3*(self.view.frame.size.width/4),55,(self.view.frame.size.width/4)-2.5,40);
    [button4 addTarget:self action:@selector(sortFNameAcc) forControlEvents:UIControlEventTouchUpInside];
    [button4 setTitle:@"Ascending" forState:UIControlStateNormal];
    [button4 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonView addSubview:button4];
    UILabel *timeSortLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2,40,(self.view.frame.size.width/2)-2.5,15)];
    timeSortLabel.text= @"Sort by First Name";
    timeSortLabel.textColor = [UIColor whiteColor];
    timeSortLabel.backgroundColor =[UIColor clearColor];
    timeSortLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeSortLabel];
    return buttonView;
}
-(UIView *)createSortView1
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0,0,(self.view.frame.size.width/2)-2.5,40);
    [button1 addTarget:self action:@selector(sortByName) forControlEvents:UIControlEventTouchUpInside];
    [[button1 titleLabel] setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [button1 setTitle:[NSString stringWithFormat:@"%@ Last Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
//    [button1 setTitle:@"ˇ By Last Name ˇ" forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.b1Down = YES;
    [buttonView addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(5+2*(self.view.frame.size.width/4),0,(self.view.frame.size.width/2)-2.5,40);
    [button2 addTarget:self action:@selector(sortByFirstName) forControlEvents:UIControlEventTouchUpInside];
    button2.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [button2 setTitle:[NSString stringWithFormat:@"%@ First Name",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
//    [button2 setTitle:@"ˇ By First Name ˇ" forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.b2Down = YES;
    [buttonView addSubview:button2];
    return buttonView;
}
-(void)sortByDate
{
    
}
-(void)sortByTime
{
    
}
-(void)sortByName
{
    
}
-(void)sortByFirstName
{
    
}

-(void)sortNameDec
{
    
}
-(void)sortNameAcc
{
    
}
-(void)sortTimeDec
{
    
}
-(void)sortTimeAcc
{
    
}
-(void)sortFNameDec
{
    
}
-(void)sortFNameAcc
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidUnload
//{
//    self.fetchedResultsController = nil;
//}

//- (NSFetchedResultsController *)fetchedResultsController
//{
//    
////    if (_fetchedResultsController != nil)
////    {
////        return _fetchedResultsController;
////    }
////    
////    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
////    NSEntityDescription *entity = [NSEntityDescription
////                                   entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
////    [fetchRequest setEntity:entity];
////    
////    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
////                              initWithKey:@"lastName" ascending:NO];
////    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
////    
////    [fetchRequest setFetchBatchSize:20];
////    
////    NSFetchedResultsController *theFetchedResultsController =
////    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
////                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
////                                                   cacheName:nil];
////    self.fetchedResultsController = theFetchedResultsController;
////    _fetchedResultsController.delegate = self;
//    
//    return _fetchedResultsController;
//    
//}
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section
//{
//    id  sectionInfo =
//    [[_fetchedResultsController sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
//}
//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
////    Person *p = [_fetchedResultsController objectAtIndexPath:indexPath];
////    cell.textLabel.text = [p name];
////    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@",
////                                 info.city, info.state];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    // Set up the cell...
//    [self configureCell:cell atIndexPath:indexPath];
//    
//    return cell;
//}
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
//{
//    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
//    [self.tableView beginUpdates];
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
//{
//    
//    UITableView *tableView = self.tableView;
//    
//    switch(type)
//    {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray
//                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray
//                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
//{
//    
//    switch(type)
//    {
//            
//        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//    [self.tableView endUpdates];
//}
@end
