//
//  RaceResultsController.m
//  XCTimer
//
//  Created by MBradley on 2/27/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "RaceResultsController.h"
#import "Person+Methods.h"
#import "EventTime.h"
#import "Event+Methods.h"
#import "Race+Methods.h"

@interface RaceResultsController ()

@end

@implementation RaceResultsController
{
    Person *person;
    EventTime *eventTime;
    Event *event;
    NSArray *allTimes;
    UIBarButtonItem *sortButton;
    UIView *sortView;
    NSSortDescriptor *sort;
    UIButton *button3;
    UIButton *button1;
    NSUserDefaults *defaults;
    int cellColorNumber;
    int navBar;
}
@synthesize tableView = _tableView;
@synthesize fetchedResultsController = __fetchedResultsController;
-(id)initWithPerson:(Person*)p
{
    if(self = [super init])
    {
        person = p;
    }
    return self;
}
-(id)initWithPerson:(Person*)p EventTime:(EventTime*)et
{
    if(self = [super init])
    {
        person = p;
        eventTime = et;
        event = et.event;
    }
    return self;
}
-(UIView *)createSortView
{
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(0,0,(self.view.frame.size.width/2)-2.5,40);
    [button1 addTarget:self action:@selector(sortByDate) forControlEvents:UIControlEventTouchUpInside];
    [[button1 titleLabel] setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [button1 setTitle:[NSString stringWithFormat:@"%@ Date",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
//    [button1 setTitle:@"ˇ Sort By Date ˇ" forState:UIControlStateNormal];
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
//    [button3 setTitle:@"ˇ Sort By Time ˇ" forState:UIControlStateNormal];
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

-(void)sortByDate
{
//    if([button1.titleLabel.text isEqual: @"ˇ Sort By Date ˇ"])
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"event.race.date" ascending:NO];
//        [button1 setTitle:@"ˆ Sort By Date ˆ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
//    else
//    {
//        sort = [[NSSortDescriptor alloc]initWithKey:@"event.race.date" ascending:YES];
//        [button1 setTitle:@"ˇ Sort By Date ˇ" forState:UIControlStateNormal];
//        [self sortTableView];
//    }
    if([super b1Down] == YES)
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"event.race.date" ascending:NO];
        [button1 setTitle:[NSString stringWithFormat:@"%@ Date",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-up"] ] forState:UIControlStateNormal];
//        [button1 setTitle:@"ˆ Sort By Date ˆ" forState:UIControlStateNormal];
        super.b1Down = NO;
        [self sortTableView];
    }
    else
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"event.race.date" ascending:YES];
        [button1 setTitle:[NSString stringWithFormat:@"%@ Date",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
//        [button1 setTitle:@"ˇ Sort By Date ˇ" forState:UIControlStateNormal];
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
        sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:NO];
        [button3 setTitle:[NSString stringWithFormat:@"%@ Time",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-up"] ] forState:UIControlStateNormal];
//        [button3 setTitle:@"ˆ Sort By Time ˆ" forState:UIControlStateNormal];
        super.b1Down = NO;
        [self sortTableView];
    }
    else
    {
        sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
        [button3 setTitle:[NSString stringWithFormat:@"%@ Time",[NSString fontAwesomeIconStringForIconIdentifier:@"icon-sort-down"] ] forState:UIControlStateNormal];
//        [button3 setTitle:@"ˇ Sort By Time ˇ" forState:UIControlStateNormal];
        super.b1Down = YES;
        [self sortTableView];
    }
}
-(void)sortTableView
{
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navBar = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
	// Do any additional setup after loading the view.
    sortView = [self createSortView];
    [self.view addSubview:sortView];
    sort = [[NSSortDescriptor alloc]initWithKey:@"event.race.date" ascending:NO];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0+navBar, self.view.frame.size.width,( self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = [NSString stringWithFormat:@"%@",person.name];
    [self.view addSubview:self.tableView];
    allTimes = [person.eventTimes allObjects];
    sortButton = [[UIBarButtonItem alloc]initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sortItems:)];
    self.navigationItem.RightBarButtonItem = sortButton;
    defaults = [NSUserDefaults standardUserDefaults];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
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
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"event", nil]];
    
    [fetchRequest setFetchBatchSize:20];
    if(eventTime)
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"person == %@ && event.race.date >= %@ && event.race.date =< %@ && event.name == %@",[person objectID],[defaults objectForKey:@"startDate"],[defaults objectForKey:@"stopDate"],[event name]];
        [fetchRequest setPredicate:pred];
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
        cellColorNumber = 1;
        
    }
    else
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"person == %@ && event.race.date >= %@ && event.race.date =< %@",[person objectID],[defaults objectForKey:@"startDate"],[defaults objectForKey:@"stopDate"]];
        [fetchRequest setPredicate:pred];
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seaFoam.png"]];
        cellColorNumber = 2;
    }
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
//    int *nums=[allTimes count];
//    NSLog(@"Number of times for runner:%u",nums);
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//    EventTime *et = [allTimes objectAtIndex:indexPath.row];
//    cell.textLabel.text = et.timeString;
//    cell.detailTextLabel.text = et.event.race.date;
//    Person *p = [self.fetchedResultsController objectAtIndexPath:indexPath];
    EventTime *et = [self.fetchedResultsController objectAtIndexPath:indexPath];
    int min = [et.time intValue]/60;
    int sec = [et.time intValue]%60;
    NSString *secString = [[NSString alloc]init];
    if(sec < 10)
    {
        secString = [NSString stringWithFormat:@"0%i",sec];
        NSLog(@"%@",[NSString stringWithFormat:@"0%i",sec]);
    }
    else
    {
        secString = [NSString stringWithFormat:@"%i",sec];
    }
    NSLog(@"Number of Seconds:%i",sec);
    NSString *minTimeString = [NSString stringWithFormat:@"%i:",min];
    NSString *timeString = [minTimeString stringByAppendingString:secString];
    if(cellColorNumber == 1)
    {
        cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.png"]];
    }
    else if(cellColorNumber == 2)
    {
        cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"seaFoam.png"]];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",timeString];
    NSLog(@"%@",[et event]);
