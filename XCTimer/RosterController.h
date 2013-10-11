//
//  RosterController.h
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "UniversalTableController.h"

@interface RosterController : UniversalTableController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


- (id)initWithContext:(NSManagedObjectContext*)objectContext;

@end
