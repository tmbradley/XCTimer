//
//  AddEventResultController.h
//  XCTimer
//
//  Created by MBradley on 1/26/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "UniversalController.h"
#import "Event+Methods.h"
#import "EventTime.h"

@interface AddEventResultController : UniversalController<NSFetchedResultsControllerDelegate,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *activeField;
}
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


- (id)initWithContext:(NSManagedObjectContext*)objectContext;
-(id)initWithEvent:(Event *)e EventTime:(EventTime*)et;
@property (nonatomic, strong) UITableView *tableView;


@end
