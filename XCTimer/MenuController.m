//
//  MenuController.m
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "MenuController.h"
#import "RosterController.h"
#import "ProfileController.h"
#import "ResultsController.h"
#import "NotesController.h"
#import "ExTimerViewController.h"
#import "Settings.h"
#import "BButton.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuController ()

@end

@implementation MenuController
{
    UIButton *rosterButton;
    UIButton *resultsButton;
    UIButton *timerButton;
    UIButton *notesButton;
    UIBarButtonItem *settingButton;
    BButton *rosterBButton;
    BButton *resultsBButton;
    BButton *notesBButton;
    UIView *logoView;
    UIImageView *logo;
    DBDatastore *store;
}
-(void)loadView
{
    [super loadView];
    
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *menuTitle = [defaults objectForKey:@"startDate"];
//    NSLog(@"%@",menuTitle);
//    self.title = menuTitle;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    [self linkAccount];
    
    
//    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"backgroundTrack.png"]];
//    backgroundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view addSubview:backgroundImageView];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    self.title = @"Menu";
    //self.view.backgroundColor = [UIColor underPageBackgroundColor];

    [self setupMenu1];
    
    
	// Do any additional setup after loading the view.
}
-(void)linkAccount
{
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    if (account)
    {
        NSLog(@"App already linked");
    }
    else
    {
        [[DBAccountManager sharedManager] linkFromController:self];
    }
    store = [DBDatastore openDefaultStoreForAccount:account error:nil];
    [store sync:nil];
    DBTable *tasksTable = [store getTable:@"tasks"];
    DBRecord *firstTask = [tasksTable insert:@{ @"taskname": @"Buy milk", @"completed": @NO }];
    [store sync:nil];
    
    firstTask[@"completed"] = @YES;
    [store sync:nil];
    
    NSArray *results = [tasksTable query:nil error:nil];
    NSLog(@"results count:%i",[results count]);
}
-(void)setupMenu
{
    UIImageView *resultsButtonBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seaFoam.png"]];
    resultsButtonBackground.alpha = .2;
    settingButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gearWhite16.png" ] style:UIBarButtonItemStyleBordered target:self action:@selector(openSettings)];
    //    [settingButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 2;
    self.navigationItem.rightBarButtonItem = settingButton;
    //    UIImageView *buttonBackground = [UIImageView viewWithImage [imageNamed:@"team.jpg"];
    //    buttonBackground.
    int height = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    rosterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rosterButton.frame =CGRectMake(0,0,(self.view.frame.size.width),height*.35);
    rosterButton.backgroundColor = [UIColor clearColor];
    [rosterButton setTitle:@"Roster" forState:UIControlStateNormal];
    [rosterButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    //    [rosterButton setBackgroundColor:[UIColor colorWithRed:229 green:229 blue:231 alpha:.2]];
    [rosterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rosterButton addTarget:self action:@selector(openRoster:) forControlEvents:UIControlEventTouchUpInside];
    [rosterButton setBackgroundImage:resultsButtonBackground.image forState:UIControlStateNormal];
    [self.view addSubview:rosterButton];
    
    resultsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    resultsButton.frame =CGRectMake(0,rosterButton.frame.size.height+1,(self.view.frame.size.width),(height*.35)-1);
    resultsButton.backgroundColor = [UIColor clearColor];
    [resultsButton setTitle:@"Results" forState:UIControlStateNormal];
    [resultsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resultsButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [resultsButton addTarget:self action:@selector(openResults:) forControlEvents:UIControlEventTouchUpInside];
    [resultsButton setBackgroundImage:[UIImage imageNamed:@"gray.png"] forState:UIControlStateNormal];
    [self.view addSubview:resultsButton];
    
    //    timerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    timerButton.frame =CGRectMake(0,resultsButton.frame.origin.y+resultsButton.frame.size.height+1,(self.view.frame.size.width),(self.view.frame.size.height/3)-1);
    //    timerButton.backgroundColor = [UIColor clearColor];
    //    [timerButton setTitle:@"Timer" forState:UIControlStateNormal];
    //    [timerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [timerButton addTarget:self action:@selector(openTimer:) forControlEvents:UIControlEventTouchUpInside];
    //    [timerButton setBackgroundImage:[UIImage imageNamed:@"blueBlur.jpeg"] forState:UIControlStateNormal];
    //    [self.view addSubview:timerButton];
    
    notesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    notesButton.frame =CGRectMake(0,resultsButton.frame.origin.y+resultsButton.frame.size.height+1,(self.view.frame.size.width),(height*.3)-1);
    notesButton.backgroundColor = [UIColor clearColor];
    [notesButton setTitle:@"Notes" forState:UIControlStateNormal];
    [notesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [notesButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [notesButton addTarget:self action:@selector(openNotes:) forControlEvents:UIControlEventTouchUpInside];
    [notesButton setBackgroundImage:[UIImage imageNamed:@"dusk.png"] forState:UIControlStateNormal];
    [self.view addSubview:notesButton];
}
-(void)setupMenu1
{
//    logoView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height*.2)];
//    logoView.backgroundColor = [UIColor whiteColor];
//    logoView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    logoView.layer.shadowOffset = CGSizeMake(0, 2.0);
//    logoView.layer.shadowRadius = 2.0;
//    logoView.layer.shadowColor = [UIColor grayColor].CGColor;
//    logoView.layer.shadowOpacity = 0.75;
    
//    [self.view addSubview:logoView];
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    
    logo = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*.25)];
    logo.image = [UIImage imageNamed:@"Lane8BarImageSmall.png"];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.layer.borderWidth = .5;
    logo.layer.borderColor = [UIColor whiteColor].CGColor;
    logo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:logo];
    
    settingButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gearWhite16.png" ] style:UIBarButtonItemStyleBordered target:self action:@selector(openSettings)];
    //    [settingButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 2;
    self.navigationItem.rightBarButtonItem = settingButton;
    
    int gap = (self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)*.1;
    int height = self.view.frame.size.height- self.navigationController.navigationBar.frame.size.height - logo.frame.size.height - gap;
    int buttonGap = height*.05;
    UIImageView *resultsButtonBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seaFoam.png"]];
    resultsButtonBackground.alpha = .2;
    rosterBButton = [BButton buttonWithType:BButtonTypeDefault];
    rosterBButton.frame =CGRectMake(self.view.frame.size.width*.25,logo.frame.origin.y+logo.frame.size.height+gap,self.view.frame.size.width*.5,height*.25);
    rosterBButton.backgroundColor = [UIColor clearColor];
    [rosterBButton setTitle:@"Roster" forState:UIControlStateNormal];
    [rosterBButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    //    [rosterButton setBackgroundColor:[UIColor colorWithRed:229 green:229 blue:231 alpha:.2]];
    [rosterBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rosterBButton addTarget:self action:@selector(openRoster:) forControlEvents:UIControlEventTouchUpInside];
    [rosterBButton setBackgroundImage:resultsButtonBackground.image forState:UIControlStateNormal];
    [self.view addSubview:rosterBButton];
    
    resultsBButton = [UIButton buttonWithType:BButtonTypeDefault];
    resultsBButton.frame =CGRectMake(self.view.frame.size.width*.25,rosterBButton.frame.origin.y+rosterBButton.frame.size.height+1+buttonGap,self.view.frame.size.width*.5,(height*.25)-1);
    resultsBButton.backgroundColor = [UIColor clearColor];
    [resultsBButton setTitle:@"Results" forState:UIControlStateNormal];
    [resultsBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resultsBButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [resultsBButton addTarget:self action:@selector(openResults:) forControlEvents:UIControlEventTouchUpInside];
    [resultsBButton setBackgroundImage:[UIImage imageNamed:@"gray.png"] forState:UIControlStateNormal];
    [self.view addSubview:resultsBButton];
    
    //    timerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    timerButton.frame =CGRectMake(0,resultsButton.frame.origin.y+resultsButton.frame.size.height+1,(self.view.frame.size.width),(self.view.frame.size.height/3)-1);
    //    timerButton.backgroundColor = [UIColor clearColor];
    //    [timerButton setTitle:@"Timer" forState:UIControlStateNormal];
    //    [timerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [timerButton addTarget:self action:@selector(openTimer:) forControlEvents:UIControlEventTouchUpInside];
    //    [timerButton setBackgroundImage:[UIImage imageNamed:@"blueBlur.jpeg"] forState:UIControlStateNormal];
    //    [self.view addSubview:timerButton];
    
    notesBButton = [UIButton buttonWithType:BButtonTypeDefault];
    notesBButton.frame =CGRectMake(self.view.frame.size.width*.25,resultsBButton.frame.origin.y+resultsBButton.frame.size.height+buttonGap,self.view.frame.size.width*.5,(height*.25)-1);
    notesBButton.backgroundColor = [UIColor clearColor];
    [notesBButton setTitle:@"Notes" forState:UIControlStateNormal];
    [notesBButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [notesBButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    [notesBButton addTarget:self action:@selector(openNotes:) forControlEvents:UIControlEventTouchUpInside];
    [notesBButton setBackgroundImage:[UIImage imageNamed:@"dusk.png"] forState:UIControlStateNormal];
    [self.view addSubview:notesBButton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)openRoster:(id) sender
{
    RosterController *roster = [[RosterController alloc] initWithContext:self.managedObjectContext];
    [self.navigationController pushViewController:roster animated:YES];
}
-(void)openResults:(id) sender
{
    ResultsController *results = [[ResultsController alloc] initWithContext:self.managedObjectContext];
    [self.navigationController pushViewController:results animated:YES];
}
-(void)openTimer:(id) sender
{
    ExTimerViewController *timer = [[ExTimerViewController alloc] initWithContext:self.managedObjectContext];
    [self.navigationController pushViewController:timer animated:YES];
}
-(void)openNotes:(id) sender
{
    NotesController *notes = [[NotesController alloc]initWithContext:self.managedObjectContext];
    [self.navigationController pushViewController:notes animated:YES];
}
-(void)openSettings
{
    Settings *settings = [[Settings alloc]initWithContext:self.managedObjectContext];
    [self.navigationController pushViewController:settings animated:YES];
}
@end
