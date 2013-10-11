//
//  EventTime.h
//  XCTimer
//
//  Created by MBradley on 1/29/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Person;

@interface EventTime : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * timeString;
@property (nonatomic, retain) NSSet *event;
@property (nonatomic, retain) Person *person;
@end

@interface EventTime (CoreDataGeneratedAccessors)

- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvent:(NSSet *)values;
- (void)removeEvent:(NSSet *)values;

@end
