//
//  ProfileController.h
//  XCTimer
//
//  Created by MBradley on 12/30/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//
#import "UniversalController.h"
#import "Person+Methods.h"

@interface ProfileController : UniversalController <NSFetchedResultsControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
{
    UILabel *firstNameLabel;
    UILabel *lastNameLabel;
    UILabel *gradeLabel;
    UITextView *activeView;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
-(id)initWithPerson:(Person*)p;

@end
