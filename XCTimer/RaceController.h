//
//  RaceController.h
//  XCTimer
//
//  Created by MBradley on 12/31/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "UniversalController.h"
#import "Event+Methods.h"
#import "Race+Methods.h"

@interface RaceController : UniversalController <UITableViewDataSource,UITableViewDelegate>
{
    UILabel *raceNameLabel;
}
@property (nonatomic, strong) UITableView *tableView;

-(id)initWithRace:(Race*)r;
@end
