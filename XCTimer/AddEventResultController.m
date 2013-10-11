//
//  AddEventResultController.m
//  XCTimer
//
//  Created by MBradley on 1/26/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "AddEventResultController.h"
#import "Person+Methods.h"
#import "ProfileController.h"
#import "EventTime.h"
#import "EventResultsController.h"

@interface AddEventResultController ()

@end

@implementation AddEventResultController
{
    Event *event;
    UILabel *directions;
    UITextField *timeDirections;
    UILabel *timeDirectionsLabel;
    UITextField *minutesTF;
    UILabel *minutesLabel;
    UITextField *secondsTF;
    UILabel *secondsLabel;
    UILabel *placeLabel;
    UITextField *placeTF;
    Person *selectedPerson;
    EventTime *eventTime;
    double timeInSeconds;
    NSNumber *time;
    UIToolbar *toolbar;
    UIToolbar *toolbar1;
    UIToolbar *toolbar2;
}
@synthesize tableView = _tableView;
@synthesize fetchedResultsController = __fetchedResultsController;

-(id)initWithEvent:(Event *)e EventTime:(EventTime*)et
{
    if(self = [super init])
    {
        event = e;
        eventTime = et;
    }
    return self;
}
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
    directions = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height*.1)];
    directions.text = @"Select Runner";
    directions.backgroundColor = [UIColor clearColor];
    directions.textColor = [UIColor whiteColor];
    [self.view addSubview:directions];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,directions.frame.origin.y+directions.frame.size.height, self.view.frame.size.width,( self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)/2) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    timeDirectionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.tableView.frame.origin.y+self.tableView.frame.size.height,self.view.frame.size.width/2,self.view.frame.size.height*.1)];
    timeDirectionsLabel.text = @"Enter Time";
    timeDirectionsLabel.backgroundColor = [UIColor clearColor];
    timeDirectionsLabel.textColor = [UIColor whiteColor];
    timeDirectionsLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:timeDirectionsLabel];
    minutesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height,(self.view.frame.size.width/4)-10,self.view.frame.size.height*.1)];
    minutesLabel.text = @"Minutes: ";
    minutesLabel.backgroundColor = [UIColor clearColor];
    minutesLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:minutesLabel];
    minutesTF = [[UITextField alloc]initWithFrame:CGRectMake(0+minutesLabel.frame.size.width,self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height,self.view.frame.size.width/4,self.view.frame.size.height*.1)];
    minutesTF.backgroundColor = [UIColor clearColor];
    minutesTF.textColor = [UIColor whiteColor];
    minutesTF.keyboardType = UIKeyboardTypeNumberPad;
    minutesTF.placeholder = @"optional";
    minutesTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [[minutesTF layer] setCornerRadius:5.0f];
    minutesTF.layer.borderColor = [UIColor whiteColor].CGColor;
    minutesTF.layer.borderWidth = .5;
    minutesTF.textAlignment = NSTextAlignmentCenter;
    minutesTF.delegate = self;
    minutesTF.tag = 1;
    [self.view addSubview:minutesTF];
    toolbar = [[UIToolbar alloc]init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [minutesTF setInputAccessoryView:toolbar];
    secondsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0+minutesTF.frame.origin.x+minutesTF.frame.size.width,self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height,(self.view.frame.size.width/4),self.view.frame.size.height*.1)];
    secondsLabel.text = @"Seconds: ";
    secondsLabel.backgroundColor = [UIColor clearColor];
    secondsLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:secondsLabel];
    secondsTF = [[UITextField alloc]initWithFrame:CGRectMake(0+secondsLabel.frame.origin.x+secondsLabel.frame.size.width,self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height,self.view.frame.size.width/4,self.view.frame.size.height*.1)];
    secondsTF.backgroundColor = [UIColor clearColor];
    secondsTF.textColor = [UIColor whiteColor];
    secondsTF.keyboardType = UIKeyboardTypeNumberPad;
    secondsTF.placeholder = @"required";
    secondsTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [[secondsTF layer] setCornerRadius:5.0f];
    secondsTF.layer.borderColor = [UIColor whiteColor].CGColor;
    secondsTF.layer.borderWidth = .5;
    secondsTF.textAlignment = NSTextAlignmentCenter;
    secondsTF.delegate = self;
    secondsTF.tag = 2;
    [self.view addSubview:secondsTF];
    toolbar1 = [[UIToolbar alloc]init];
    [toolbar1 setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar1 sizeToFit];
    UIBarButtonItem *flexButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton1 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard1)];
    NSArray *itemsArray1 = [NSArray arrayWithObjects:flexButton1, doneButton1, nil];
    [toolbar1 setItems:itemsArray1];
    [secondsTF setInputAccessoryView:toolbar1];
