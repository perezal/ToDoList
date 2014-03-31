//
//  XYZToDoItem.m
//  ToDoList
//
//  Created by Alex Perez on 3/29/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import "XYZToDoItem.h"

@interface XYZToDoItem()

@property NSDate *completionDate;

@end

@implementation XYZToDoItem

-(void) markAsCompleted: (BOOL) isComplete
{
    self.completed = isComplete;
    [self setCompletionDate];
}

- (void) setCompletionDate
{
    if (self.completed)
        self.completionDate = [NSDate date];
    else
        self.completionDate = nil;
}

@end
