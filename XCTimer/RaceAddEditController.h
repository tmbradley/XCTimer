//
//  RaceAddEditController.h
//  XCTimer
//
//  Created by MBradley on 1/2/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "UniversalController.h"
#import "Event+Methods.h"
#import "Race+Methods.h"
#import "CKCalendarView.h"

@interface RaceAddEditController : UniversalController <UITextFieldDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,CKCalendarDelegate>
{
    UITextField *activeField;
}

@property (nonatomic, strong) UITableView *tableView;

-(id)initWithContext:(NSManagedObjectContext*) context;
-(id)initWithRace:(Race*)r;
//-(void)createNewRace;
@end
