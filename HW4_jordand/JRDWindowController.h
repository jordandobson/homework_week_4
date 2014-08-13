//
//  JRDWindowController.h
//  HW4_jordand
//
//  Created by Jordan Dobson on 8/3/14.
//  Copyright (c) 2014 Jordan Dobson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JRDTodoList;

@interface JRDWindowController : NSWindowController
@property (strong, nonatomic, readonly) JRDTodoList *noteableTodoList;
+ (instancetype)notableCollectionWindowControllerWithList:(JRDTodoList*)list;
-(void)resetDocumentWithList:(JRDTodoList*)todoList;
@end
