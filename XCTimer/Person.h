//
//  Person.h
//  XCTimer
//
//  Created by Michael Bradley on 10/11/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, EventTime;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * grade;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSData * profilePicture;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *eventTimes;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addEventTimesObject:(EventTime *)value;
- (void)removeEventTimesObject:(EventTime *)value;
- (void)addEventTimes:(NSSet *)values;
- (void)removeEventTimes:(NSSet *)values;

@end
