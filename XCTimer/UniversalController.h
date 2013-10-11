//
//  UniversalController.h
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <Dropbox/Dropbox.h>
#import "NSString+FontAwesome.h"
#import "FAImageView.h"

@interface UniversalController : UIViewController
{

}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
-(UIView *)createSortView;
-(UIView *)createSortView1;
@property BOOL b1Down;
@property BOOL b2Down;
@end

