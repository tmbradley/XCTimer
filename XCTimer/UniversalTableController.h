//
//  UniversalTableController.h
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "UniversalController.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"
@interface UniversalTableController : UniversalController <UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
-(UIView *)createSortView;
-(UIView *)createSortView1;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property BOOL b1Down;
@property BOOL b2Down;
@end
