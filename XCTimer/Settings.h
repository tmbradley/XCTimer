//
//  Settings.h
//  XCTimer
//
//  Created by Michael Bradley on 4/16/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import "UniversalController.h"
#import "CKCalendarView.h"

@interface Settings : UniversalController <CKCalendarDelegate>

- (id)initWithContext:(NSManagedObjectContext*)objectContext;

@end
