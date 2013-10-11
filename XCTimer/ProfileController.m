//
//  ProfileController.m
//  XCTimer
//
//  Created by MBradley on 12/30/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "ProfileController.h"
#import "RosterAddEditController.h"
#import "Person+Methods.h"
#import "Event+Methods.h"
#import "EventTime.h"
#import "RaceResultsController.h"

@interface ProfileController ()

@end

@implementation ProfileController
{
    UIButton *photoButton;
    UIButton *racesButton;
    UILabel *genderLabel;
    UIImageView *photoImageView;
    UITextView *notesView;
    UILabel *notesLabel;
    Person *person;
    UIImageView *backgroundImageView;
    int imageHeight;
    int frameHeight;
    NSUserDefaults *defaults;
    int navBar;

}
@synthesize fetchedResultsController = __fetchedResultsController;
-(id)initWithPerson:(Person*)p
{
    if(self = [super init])
    {
        person = p;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    firstNameLabel.text = [NSString stringWithFormat:@"%@",person.firstName];
    lastNameLabel.text = [NSString stringWithFormat:@"%@",person.lastName];
    if(!person.grade || [person.grade isEqualToString:@"0"])
    {
        gradeLabel.text = [NSString stringWithFormat:@"Grade: NO GRADE ENTERED"];
    }
    else
    {
        gradeLabel.text = [NSString stringWithFormat:@"Grade: %@",person.grade];
    }
    if(!person.gender)
    {
        genderLabel.text = [NSString stringWithFormat:@"Gender: NO GENDER ENTERED"];
    }
    else
    {
        genderLabel.text = [NSString stringWithFormat:@"Gender: %@",person.gender];
    }
    photoImageView.image = [UIImage imageWithData:person.profilePicture];
//    UIImage *backgroundImage = [UIImage imageWithData:person.profilePicture];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:person.profilePicture]];
//    [self.view sendSubviewToBack:backgroundImage];
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height)];
    //backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    backgroundImageView.layer.masksToBounds = YES;
    backgroundImageView.image = [UIImage imageNamed:@"background.png"];
    backgroundImageView.alpha = .9;
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
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
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    times = [times sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    for(int i =0; i<[times count];i++)
    {
        EventTime *et = [times objectAtIndex:i];
        NSLog(@"Times After:%@",et.time);
    }
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.frame.size.width/9+self.view.frame.size.width/3,self.view.frame.size.width/2,40)];
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
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    times = [times sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.frame.size.width/9+self.view.frame.size.width/3+40,self.view.frame.size.width/2,40)];
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
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    times = [times sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.frame.size.width/9+self.view.frame.size.width/3+80,self.view.frame.size.width/2,40)];
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
-(void)loadView
{
    [super loadView];
    
    navBar = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
//    [self getBestTime];
//    [self getBestOfThree];
//    [self getAverage];
    [self setupView];
}
-(void)setupView
{
    self.title = @"Profile";
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    self.navigationItem.RightBarButtonItem = editButton;
    imageHeight = self.view.frame.size.width/3;
    frameHeight = self.view.frame.size.height;
    gradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight,0+navBar,(imageHeight-10)*2, imageHeight/4)];
    gradeLabel.backgroundColor = [UIColor clearColor];
    gradeLabel.textColor = [UIColor whiteColor];
    gradeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight+10, imageHeight/4+navBar,(2*imageHeight)-10, imageHeight/4)];
    firstNameLabel.backgroundColor = [UIColor clearColor];
    firstNameLabel.textColor = [UIColor whiteColor];
    firstNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    //    firstNameLabel.textAlignment = NSTextAlignmentCenter;
    lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageHeight+10, imageHeight/2+navBar,(2*imageHeight)-10, imageHeight/4)];
    lastNameLabel.backgroundColor = [UIColor clearColor];
    lastNameLabel.textColor = [UIColor whiteColor];
    lastNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    //    lastNameLabel.textAlignment = NSTextAlignmentCenter;
    //    UIImageView *picture = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8, lastNameLabel.frame.origin.y + lastNameLabel.frame.size.height +1, self.view.frame.size.width/2, self.view.frame.size.height/3)];
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    picture.backgroundColor = [UIColor darkGrayColor];
    
    genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageHeight, lastNameLabel.frame.origin.y + lastNameLabel.frame.size.height, (2*imageHeight)-10, imageHeight/4)];
    genderLabel.backgroundColor = [UIColor clearColor];
    genderLabel.textColor = [UIColor whiteColor];
    genderLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+navBar, imageHeight, imageHeight)];
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
//    photoImageView.image = person.userProfilePhoto;
    
    photoImageView.layer.masksToBounds = YES;
    [[photoImageView layer] setCornerRadius:50.0f];
    photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoImageView.layer.borderWidth = 2;
    racesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    racesButton.frame = CGRectMake(0,10+imageHeight+navBar,(3*imageHeight)+5, imageHeight/4);
    NSLog(@"races y:%f",racesButton.frame.origin.y);
    [racesButton setTitle:@"View All Races" forState:UIControlStateNormal];
    [racesButton addTarget:self action:@selector(openRaces) forControlEvents:UIControlEventTouchUpInside];
    racesButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seaFoam.png"]];
    notesLabel = [[UILabel alloc]initWithFrame:CGRectMake(photoImageView.frame.origin.x, self.view.frame.size.height-(self.view.frame.size.height/3)-(imageHeight/4), self.view.frame.size.width, imageHeight/4)];
    NSLog(@"notes y is:%f",notesLabel.frame.origin.y);
    NSLog(@"equation is:%f",self.view.frame.size.height-self.view.frame.size.height/3-imageHeight/4);
    NSLog(@"image height/4:%f",self.view.frame.size.height);
    notesLabel.text = @"Notes";
    notesLabel.textColor = [UIColor whiteColor];
    notesLabel.backgroundColor = [UIColor clearColor];
    
    notesView = [[UITextView alloc]initWithFrame:CGRectMake(photoImageView.frame.origin.x, self.view.frame.size.height-self.view.frame.size.height/3, self.view.frame.size.width,self.view.frame.size.height/3-notesLabel.frame.size.height)];
    notesView.backgroundColor = [UIColor clearColor];
    notesView.textColor = [UIColor whiteColor];
    notesView.text = person.note;
    notesView.delegate = self;
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [notesView setInputAccessoryView:toolbar];
    //    photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    photoButton.frame =CGRectMake(self.view.frame.size.width/8, lastNameLabel.frame.origin.y + lastNameLabel.frame.size.height +1, self.view.frame.size.width/2, self.view.frame.size.height/3);
    //    photoButton.titleLabel.textColor = [UIColor redColor];
    //    [photoButton setTitle:@"No Photo" forState:UIControlStateSelected];
    //    [photoButton addTarget:self action:@selector(getPhoto:) forControlEvents:UIControlStateNormal];
    
    [self.view addSubview:firstNameLabel];
    [self.view addSubview:lastNameLabel];
    [self.view addSubview:gradeLabel];
    [self.view addSubview:genderLabel];
    //    [self.view addSubview:picture];
    [self.view addSubview:photoImageView];
    [self.view addSubview:notesLabel];
    [self.view addSubview:notesView];
    [self.view addSubview:racesButton];
}
-(void)resignKeyboard
{
    [notesView resignFirstResponder];
    person.note = notesView.text;
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"PERSON SAVE ERROR: %@", error);
    }
}
-(void)setupView2
{
    self.title = @"Runner Details";
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    self.navigationItem.RightBarButtonItem = editButton;
    imageHeight = self.view.frame.size.width/3;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageHeight+10,self.view.frame.size.width, imageHeight/4)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",person.firstName,person.lastName];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width)-2*imageHeight-((imageHeight+10)/3), imageHeight+10,imageHeight-10, imageHeight/4)];
    firstNameLabel.backgroundColor = [UIColor clearColor];
    firstNameLabel.textColor = [UIColor whiteColor];
    firstNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    //    firstNameLabel.textAlignment = NSTextAlignmentCenter;
    lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width)-1.5*imageHeight, imageHeight+10, imageHeight-10, imageHeight/4)];
    lastNameLabel.backgroundColor = [UIColor clearColor];
    lastNameLabel.textColor = [UIColor whiteColor];
    lastNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    //    lastNameLabel.textAlignment = NSTextAlignmentCenter;
    //    UIImageView *picture = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8, lastNameLabel.frame.origin.y + lastNameLabel.frame.size.height +1, self.view.frame.size.width/2, self.view.frame.size.height/3)];
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //    picture.backgroundColor = [UIColor darkGrayColor];
    
    
    photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width)-2*imageHeight, 5, imageHeight, imageHeight)];
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    //    photoImageView.image = person.userProfilePhoto;
    
    photoImageView.layer.masksToBounds = YES;
    [[photoImageView layer] setCornerRadius:50.0f];
    photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoImageView.layer.borderWidth = 2;
    
    notesLabel = [[UILabel alloc]initWithFrame:CGRectMake(photoImageView.frame.origin.x, self.view.frame.size.height-self.view.frame.size.height/3-imageHeight/4, self.view.frame.size.width, imageHeight/4)];
    notesLabel.text = @"Notes";
    notesLabel.textColor = [UIColor whiteColor];
    notesLabel.backgroundColor = [UIColor clearColor];
    notesView = [[UITextView alloc]initWithFrame:CGRectMake(photoImageView.frame.origin.x, self.view.frame.size.height-self.view.frame.size.height/3, self.view.frame.size.width,self.view.frame.size.height/3-notesLabel.frame.size.height)];
    notesView.backgroundColor = [UIColor clearColor];
    notesView.textColor = [UIColor clearColor];
    notesView.delegate = self;
    //    photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    photoButton.frame =CGRectMake(self.view.frame.size.width/8, lastNameLabel.frame.origin.y + lastNameLabel.frame.size.height +1, self.view.frame.size.width/2, self.view.frame.size.height/3);
    //    photoButton.titleLabel.textColor = [UIColor redColor];
    //    [photoButton setTitle:@"No Photo" forState:UIControlStateSelected];
    //    [photoButton addTarget:self action:@selector(getPhoto:) forControlEvents:UIControlStateNormal];
    
