//
//  Settings.m
//  XCTimer
//
//  Created by Michael Bradley on 4/16/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "Settings.h"
#import "CKCalendarView.h"
#import "Person+Methods.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"

@interface Settings ()

@end

@implementation Settings
{
    UIButton *calendarButtonStart;
    UIButton *calendarButtonStop;
    UIButton *dateButton;
    UILabel *startDateText;
    UILabel *stopDateText;
    UILabel *startText;
    UILabel *stopText;
    CKCalendarView  *calendar;
    NSDateFormatter *dateFormatter;
    UILabel *exitLabel;
    UILabel *dateDisplay;
    UILabel *label;
    UILabel *dateTitle;
    UILabel *gradeTitle;
    NSUserDefaults *defaults;
    UIButton *promoteButton;
    UIButton *demoteButton;
    UIButton *defaultGradeButton;
    NSString *gradeLevelText;
    UIActivityIndicatorView *wheel;
    int xPos,yPos,labelWidth,labelHeight,gap,currentSchoolYear;
    BOOL firstTime;
    int navBar;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
-(void)viewDidDisappear:(BOOL)animated
{
    NSDate *startDate = [dateFormatter dateFromString:startDateText.text];
    [defaults setObject:startDate forKey:@"startDate"];
    [defaults setObject:startDateText.text forKey:@"startDateText"];
//    NSNumber *currentYear = [NSNumber numberWithInt:currentSchoolYear];
//    [defaults setObject:currentYear forKey:@"currentYear"];
    NSLog(@"%@",[defaults objectForKey:@"startDateText"]);
    NSDate *stopDate = [dateFormatter dateFromString:stopDateText.text];
    [defaults setObject:stopDate forKey:@"stopDate"];
    [defaults setObject:stopDateText.text forKey:@"stopDateText"];
    NSLog(@"%@",defaultGradeButton.titleLabel.text);
    [defaults setObject:defaultGradeButton.titleLabel.text forKey:@"defaultGrade"];
    [defaults synchronize];
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
    defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults objectForKey:@"startDateText"]);
    startDateText.text = [defaults objectForKey:@"startDateText"];
    NSLog(@"%@",startDateText.text);
    stopDateText.text = [defaults objectForKey:@"stopDateText"];
//    [defaultGradeButton setTitle:[defaults objectForKey:@"defaultGrade"] forState:UIControlStateNormal];
//    gradeLevelText = [NSString stringWithFormat:@"Current School Year: %@",[defaults objectForKey:@"currentYear"]];
//    currentSchoolYearLabel.text = gradeLevelText;
//    currentSchoolYear = [defaults objectForKey:@"currentYear"];
//    NSLog(@"Current Year:%i",currentSchoolYear);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    navBar = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
	// Do any additional setup after loading the view.
    [self.view addSubview:wheel];
    defaults = [NSUserDefaults standardUserDefaults];
    self.title = @"Settings";
    [self createCalendarSetting];
//    [self createGradeSetting];
}
-(void)createCalendarSetting
{
    xPos = self.view.frame.size.width*.3;
    yPos = self.view.frame.size.height*.1+navBar;
    labelWidth = self.view.frame.size.width*.5;
    labelHeight = self.view.frame.size.height*.05;
    gap = 2;
    
    dateTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,0+navBar,labelWidth*.6, 2*labelHeight)];
    dateTitle.text = @"Date";
    dateTitle.backgroundColor = [UIColor blackColor];
    dateTitle.textColor = [UIColor whiteColor];
    dateTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    [self.view addSubview:dateTitle];
    startText = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, labelWidth*.6, labelHeight)];
    startText.backgroundColor = [UIColor clearColor];
    startText.text = @"Start Date:";
    startText.textColor = [UIColor whiteColor];
    [self.view addSubview:startText];
    
    stopText = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos + labelHeight + gap, labelWidth*.6, labelHeight)];
    stopText.backgroundColor = [UIColor clearColor];
    stopText.text = @"Stop Date:";
    stopText.textColor = [UIColor whiteColor];
    [self.view addSubview:stopText];
    startDateText = [[UILabel alloc]initWithFrame:CGRectMake(xPos + gap, yPos, labelWidth, labelHeight)];
    startDateText.backgroundColor = [UIColor clearColor];
    startDateText.textColor = [UIColor whiteColor];
    [self.view addSubview:startDateText];
    stopDateText = [[UILabel alloc]initWithFrame:CGRectMake(xPos + gap, yPos+labelHeight+gap, labelWidth, labelHeight)];
    stopDateText.backgroundColor = [UIColor clearColor];
    stopDateText.textColor = [UIColor whiteColor];
    [self.view addSubview:stopDateText];
    
