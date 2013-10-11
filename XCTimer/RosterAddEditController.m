//
//  RosterAddEditController.m
//  XCTimer
//
//  Created by MBradley on 12/30/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "RosterAddEditController.h"
#import "Person+Methods.h"
#import <Parse/Parse.h>

@interface RosterAddEditController ()

@end

@implementation RosterAddEditController
{
    UIButton *photoButton;
    UIImage *picture;
    UIImageView *photoImageView;
    UITextField *firstName;
    UITextField *lastName;
    UIButton *gender;
    UITextField *grade;
    NSArray *pickerViewList;
    UIPickerView *pickerView;
    int clickCount;
    Person *person;
    BOOL isEditing;
    NSArray *array;
    UIBarButtonItem *saveButton;
    BOOL wrongFirstName;
    UIImagePickerController *picker;
    UIActionSheet *sheet;
    int navBar;
}

-(id)init
{
    if (self = [super init])
    {
        isEditing = NO;
    }
    return self;
}

-(id)initWithPerson:(Person*)p
{
    if (self = [super init])
    {
        person = p;
        isEditing = YES;
    }
    return self;
}

-(void)createNewPerson
{
    person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
}


- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.RightBarButtonItem = saveButton;
    if (isEditing)
        self.title = @"Edit Runner";
    else
        self.title =@"Create Runner";
