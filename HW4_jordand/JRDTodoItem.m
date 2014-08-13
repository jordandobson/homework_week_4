//
//  JRDTodoItem.m
//  HW4_jordand
//
//  Created by Jordan Dobson on 8/5/14.
//  Copyright (c) 2014 Jordan Dobson. All rights reserved.
//

#import "JRDTodoItem.h"

@implementation JRDTodoItem

+(JRDTodoItem *)todoItemWithLabel:(NSString*)label
{
    JRDTodoItem *todo = [JRDTodoItem new];
    todo.label = label;
    todo.image = nil;
    return todo;
}

+(JRDTodoItem *)todoItemWithLabel:(NSString*)label AndImage:(NSImage*)image {
    JRDTodoItem *todo = [JRDTodoItem new];
    todo.label = label;
    todo.image = image;
    return todo;
}

#pragma mark - Override Description

-(NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<JRDTodoItem: %@ %@>", self.label, self.image];
    return desc;
}

#pragma mark - NSCoding

static NSString *labelKey = @"label";
static NSString *imageKey = @"image";

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.label = [aDecoder decodeObjectForKey:labelKey];
        self.image = [aDecoder decodeObjectForKey:imageKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.label forKey:labelKey];
    [aCoder encodeObject:self.image forKey:imageKey];
}
@end