//    FAImageView *imageView = [[FAImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [imageView setBackgroundColor:[UIColor blackColor]];
//    imageView.image = nil;
//    [imageView setDefaultIconIdentifier:@"icon-ok"];
    
    calendarButtonStart = [UIButton buttonWithType:UIButtonTypeCustom];
    calendarButtonStart.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [calendarButtonStart setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-calendar"] forState:UIControlStateNormal];
//    [calendarButtonStart setBackgroundImage:imageView.image forState:UIControlStateNormal];
    calendarButtonStart.frame = CGRectMake(xPos + labelWidth + gap, yPos, labelHeight, labelHeight);
    calendarButtonStart.tag = 1;
    [calendarButtonStart addTarget:self action:@selector(toggleCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calendarButtonStart];
    
    calendarButtonStop = [UIButton buttonWithType:UIButtonTypeCustom];
    calendarButtonStop.titleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
    [calendarButtonStop setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-calendar"] forState:UIControlStateNormal];
//    [calendarButtonStop setBackgroundImage:[UIImage imageNamed:@"calendar.png" ] forState:UIControlStateNormal];
    calendarButtonStop.frame = CGRectMake(xPos + labelWidth + gap, yPos + labelHeight + gap, labelHeight, labelHeight);
    [calendarButtonStop addTarget:self action:@selector(toggleCalendar:) forControlEvents:UIControlEventTouchUpInside];
    calendarButtonStop.tag = 2;
    [self.view addSubview:calendarButtonStop];
    
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [dateButton addTarget:self action:@selector(toggleCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [dateButton setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:dateButton];
    dateButton.hidden = YES;
    
    calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
    calendar.delegate = self;
    if(calendar.selectedDate == nil)
    {
        calendar.selectedDate = [NSDate date];
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *now = [NSDate date];
    NSDate *oneYearLater = [now dateByAddingTimeInterval:(60*60*24*365)];
    calendar.minimumDate = [dateFormatter dateFromString:@"01/01/2010"];
    calendar.maximumDate = oneYearLater;
    calendar.shouldFillCalendar = YES;
    calendar.adaptHeightToNumberOfWeeksInMonth = NO;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [dateButton addSubview:calendar];
    
    dateDisplay = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    dateDisplay.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:calendar.selectedDate]];
    [dateButton addSubview:dateDisplay];
    exitLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4 + dateDisplay.frame.size.height, self.view.bounds.size.width, 24)];
    exitLabel.text = @"Confirm Date";
    [dateButton addSubview:exitLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}
-(void)createGradeSetting
{
    gradeTitle = [[UILabel alloc]initWithFrame:CGRectMake(0,yPos + labelHeight*2 + gap,labelWidth*.6, 2*labelHeight)];
    gradeTitle.text = @"Grade";
    gradeTitle.backgroundColor = [UIColor blackColor];
    gradeTitle.textColor = [UIColor whiteColor];
    gradeTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    [self.view addSubview:gradeTitle];
    defaultGradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultGradeButton.frame =CGRectMake(0,gradeTitle.frame.origin.y+gradeTitle.frame.size.height,labelWidth+20, labelHeight);
    if(firstTime)
    {
        [defaultGradeButton setTitle:@"Default Grade is: 7" forState:UIControlStateNormal];
        firstTime = NO;
        NSLog(@"Here");
    }
    else
    {
        NSLog(@"Here1");
        NSLog(@"%@",[defaults objectForKey:@"defaultGrade"]);
        [defaultGradeButton setTitle:[defaults objectForKey:@"defaultGrade"] forState:UIControlStateNormal];
    }
//    [defaultGradeButton setTitle:@"Default Grade is: 7" forState:UIControlStateNormal];
    [defaultGradeButton addTarget:self action:@selector(switchGrade) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:defaultGradeButton];
    promoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    promoteButton.backgroundColor = [UIColor clearColor];
    promoteButton.frame = CGRectMake(0,defaultGradeButton.frame.origin.y+defaultGradeButton.frame.size.height+(2*gap),labelWidth+20, labelHeight);
    [promoteButton setTitle:@"Promote All Athletes" forState:UIControlStateNormal];
    [[promoteButton layer] setCornerRadius:5.0f];
    promoteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    promoteButton.layer.borderWidth = .5;
    [promoteButton addTarget:self action:@selector(promoteAthletes) forControlEvents:UIControlEventTouchUpInside];
    [promoteButton setBackgroundImage:[UIImage imageNamed:@"darkBlue.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:promoteButton];
    demoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    demoteButton.backgroundColor = [UIColor clearColor];
    demoteButton.frame = CGRectMake(0,promoteButton.frame.origin.y+promoteButton.frame.size.height+2*gap,labelWidth+20, labelHeight);
    [demoteButton setTitle:@"Demote All Athletes" forState:UIControlStateNormal];
    [[demoteButton layer] setCornerRadius:5.0f];
    demoteButton.layer.borderColor = [UIColor whiteColor].CGColor;
    demoteButton.layer.borderWidth = .5;
    [demoteButton setBackgroundImage:[UIImage imageNamed:@"darkBlue.png"] forState:UIControlStateHighlighted];
    [demoteButton addTarget:self action:@selector(demoteAthletes) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:demoteButton];

}
-(void)switchGrade
{
    if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 7"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 8" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 8"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 9" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 9"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 10" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 10"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 11" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 11"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 12" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 12"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 13" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 13"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 14" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 14"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 15" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 15"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 16" forState:UIControlStateNormal];
    }
    else if([defaultGradeButton.titleLabel.text isEqualToString:@"Default Grade is: 16"])
    {
        [defaultGradeButton setTitle:@"Default Grade is: 7" forState:UIControlStateNormal];
    }
}
-(void)promoteAthletes
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *results    = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:nil];
    for(int i = 0; i< [results count]; i++)
    {
        Person *p = [results objectAtIndex:i];
        NSLog(@"Grade: %@",p.grade);
        NSLog(@"i=%i",i);
        int grade = [p.grade intValue];
        grade = grade +1;
        p.grade = [NSString stringWithFormat:@"%i",grade];
    }
    NSLog(@"%i",[results count]);
    currentSchoolYear ++;
//    currentSchoolYearLabel.text = [NSString stringWithFormat:@"Current School Year: %i",currentSchoolYear];
    NSLog(@"Promote: %i",currentSchoolYear);
//    wheel = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    wheel.frame = CGRectMake(promoteButton.frame.origin.x+promoteButton.frame.size.width+10,promoteButton.frame.origin.y, 25, 25);
//    [self.view addSubview:wheel];
////    wheel.hidesWhenStopped = YES;
//    [wheel startAnimating];
//    int count = 0;
//    while (count < 1000)
//    {
//        NSLog(@"%i",count);
//        count = count + 1;
//    }
////    [wheel stopAnimating];

}
-(void)demoteAthletes
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *results    = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:nil];
    for(int i = 0; i< [results count]; i++)
    {
        Person *p = [results objectAtIndex:i];
        NSLog(@"Grade: %@",p.grade);
        NSLog(@"i=%i",i);
        int grade = [p.grade intValue];
        grade = grade - 1;
        p.grade = [NSString stringWithFormat:@"%i",grade];
    }
    NSLog(@"%i",[results count]);
    currentSchoolYear --;
