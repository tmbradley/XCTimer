//
//  TimerRosterController.h
//  XCTimer
//
//  Created by MBradley on 1/14/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "UniversalTableController.h"

@interface TimerRosterController : UniversalTableController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


- (id)initWithContext:(NSManagedObjectContext*)objectContext;

@end
