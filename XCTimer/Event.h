//
//  Event.h
//  XCTimer
//
//  Created by MBradley on 2/6/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventTime, Person, Race;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *eventTimes;
@property (nonatomic, retain) NSSet *people;
@property (nonatomic, retain) Race *race;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addEventTimesObject:(EventTime *)value;
- (void)removeEventTimesObject:(EventTime *)value;
- (void)addEventTimes:(NSSet *)values;
- (void)removeEventTimes:(NSSet *)values;

- (void)addPeopleObject:(Person *)value;
- (void)removePeopleObject:(Person *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

@end
