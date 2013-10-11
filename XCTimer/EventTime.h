//
//  EventTime.h
//  XCTimer
//
//  Created by Michael Bradley on 4/15/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Person;

@interface EventTime : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * timeString;
@property (nonatomic, retain) NSNumber * place;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Person *person;

@end