//    currentSchoolYearLabel.text = [NSString stringWithFormat:@"Current School Year: %i",currentSchoolYear];
    NSLog(@"Demote: %i",currentSchoolYear);
    
    
}
-(void)toggleCalendar:(UIButton *)button
{
    if(dateButton.isHidden)
    {
        dateButton.hidden = NO;
        [self.navigationController setNavigationBarHidden:YES];
        NSDate *chosenDate = calendar.selectedDate;
        if(button.tag == 1)
        {
            NSLog(@"ABAba");
            dateButton.tag=1;
           // startDate.text = [dateFormatter stringFromDate:chosenDate];
            NSLog(@"%@",chosenDate);
        }
        else if(button.tag == 2)
        {
            NSLog(@"CDDCDCDC");
            dateButton.tag=2;
            //stopDate.text = [dateFormatter stringFromDate:chosenDate];
        }
    }
    else
    {
        NSDate *chosenDate = calendar.selectedDate;
        if(button.tag == 1)
        {
            NSLog(@"ABAba");
            startDateText.text = [dateFormatter stringFromDate:chosenDate];
        }
        else if(button.tag == 2)
        {
            NSLog(@"CDDCDCDC");
            stopDateText.text = [dateFormatter stringFromDate:chosenDate];
        }
        dateButton.hidden = YES;
        [self.navigationController setNavigationBarHidden:NO];
    }

}
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    dateDisplay.text = [dateFormatter stringFromDate:date];
}
//-(void)chooseLabel:(UIButton *)button
//{
//    NSDate *chosenDate = calendar.selectedDate;
//    if(button.tag == 1)
//    {
//        startDate.text = [dateFormatter stringFromDate:chosenDate];
//    }
//    if(button.tag == 2)
//    {
//        stopDate.text = [dateFormatter stringFromDate:chosenDate];
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
