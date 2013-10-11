//
//  NotesController.h
//  XCTimer
//
//  Created by MBradley on 3/20/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "UniversalController.h"


@interface NotesController : UniversalController <NSFetchedResultsControllerDelegate,UITextViewDelegate>
{
    UITextView *activeView;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


- (id)initWithContext:(NSManagedObjectContext*)objectContext;

@end
