//
//  RaceResultsController.h
//  XCTimer
//
//  Created by MBradley on 2/27/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "UniversalController.h"
#import "Person+Methods.h"

@interface RaceResultsController : UniversalController <NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

-(id)initWithPerson:(Person*)p;
-(id)initWithPerson:(Person*)p EventTime:(EventTime*)et;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end
