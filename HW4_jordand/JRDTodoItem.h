//
//  JRDTodoItem.h
//  HW4_jordand
//
//  Created by Jordan Dobson on 8/5/14.
//  Copyright (c) 2014 Jordan Dobson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRDTodoItem : NSObject <NSCoding>

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSImage  *image;

+(JRDTodoItem *)todoItemWithLabel:(NSString*)label;
+(JRDTodoItem *)todoItemWithLabel:(NSString*)label AndImage:(NSImage*)image;

@end