//    [self.view addSubview:firstNameLabel];
//    [self.view addSubview:lastNameLabel];
    [self.view addSubview:nameLabel];
    //    [self.view addSubview:picture];
    [self.view addSubview:photoImageView];
//    [self.view addSubview:notesLabel];
//    [self.view addSubview:notesView];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    notesView = textView;
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = gradeLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         gradeLabel.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = photoImageView.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         photoImageView.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = firstNameLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         firstNameLabel.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = lastNameLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         lastNameLabel.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = racesButton.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         racesButton.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = notesLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y =self.view.frame.size.height-self.view.frame.size.height/3-imageHeight/4;
                         else
                             frame.origin.y = 0;
                         notesLabel.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = notesView.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = 0+notesLabel.frame.size.height;
                         notesView.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = genderLabel.frame;
                         if (frame.origin.y==0)
                            frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y =  lastNameLabel.frame.origin.y + lastNameLabel.frame.size.height;
                         genderLabel.frame = frame;
                     }
                     completion:nil];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    notesView = textView;
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = gradeLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         gradeLabel.frame = frame;
                     }
                     completion:nil];

    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = photoImageView.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         photoImageView.frame = frame;
                     }
                     completion:nil];

    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = firstNameLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         firstNameLabel.frame = frame;
                     }
                     completion:nil];

    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = lastNameLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         lastNameLabel.frame = frame;
                     }
                     completion:nil];

    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = racesButton.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         racesButton.frame = frame;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = notesView.frame;
                         if (frame.origin.y==0+notesLabel.frame.size.height)
                             frame.origin.y = frameHeight - frameHeight/3;
                         else
                             frame.origin.y = 0;
                         notesView.frame = frame;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = notesLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y =notesView.frame.origin.y-notesLabel.frame.size.height;
                         else
                             frame.origin.y = 0;
                         notesLabel.frame = frame;
                     }
                     completion:nil];
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = genderLabel.frame;
                         if (frame.origin.y==0)
                             frame.origin.y = -frame.origin.y+-frame.size.height;
                         else
                             frame.origin.y =  lastNameLabel.frame.origin.y + lastNameLabel.frame.size.height;
                         genderLabel.frame = frame;
                     }
                     completion:nil];
    NSLog(@"notes second y is:%f",notesLabel.frame.origin.y);
    NSLog(@"second equation is:%f",self.view.frame.size.height-self.view.frame.size.height/3-imageHeight/4);
    NSLog(@"image height/4:%f",self.view.frame.size.height);
}
-(void)edit
{
    RosterAddEditController *editViewController = [[RosterAddEditController alloc] initWithPerson:person];
    editViewController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:editViewController animated:YES];
    
}
-(void)openRaces
{
    RaceResultsController *raceViewController = [[RaceResultsController alloc] initWithPerson:person];
    raceViewController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:raceViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
