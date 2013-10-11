//
//  Person+Methods.m
//  XCTimer
//
//  Created by MBradley on 12/7/12.
//  Copyright (c) 2012 MBradley. All rights reserved.
//

#import "Person+Methods.h"

@implementation Person (Methods)

-(NSString*)name
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
}
@end