//    gender.inputView = pickerView;
    array = [[NSArray alloc] initWithObjects:@"Male", @"Female", nil];
}
-(void)loadView
{
    [super loadView];
    navBar = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    int imageHeight = self.view.frame.size.width/3;
    firstName = [[UITextField alloc] initWithFrame:CGRectMake(imageHeight+10, imageHeight/4+navBar, self.view.frame.size.width-10, 40)];
    firstName.backgroundColor = [UIColor clearColor];
    firstName.textColor = [UIColor whiteColor];
    lastName = [[UITextField alloc] initWithFrame:CGRectMake(imageHeight+10, imageHeight/2+navBar, self.view.frame.size.width-10, 40)];
    lastName.backgroundColor = [UIColor clearColor];
    lastName.textColor = [UIColor whiteColor];
    gender = [UIButton buttonWithType:UIButtonTypeCustom];
    gender.frame = CGRectMake(5, 5+imageHeight+navBar, imageHeight, 40);
    gender.backgroundColor = [UIColor clearColor];
    [gender addTarget:self action:@selector(swithGender) forControlEvents:UIControlEventTouchUpInside];
    [gender setTitle:@"Male" forState:UIControlStateNormal];
    grade = [[UITextField alloc] initWithFrame:CGRectMake(firstName.frame.origin.x, imageHeight/1.2+navBar, self.view.frame.size.width-10, 40)];
    grade.backgroundColor = [UIColor clearColor];
    grade.textColor = [UIColor whiteColor];
    grade.keyboardType = UIKeyboardTypeNumberPad;
    grade.delegate = self;
    UIColor *color = [UIColor whiteColor];
    firstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
    lastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    grade.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Grade" attributes:@{NSForegroundColorAttributeName: color}];
    firstName.delegate = self;
    firstName.tag=1;
    lastName.delegate = self;
    lastName.tag=2;
    pickerView.delegate = self;
    firstName.text = person.firstName;
    lastName.text = person.lastName;
    grade.text = person.grade;
    
    photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+navBar, imageHeight, imageHeight)];
    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    photoImageView.layer.masksToBounds = YES;
    [[photoImageView layer] setCornerRadius:10.0f];
    photoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoImageView.layer.borderWidth = 2;
    photoImageView.alpha = .5;
    
    picture = [UIImage imageWithData:person.profilePicture];
    photoImageView.image =  picture;
    
    photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame =CGRectMake(5,5+navBar,imageHeight, imageHeight);
    photoButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    //    photoButton.layer.masksToBounds = YES;
    //    [[photoButton layer] setCornerRadius:20.0f];
    //    photoButton.layer.borderColor = [UIColor whiteColor].CGColor;
    //    photoButton.layer.borderWidth = 2;
    
    [photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    
    [photoButton addTarget:self action:@selector(getPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstName];
    [self.view addSubview:lastName];
    [self.view addSubview:photoImageView];
    [self.view addSubview:photoButton];
    [self.view addSubview:gender];
    [self.view addSubview:grade];
    
    
    
}
-(void)swithGender
{
    if([gender.titleLabel.text isEqualToString:@"Male"])
    {
        [gender setTitle:@"Female" forState:UIControlStateNormal];
    }
    else
    {
        [gender setTitle:@"Male" forState:UIControlStateNormal];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (person.profilePicture)
    {
        [photoButton setTitle:@"Change Photo" forState:UIControlStateNormal];
    }
    else
    {
        [photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    }
    if(person.gender)
    {
        [gender setTitle:person.gender forState:UIControlStateNormal];
    }
    else
    {
        [gender setTitle:@"Male" forState:UIControlStateNormal];
    }
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
}

-(void)save
{
    if(![self checkValid] && wrongFirstName)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Invalid First Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alert show];
        NSLog(@"Invalid!!!!");
    }
    else if(![self checkValid] && !wrongFirstName)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Invalid Last Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alert show];
        NSLog(@"Invalid!!!!");
    }
    else if(!isEditing && [self checkForDuplicate])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"You have created a duplicate" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alert show];
        NSLog(@"Duplicate!!!!");
    }
    else
    {
        Person *p;
        if(person)
            p = person;
        else
            p = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        if (activeField)
            [activeField resignFirstResponder];
        activeField = nil;
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        NSUUID  *uuid = [NSUUID UUID];
        p.firstName = firstName.text;
        p.lastName = lastName.text;
        p.profilePicture = UIImageJPEGRepresentation(picture, 1);
        p.grade = grade.text;
        p.gender =gender.titleLabel.text;
        person.id = [NSNumber numberWithInt:uuid];
        NSError *error;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"PERSON SAVE ERROR: %@", error);
        }
        PFObject *onlinePerson = [PFObject objectWithClassName:@"Person"];
        [onlinePerson setObject:p.firstName forKey:@"firstName"];
        [onlinePerson setObject:p.lastName forKey:@"lastName"];
        [onlinePerson setObject:p.id forKey:@"id"];
        [onlinePerson saveInBackground];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(BOOL)checkForDuplicate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
    NSArray *people = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    NSMutableArray *people = [NSMutableArray arrayWithObjects:fetchRequest, nil];
    NSLog(@"It is:%i",[people count]);
    for(int i =0; i < [people count];i++)
    {
        Person *p = [people objectAtIndex:i];
        if([p.lastName isEqualToString: lastName.text ])
        {
            if([p.firstName isEqualToString: firstName.text])
            {
                return YES;
            }
        }
    }
    return NO;
}
-(BOOL)checkValid
{
    if([firstName.text length] == 0)
    {
        wrongFirstName = YES;
        return NO;
    }
    if([lastName.text length] == 0)
    {
        wrongFirstName = NO;
        return NO;
    }
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
-(void) getPhoto:(id) sender
{
    sheet = [[UIActionSheet alloc]     initWithTitle:@""
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:NSLocalizedString(@"Take Photo", nil),NSLocalizedString(@"Choose Existing Photo", nil), nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    picker = [[UIImagePickerController alloc] init];
    NSLog(@"It works");
    picker.delegate = self;
//    UIPopoverController *popoverController = [[UIPopoverController alloc]
//                                              initWithContentViewController:picker];
//    
//    popoverController.delegate = self;
//    [popoverController presentPopoverFromRect:photoImageView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
////    [popoverController presentPopoverFromRect:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    if((UIButton *) sender == photoButton)
//    {
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    }
//    else
//    {
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Picked");
    picture = [info objectForKey:UIImagePickerControllerOriginalImage];
    photoImageView.image = picture;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)textFieldBeganEditing:(NSNotification *)note
//{
//    gender = note.object; // set ivar to current first responder
//    [gender setHidden:NO];
//}
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    //One column
//    return 1;
//}
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    //set number of rows
//    return array.count;
//}
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    //set item per row
//    return [array objectAtIndex:row];
//}
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    gender.text=[array objectAtIndex:row];
//    
//    
//}
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    gender.inputView = pickerView;
//    [gender setHidden:NO];
//    
//}
@end