//    timeDirections.backgroundColor = [UIColor clearColor];
//    timeDirections.textColor = [UIColor whiteColor];
//    timeDirections = [[UITextField alloc] initWithFrame:CGRectMake(0,self.tableView.frame.origin.y+self.tableView.frame.size.height,self.view.frame.size.width/2,self.view.frame.size.height*.1)];
//    timeDirections.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    timeDirections.backgroundColor = [UIColor clearColor];
//    timeDirections.textColor = [UIColor whiteColor];
//    timeDirections.placeholder=@"Enter Time";
//    timeDirections.textAlignment = NSTextAlignmentLeft;
//    timeDirections.delegate = self;
//    [self.view addSubview:timeDirections];
    
    placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(minutesLabel.frame.origin.x,self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height+minutesTF.frame.size.height+2,(self.view.frame.size.width/4)-10,self.view.frame.size.height*.1)];
    placeLabel.text = @"Place:";
    placeLabel.backgroundColor = [UIColor clearColor];
    placeLabel.textColor = [UIColor whiteColor];
    placeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:placeLabel];
    placeTF = [[UITextField alloc]initWithFrame:CGRectMake(placeLabel.frame.origin.x+placeLabel.frame.size.width,self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height+minutesLabel.frame.size.height+2,self.view.frame.size.width/4,self.view.frame.size.height*.1)];
    placeTF.backgroundColor = [UIColor clearColor];
    placeTF.textColor = [UIColor whiteColor];
    placeTF.keyboardType = UIKeyboardTypeNumberPad;
    placeTF.placeholder = @"optional";
    placeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [[placeTF layer] setCornerRadius:5.0f];
    placeTF.layer.borderColor = [UIColor whiteColor].CGColor;
    placeTF.layer.borderWidth = .5;
    placeTF.textAlignment = NSTextAlignmentCenter;
    placeTF.delegate = self;
    placeTF.tag = 1;
    [self.view addSubview:placeTF];
    toolbar2 = [[UIToolbar alloc]init];
    [toolbar2 setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar2 sizeToFit];
    UIBarButtonItem *flexButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton2 =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard2)];
    NSArray *itemsArray2 = [NSArray arrayWithObjects:flexButton2, doneButton2, nil];
    [toolbar2 setItems:itemsArray2];
    [placeTF setInputAccessoryView:toolbar2];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem = done;
}
-(void)resignKeyboard
{
    [minutesTF resignFirstResponder];
}
-(void)resignKeyboard1
{
    [secondsTF resignFirstResponder];
}
-(void)resignKeyboard2
{
    [placeTF resignFirstResponder];
}
-(void)donePressed:(id)sender
{
    if (activeField)
        [activeField resignFirstResponder];
    activeField = nil;
    NSLog(@"HERE");
    NSNumber *minSec = ([NSNumber numberWithDouble:[minutesTF.text doubleValue]*60]);
    NSNumber *sec = ([NSNumber numberWithDouble:[secondsTF.text doubleValue]]);
    timeInSeconds =[minSec intValue] + [sec intValue];
    NSLog(@"Number of seconds:%f",timeInSeconds);
    time = [NSNumber numberWithDouble:timeInSeconds];
    int min = [minutesTF.text intValue];
    int seconds = [secondsTF.text intValue];
    NSString *minTimeString = [NSString stringWithFormat:@"%i:",min];
    NSString *secString = [[NSString alloc]init];
    if(seconds < 10)
    {
        secString = [NSString stringWithFormat:@"0%i",seconds];
        NSLog(@"%@",[NSString stringWithFormat:@"0%i",seconds]);
    }
    else
    {
        secString = [NSString stringWithFormat:@"%i",seconds];
    }
    NSLog(@"Number of Seconds:%i",seconds);
    NSString *timeString = [minTimeString stringByAppendingString:secString];
//    seconds = ([NSNumber numberWithDouble:[[minutesTF.text floatValue]*60)+([NSNumber numberWithDouble:[secondsTF.text floatValue]]);
    eventTime = (EventTime*)[NSEntityDescription insertNewObjectForEntityForName:@"EventTime" inManagedObjectContext:self.managedObjectContext];
//    selectedPerson.time = timeDirections.text;
//    selectedPerson.eventTimes = eventTime;
    eventTime.timeString = timeString;
    eventTime.time = time;
    double place1 = [placeTF.text doubleValue];
    NSNumber *placeNum = [NSNumber numberWithDouble:place1];
    eventTime.place = placeNum;
    eventTime.person = selectedPerson;
    eventTime.event = event;
    [selectedPerson addEventTimesObject:eventTime];
    [event addEventTimesObject:eventTime];
//    selectedPerson.eventTimes = eventTime;
    NSLog(@"The time typedd in is:%@",timeDirections.text);
    NSLog(@"The persons time is:%@",eventTime.timeString);
    NSLog(@"The Event Time is:%@",eventTime.time);
    NSLog(@"Selected Persons eventTimes:@%i",[selectedPerson.eventTimes count]);
    NSLog(@"The place finished was:@%@",eventTime.place);
    //[selectedPerson addEventTimesObject:eventTime];
    //selectedPerson.time = timeDirections.text;
    //    NSLog(@"events: %@", selectedEvents);
    //    for(int i=0;i < selectedEvents.count;i++)
    //    {
    //        event.name =[selectedEvents objectAtIndex:i];
    //        NSLog(@"%@",event.name);
    //    }
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"EVENT SAVE ERROR: %@", error);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Add %@ time",event.name];
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
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
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
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Person *p = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text= [NSString stringWithFormat:@"%@",[p name]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.navigationController popViewControllerAnimated:YES];
    selectedPerson = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"Selected Persons name:%@",selectedPerson.name);
    [event addPeopleObject: selectedPerson];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"HERE");
    [textField resignFirstResponder];
    activeField = nil;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"BABADDABADAB");
    activeField = textField;
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = self.tableView.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = 100;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         self.tableView.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame1 = directions.frame;
                         if (frame1.origin.y==0)
                             frame1.origin.y = -100;
                         else
                             frame1.origin.y = 0;
                         directions.frame = frame1;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame2 = timeDirectionsLabel.frame;
                             frame2.origin.y = 0;
                         timeDirectionsLabel.frame = frame2;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = minutesTF.frame;
                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
                         minutesTF.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = minutesLabel.frame;
                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
                         minutesLabel.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = secondsTF.frame;
                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
                         secondsTF.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = secondsLabel.frame;
                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
                         secondsLabel.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = placeLabel.frame;
                         frame3.origin.y = minutesLabel.frame.origin.y+minutesLabel.frame.size.height;
                         placeLabel.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = placeTF.frame;
                         frame3.origin.y = minutesLabel.frame.origin.y+minutesLabel.frame.size.height;
                         placeTF.frame = frame3;
                     }
                     completion:nil];
    
    
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame = self.tableView.frame;
//                         if (frame.origin.y==0)
//                             frame.origin.y = 100;
//                         else
//                             frame.origin.y = -frame.origin.y+-frame.size.height;
//                         self.tableView.frame = frame;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame1 = directions.frame;
//                         if (frame1.origin.y==0)
//                             frame1.origin.y = -100;
//                         else
//                             frame1.origin.y = 0;
//                         directions.frame = frame1;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame2 = timeDirectionsLabel.frame;
//                         if (frame2.origin.y==0)
//                             frame2.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height;
//                         else
//                             frame2.origin.y = 0;
//                         timeDirectionsLabel.frame = frame2;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame3 = minutesTF.frame;
//                         if (frame3.origin.y==timeDirectionsLabel.frame.size.height)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
//                         else
//                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
//                         minutesTF.frame = frame3;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame3 = minutesLabel.frame;
//                         if (frame3.origin.y==timeDirectionsLabel.frame.size.height)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
//                         else
//                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
//                         minutesLabel.frame = frame3;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame3 = secondsTF.frame;
//                         if (frame3.origin.y==timeDirectionsLabel.frame.size.height)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
//                         else
//                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
//                         secondsTF.frame = frame3;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame3 = secondsLabel.frame;
//                         if (frame3.origin.y==timeDirectionsLabel.frame.size.height)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
//                         else
//                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
//                         secondsLabel.frame = frame3;
//                     }
//                     completion:nil];
    
    
    
    
    
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame = self.tableView.frame;
//                         CGRect frame1 = directions.frame;
//                         CGRect frame2 = timeDirectionsLabel.frame;
//                         CGRect frame3 = timeDirections.frame;
//                         if (frame.origin.y==0)
//                            frame.origin.y = 100;
//                         else
//                            frame.origin.y = -frame.origin.y+-frame.size.height;
//                         
//                         if (frame1.origin.y==0)
//                             frame1.origin.y = -100;
//                         else
//                             frame1.origin.y = 0;
//                         
//                         if (frame2.origin.y==0)
//                             frame2.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height;
//                         else
//                             frame2.origin.y = 0;
//                             
//                         if (frame3.origin.y==0)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height;
//                         else
//                             frame3.origin.y = 0;
//                         
//                         self.tableView.frame = frame;
//                         directions.frame = frame1;
//                         timeDirectionsLabel.frame = frame2;
//                         timeDirections.frame = frame3;
//                     }
//                     completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    NSLog(@"%@",textField.text);
    
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = self.tableView.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = 100;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         self.tableView.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame1 = directions.frame;
                         if (frame1.origin.y==0)
                             frame1.origin.y = -100;
                         else
                             frame1.origin.y = 0;
                         directions.frame = frame1;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame2 = timeDirectionsLabel.frame;
                         frame2.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height;
                         timeDirectionsLabel.frame = frame2;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = minutesTF.frame;
                         frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
                         minutesTF.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = minutesLabel.frame;
                         frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
                         minutesLabel.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = secondsTF.frame;
                         frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
                         secondsTF.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = secondsLabel.frame;
                         frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
                         secondsLabel.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = placeLabel.frame;
                         frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height+minutesTF.frame.size.height+2;
                         placeLabel.frame = frame3;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame3 = placeTF.frame;
                         frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height+minutesTF.frame.size.height+2;
                         placeTF.frame = frame3;
                     }
                     completion:nil];
    
    
    
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame = self.tableView.frame;
//                         if (frame.origin.y==0)
//                             frame.origin.y =directions.frame.origin.y+directions.frame.size.height ;
//                         else
//                             frame.origin.y = -frame.origin.y+-frame.size.height;
//                         self.tableView.frame = frame;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame1 = directions.frame;
//                         if (frame1.origin.y==0)
//                             frame1.origin.y = -100;
//                         else
//                             frame1.origin.y = 0;
//                         directions.frame = frame1;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame2 = timeDirectionsLabel.frame;
//                         if (frame2.origin.y==0)
//                             frame2.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height;
//                         else
//                             frame2.origin.y = 0;
//                         timeDirectionsLabel.frame = frame2;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame3 = minutesTF.frame;
//                         if (frame3.origin.y==0+timeDirectionsLabel.frame.size.height)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
//                         else
//                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
//                         minutesTF.frame = frame3;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame3 = minutesLabel.frame;
//                         if (frame3.origin.y==0+timeDirectionsLabel.frame.size.height)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
//                         else
//                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
//                         minutesLabel.frame = frame3;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame3 = secondsTF.frame;
//                         if (frame3.origin.y==0+timeDirectionsLabel.frame.size.height)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
//                         else
//                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
//                         secondsTF.frame = frame3;
//                     }
//                     completion:nil];
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame3 = secondsLabel.frame;
//                         if (frame3.origin.y==0+timeDirectionsLabel.frame.size.height)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height+timeDirectionsLabel.frame.size.height;
//                         else
//                             frame3.origin.y = 0+timeDirectionsLabel.frame.size.height;
//                         secondsLabel.frame = frame3;
//                     }
//                     completion:nil];
    
    
    
    
    
    
    
//    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         CGRect frame = self.tableView.frame;
//                         CGRect frame1 = directions.frame;
//                         CGRect frame2 = timeDirectionsLabel.frame;
//                         CGRect frame3 = timeDirections.frame;
//                         if (frame.origin.y==0)
//                             frame.origin.y = 100;
//                         else
//                             frame.origin.y = -frame.origin.y+-frame.size.height;
//                         
//                         if (frame1.origin.y==0)
//                             frame1.origin.y = -100;
//                         else
//                             frame1.origin.y = 0;
//                         
//                         if (frame2.origin.y==0)
//                             frame2.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height;
//                         else
//                             frame2.origin.y = 0;
//                         
//                         if (frame3.origin.y==0)
//                             frame3.origin.y = self.tableView.frame.origin.y+self.tableView.frame.size.height;
//                         else
//                             frame3.origin.y = 0;
//                         
//                         self.tableView.frame = frame;
//                         directions.frame = frame1;
//                         timeDirectionsLabel.frame = frame2;
//                         timeDirections.frame = frame3;
//                     }
//                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
