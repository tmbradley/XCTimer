//
//  ResultsController.h
//  XCTimer
//
//  Created by MBradley on 12/30/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "UniversalTableController.h"

@interface ResultsController : UniversalTableController  <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


- (id)initWithContext:(NSManagedObjectContext*)objectContext;

@end
