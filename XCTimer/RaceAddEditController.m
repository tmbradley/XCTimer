//
//  RaceAddEditController.m
//  XCTimer
//
//  Created by MBradley on 1/2/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "RaceAddEditController.h"
#import "RaceController.h"
#import "Event+Methods.h"
#import "Race+Methods.h"
#import "CKCalendarView.h"

@interface RaceAddEditController ()

@end

@implementation RaceAddEditController
{
    UITextField *raceName;
    UITextField *dateTF;
    UILabel *dateLabel;
    UILabel *dateDisplay;
    UIButton *checkBox;
    BOOL checkBoxSelected;
    UITableView *eventTable;
    NSMutableArray *events;
    NSArray *eventNames;
    NSMutableArray *selectedEvents;
    Event *selectedEvent;
    Race *race;
    BOOL *isEditing;
    CKCalendarView *calendar;
    NSDateFormatter *dateFormatter;
    UIButton *dateButton;
    UIButton *dateOpenButton;
    UILabel *exitLabel;
    NSDate *chosenDate;
    int navBar;
}

@synthesize tableView;

-(id)initWithContext:(NSManagedObjectContext *)context
{
    if (self = [super init])
    {
        self.managedObjectContext = context;
        isEditing = NO;
        race = [NSEntityDescription insertNewObjectForEntityForName:@"Race" inManagedObjectContext: self.managedObjectContext];
    }
    return self;
}

-(id)initWithRace:(Race*)r
{
    if (self = [super init])
    {
        race = r;
        isEditing = YES;
    }
    return self;
}

//-(void)createNewRace
//{
////    race = [[Race all
//    race = [NSEntityDescription insertNewObjectForEntityForName:@"Race"
//        inManagedObjectContext:self.managedObjectContext];
//}


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
-(void)loadView
{
    [super loadView];
    
    navBar = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(self.view.frame.origin.x,navBar, self.view.frame.size.width, self.view.frame.size.height);
    [dateButton addTarget:self action:@selector(toggleCalendar) forControlEvents:UIControlEventTouchUpInside];
    [dateButton setBackgroundColor:[UIColor whiteColor]];
    raceName = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+5,navBar, (self.view.frame.size.width-10), 20)];
    raceName.backgroundColor = [UIColor clearColor];
    raceName.textColor = [UIColor whiteColor];
    raceName.placeholder =@"Enter Race Name";
    UIColor *color = [UIColor whiteColor];
    raceName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Race Name" attributes:@{NSForegroundColorAttributeName: color}];
    raceName.textAlignment = NSTextAlignmentLeft;
    raceName.delegate = self;
    calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
    calendar.delegate = self;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    if(race.date == nil)
    {
        calendar.selectedDate = [NSDate date];
    }
    else
    {
        calendar.selectedDate = race.date;
    }
    NSDate *now = [NSDate date];
    NSDate *oneYearLater = [now dateByAddingTimeInterval:(60*60*24*365)];
    calendar.minimumDate = [dateFormatter dateFromString:@"01/01/2010"];
    calendar.maximumDate = oneYearLater;
    calendar.shouldFillCalendar = YES;
    calendar.adaptHeightToNumberOfWeeksInMonth = NO;
    
    calendar.frame = CGRectMake(10, 10+navBar, 300, 320);
    [dateButton addSubview:calendar];
    
    dateDisplay = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    dateDisplay.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:calendar.selectedDate]];
    [dateButton addSubview:dateDisplay];
    exitLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4 + dateDisplay.frame.size.height, self.view.bounds.size.width, 24)];
    exitLabel.text = @"Confirm Date";
    [dateButton addSubview:exitLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    dateTF = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+5,self.view.frame.origin.y+raceName.frame.size.height+1+navBar, (self.view.frame.size.width-10)/2, 20)];
    dateOpenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateOpenButton.frame = CGRectMake(self.view.frame.origin.x+5+dateTF.frame.size.width+1,self.view.frame.origin.y+raceName.frame.size.height+1+navBar, 20, 20);
    [dateOpenButton addTarget:self action:@selector(toggleCalendar) forControlEvents:UIControlEventTouchUpInside];
//    [dateOpenButton setBackgroundImage:[UIImage imageNamed:@"calendar.png" ] forState:UIControlStateNormal];
    dateOpenButton.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [dateOpenButton setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-calendar"] forState:UIControlStateNormal];
//    [dateOpenButton setTitle:@"Select Date" forState:UIControlStateNormal];
//    [dateOpenButton setBackgroundImage:[UIImage imageNamed:@"background.png"] forState:UIControlStateNormal];
    [dateOpenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:dateOpenButton];
//    dateTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    dateTF.backgroundColor = [UIColor clearColor];
//    dateTF.textColor = [UIColor whiteColor];
//    dateTF.placeholder=@"Enter Date of Race";
//    dateTF.textAlignment = NSTextAlignmentLeft;
//    dateTF.delegate = self;
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x+5,self.view.frame.origin.y+raceName.frame.size.height+1+navBar, ((self.view.frame.size.width-10)/2)-1, 20)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    if(race.date == NULL)
    {
        dateLabel.text = [NSString stringWithFormat:@"%@",@"No Date Selected"];
    }
    else
    {
        dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:race.date]];
    }
//
    raceName.text = race.name;
//    date.text = race.date;
//    NSLog(@"%@",race.name);
    [self.view addSubview:raceName];
//    [self.view addSubview:date];
    [self.view addSubview:dateLabel];
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.rightBarButtonItem = done;
    UILabel *eventsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+5,dateTF.frame.origin.y+dateTF.frame.size.height, self.view.frame.size.width-10, 40)];
    eventsLabel.text = @"Choose Event(s)";
    eventsLabel.textColor = [UIColor whiteColor];
    eventsLabel.backgroundColor = [UIColor clearColor];
    eventsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:eventsLabel];
