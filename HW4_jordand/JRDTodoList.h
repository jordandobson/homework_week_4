#import <Foundation/Foundation.h>
#import "JRDTodoItem.h"

@class JRDTodoList;

@protocol JRDTodoListDelegate <NSObject>

    -(void)todoList:(JRDTodoList*)todoList didAddItem:   (JRDTodoItem*)item;
    -(void)todoList:(JRDTodoList*)todoList didDeleteItem:(JRDTodoItem*)item;

@end

@interface JRDTodoList : NSObject <NSCoding>

    @property (weak) id<JRDTodoListDelegate> delegate;
    @property (nonatomic, assign) BOOL allowDuplicates;

    +(instancetype)beginTheDayList;
    +(instancetype)endTheDayList;

    -(NSArray*)itemLabels;
    -(NSArray*)allItems;
    -(NSUInteger)itemCount;

    -(void)addItem:   (JRDTodoItem *)item;
    -(void)removeItem:(JRDTodoItem *)item;

    -(void)addItemWithLabel: (NSString*)label;

@end