//
//  Note.h
//  XCTimer
//
//  Created by MBradley on 3/22/13.
//  Copyright (c) 2013 MBradley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * noteString;
@property (nonatomic, retain) NSNumber * id;

@end