//    checkBox = [[UIButton alloc] initWithFrame:CGRectMake(0,0,25,25)];
//                // 20x20 is the size of the checckbox that you want
//                // create 2 images sizes 20x20 , one empty square and
//                // another of the same square with the checkmark in it
//                // Create 2 UIImages with these new images, then:
//                
//    [checkBox setBackgroundImage:[UIImage imageNamed:@"notselectedcheckbox.png"]forState:UIControlStateNormal];
//    [checkBox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox.png"]forState:UIControlStateSelected];
//    [checkBox setBackgroundImage:[UIImage imageNamed:@"selectedcheckbox.png"]forState:UIControlStateHighlighted];
//    checkBox.adjustsImageWhenHighlighted=YES;
//    [checkBox addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:checkBox];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x+5,eventsLabel.frame.origin.y+eventsLabel.frame.size.height, self.view.frame.size.width-10,self.view.frame.size.height-(self.view.frame.origin.y+eventsLabel.frame.size.height+self.view.frame.origin.y+eventsLabel.frame.size.height))style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
//    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
//    events = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    eventNames = [NSArray arrayWithObjects:@"100m",@"100m Hurdle",@"110m Hurdle",@"200m",@"400m",@"400m Relay",@"400m Hurdle",@"800m",@"1600m",@"1600m Relay",@"3200m",@"3200m Relay",@"5k",@"8k",@"10k",@"Generic A",@"Generic B",@"Generic C",@"Generic D",nil];
    events = [[NSMutableArray alloc]init];
    for(int i = 0; i<[eventNames count]; i++)
    {
        Event *event = (Event*)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
        event.name = [eventNames objectAtIndex:i];
        [events addObject:event];
        //[race addEventsObject:[events objectAtIndex:i]];
        if(![self.managedObjectContext save:NULL])
        {
            NSLog(@"ERROR");
        }
    }
    NSLog(@"%i",[events count]);
    selectedEvents = [[NSMutableArray alloc]init];
    [self.view addSubview:dateButton];
    dateButton.hidden = YES;
    
}
-(void)toggleCalendar
{
    if(dateButton.isHidden)
    {
        dateButton.hidden = NO;
        [self.navigationController setNavigationBarHidden:YES];
    }
    else
    {
        dateButton.hidden = YES;
        [self.navigationController setNavigationBarHidden:NO];
//        chosenDate = calendar.selectedDate;
    }
}
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    dateDisplay.text = [dateFormatter stringFromDate:date];
    dateLabel.text = [dateFormatter stringFromDate:date];
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
    cell.textLabel.text = [[events objectAtIndex:indexPath.row] name];
    if([[race.events allObjects] containsObject:[events objectAtIndex:indexPath.row]])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",[race.events allObjects]);
    NSLog(@"%@",[events objectAtIndex:indexPath.row]);
    if([[race.events allObjects] containsObject:[events objectAtIndex:indexPath.row]])
    {
        NSLog(@"Here");
        [race removeEventsObject:[events objectAtIndex:indexPath.row]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else
    {
        NSLog(@"Here2");
//        selectedEvent = [events objectAtIndex:indexPath.row];
        [race addEventsObject:[events objectAtIndex:indexPath.row]];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//        selectedEvent.race = race;
    }    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)donePressed:(id)sender
{
    if (activeField)
        [activeField resignFirstResponder];
    activeField = nil;
    NSLog(@"HERE");
    Race *r;
    if(race)
        r = race;
    else
        r = [NSEntityDescription insertNewObjectForEntityForName:@"Race" inManagedObjectContext:self.managedObjectContext];
    if(!isEditing && [self checkForDuplicate])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You have created a duplicate" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alert show];
        NSLog(@"Duplicate!!!!");
    }
    else if(![self checkValid])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Invalid Entry" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alert show];
        NSLog(@"Invalid!!!!");
    }
    else
    {
        r.name = raceName.text;
        r.date = calendar.selectedDate;
//      if(dateTF.text ==NULL)
//      {
//          race.date = @"No Date Entered";
//      }
//      NSLog(@"events: %@", selectedEvents);
//      for(int i=0;i < selectedEvents.count;i++)
//      {
//          event.name =[selectedEvents objectAtIndex:i];
//          NSLog(@"%@",event.name);
//      }
        NSError *error;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"EVENT SAVE ERROR: %@", error);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(BOOL)checkForDuplicate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Race"];
    //    NSEntityDescription *entity = [NSEntityDescription
    //                                   entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    //    [fetchRequest setEntity:entity];
    NSArray *races = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    //    NSMutableArray *people = [NSMutableArray arrayWithObjects:fetchRequest, nil];
    NSLog(@"It is:%i",[races count]);
    for(int i =0; i < [races count];i++)
    {
        NSLog(@"AAAA");
        Race *r = [races objectAtIndex:i];
        if([r.name isEqualToString: raceName.text])
        {
            NSLog(@"BBBB");
            if(r.date == chosenDate)
            {
                NSLog(@"CCCC");
                return YES;
            }
        }
    }
    NSLog(@"FFFFF");
    return NO;
}
-(BOOL)checkValid
{
    if([raceName.text length] == 0)
    {
        return NO;
    }
    return YES;
}
-(void)checkboxSelected:(id)sender
{
    checkBoxSelected = !checkBoxSelected;
    [checkBox setSelected:checkBoxSelected];
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
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    NSLog(@"%@",textField.text);
    if (activeField)
        [activeField resignFirstResponder];
    activeField = nil;
}
@end