//    cell.detailTextLabel.text = et.event.race.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@     %@     %@",[et event].race.name,[dateFormatter stringFromDate:[et event].race.date],[et event].name];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[et event].race.date];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self getBestOfThree];
//    [self getBestTime];
//    [self getAverage];
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
-(void)getBestTime
{
    NSArray *times = [person.eventTimes allObjects];
    for(int i =0; i<[times count];i++)
    {
        EventTime *et = [times objectAtIndex:i];
        NSLog(@"Times Before:%@",et.time);
    }
    //    NSExpression *exp = [NSExpression expressionWithFormat:@"800m"];
    //    NSExpression *exp1 = [NSExpression expressionWithFormat:person.event.name];
    //    NSLog(@"The exp1 is:%@",exp1);
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%@ == %@",exp,exp1];
    //    [times filteredArrayUsingPredicate:pred];
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    times = [times sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort1]];
    for(int i =0; i<[times count];i++)
    {
        EventTime *et = [times objectAtIndex:i];
        NSLog(@"Times After:%@",et.time);
    }
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.tableView.frame.size.height,self.view.frame.size.width/2,40)];
    lab.backgroundColor = [UIColor redColor];
    if(times != nil && [times count] >= 1)
    {
        NSString *str = [[times objectAtIndex:0] timeString];
        lab.text = str;
        [self.view addSubview:lab];
        NSLog(@"%@",[times objectAtIndex:0]);
    }
}
-(void)getBestOfThree
{
    NSArray *times = [person.eventTimes allObjects];
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    times = [times sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort1]];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.tableView.frame.size.height+40,self.view.frame.size.width/2,40)];
    lab.backgroundColor = [UIColor redColor];
    if(times != nil && [times count] >= 3)
    {
        EventTime *et1 = [times objectAtIndex:0];
        NSNumber *best1 = et1.time;
        int b1 = [best1 intValue];
        NSLog(@"b1:%i",b1);
        EventTime *et2 = [times objectAtIndex:1];
        NSNumber *best2 = et2.time;
        int b2 = [best2 intValue];
        NSLog(@"b2:%i",b2);
        EventTime *et3 = [times objectAtIndex:2];
        NSNumber *best3 = et3.time;
        int b3 = [best3 intValue];
        NSLog(@"b3:%i",b3);
        int avg = (b1 + b2 + b3)/3;
        int avgMin = avg/60;
        int avgSec = avg%60;
        if(avgSec >= 10)
        {
            NSString *avgString = [NSString stringWithFormat:@"%i"@":"@"%i",avgMin,avgSec];
            lab.text = avgString;
        }
        else
        {
            NSString *avgString = [NSString stringWithFormat:@"%i"@":0"@"%i",avgMin,avgSec];
            lab.text = avgString;
        }
        
        [self.view addSubview:lab];
    }
}
-(void)getAverage
{
    NSArray *times = [person.eventTimes allObjects];
    //    NSExpression *exp = [NSExpression expressionWithFormat:@"800m"];
    //    NSExpression *exp1 = [NSExpression expressionWithFormat:person.event.name];
    //    NSLog(@"The exp1 is:%@",exp1);
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%@ == %@",exp,exp1];
    //    [times filteredArrayUsingPredicate:pred];
    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    times = [times sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort1]];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.tableView.frame.size.height+80,self.view.frame.size.width/2,40)];
    lab.backgroundColor = [UIColor redColor];
    if(times != nil && [times count] >= 1)
    {
        int sum = 0;
        for(int i =0 ; i<[times count]; i++)
        {
            EventTime *et = [times objectAtIndex:i];
            NSLog(@"The Time is:%i",[et.time intValue]);
            sum = sum + [et.time intValue];
            NSLog(@"The sum is:%i",sum);
        }
        int count = [times count];
        NSLog(@"The count is:%i",[times count]);
        int avg = sum/count;
        NSLog(@"The average is:%i",avg);
        int avgMin = avg/60;
        int avgSec = avg%60;
        if(avgSec > 10)
        {
            NSString *avgString = [NSString stringWithFormat:@"%i"@":"@"%i",avgMin,avgSec];
            lab.text = avgString;
        }
        else
        {
            NSString *avgString = [NSString stringWithFormat:@"%i"@":0"@"%i",avgMin,avgSec];
            lab.text = avgString;
        }
        
        [self.view addSubview:lab];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
