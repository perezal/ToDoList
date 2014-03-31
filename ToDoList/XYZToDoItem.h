//
//  XYZToDoItem.h
//  ToDoList
//
//  Created by Alex Perez on 3/29/14.
//  Copyright (c) 2014 Alex Perez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

-(void) markAsCompleted: (BOOL) isComplete;

@end
