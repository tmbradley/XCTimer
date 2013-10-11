//
//  EventResultsController.h
//  XCTimer
//
//  Created by MBradley on 1/26/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "UniversalController.h"
#import "Event+Methods.h"

@interface EventResultsController : UniversalController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)Event *event;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

-(id)initWithEvent:(Event*)e;
@end
