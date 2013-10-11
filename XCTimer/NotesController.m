//
//  NotesController.m
//  XCTimer
//
//  Created by MBradley on 3/20/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "NotesController.h"
#import "Note.h"


@interface NotesController ()

@end

@implementation NotesController
{
    UITextView *notesView;
    UILabel *notesLabel;
    UIBarButtonItem *done;
    Note *note;
    int navBar;
}
@synthesize fetchedResultsController = __fetchedResultsController;

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
- (NSFetchedResultsController *)fetchedResultsController
{
    NSLog(@"FETCHING");
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"ERROR");
        abort();
    }
    
    return __fetchedResultsController;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fetchedResultsController = nil;
    notesView.text = note.noteString;
    NSLog(@"%@",note);
    NSLog(@"%@",note.noteString);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navBar = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    
	// Do any additional setup after loading the view.
    self.title = @"Notes";
//    NSLog([NSString stringWithFormat:@"%@",note.notesText]);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    NSError *error = nil;
    NSArray *notes = [self.managedObjectContext executeFetchRequest:request error:&error];
    if(![self.managedObjectContext save:NULL])
    {
        NSLog(@"ERROR");
    }
    if([notes count]>0)
    {
        note = [notes objectAtIndex:0];
    }
    else
    {
        note = (Note *)[NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    }
    notesLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y + navBar, self.view.frame.size.width,self.view.frame.size.height/12)];
    notesLabel.text = @"Notes";
    notesLabel.textColor = [UIColor whiteColor];
    notesLabel.backgroundColor = [UIColor clearColor];
    
    notesView = [[UITextView alloc]initWithFrame:CGRectMake(notesLabel.frame.origin.x,notesLabel.frame.origin.y+notesLabel.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-notesLabel.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
    [[notesView layer] setCornerRadius:5.0f];
    notesView.layer.borderColor = [UIColor whiteColor].CGColor;
    notesView.layer.borderWidth = .5;

    notesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dusk.png"]];
    notesView.textColor = [UIColor whiteColor];
    notesView.font = [UIFont systemFontOfSize:15];
    notesView.text = note.noteString;
    notesView.delegate = self;
    done =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    self.navigationItem.rightBarButtonItem = done;
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton, doneButton, nil];
    [toolbar setItems:itemsArray];
    [notesView setInputAccessoryView:toolbar];
    
    [self.view addSubview:notesLabel];
    [self.view addSubview:notesView];
}
-(void)donePressed
{
    note.noteString = notesView.text;
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"NOTE SAVE ERROR: %@", error);
    }
    NSLog(@"%@",note.noteString);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)resignKeyboard
{
    [notesView resignFirstResponder];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    activeView = textView;
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^
                     {
                         CGRect frame = notesView.frame;
                             frame.size.height = 100;
                         notesView.frame = frame;
                     }
                     completion:nil];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    activeView = textView;
    [UIView animateWithDuration:.5f delay:0.0f options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CGRect frame = notesView.frame;
                         frame.size.height = self.view.frame.size.height-notesLabel.frame.size.height;//-self.navigationController.navigationBar.frame.size.height;
                         notesView.frame = frame;
                     }
                     completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
