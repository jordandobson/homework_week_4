#import "JRDTodoList.h"

@interface JRDTodoList ()
    @property (strong, nonatomic) NSMutableArray *listItems;
@end

NSString * const todoListKey  = @"todoListKey";

@implementation JRDTodoList

#pragma mark - CLASS CONVENIENCE CONSTRUCTORS

+ (JRDTodoList *)beginTheDayList{
    NSArray *labels = @[ @"Wake Up", @"Get Out Of Bed", @"Shower", @"Brush Teeth", @"Eat Breakfast"];
    JRDTodoList *list = [JRDTodoList initWithArray: labels];
    return list;
}

+ (JRDTodoList *)endTheDayList{
    NSArray *labels = @[ @"Eat Dinner", @"Brush Teeth", @"Get In Bed", @"Go To Sleep"];
    JRDTodoList *list = [JRDTodoList initWithArray: labels];
    return list;
}

+ (JRDTodoList *)initWithArray:(NSArray*)labels{
    JRDTodoList *list = [JRDTodoList new];
    [list populateList: labels];
    return list;
}

#pragma mark - INITIALIZER

-(id)init{
    self = [super init];
    if(self){
        self.listItems = [NSMutableArray new];
       DLog(@"LIST Initialized");
    }
    return self;
}

#pragma mark - POPULATE VIA ARRAY

-(void)populateList:(NSArray*)labels
{
    for (id label in labels) {
        [self addItemWithLabel: label];
    }
}

#pragma mark - ADD METHODS

-(void)addItemWithLabel:(NSString*)label {
    NSString *lbl = [self scrub: label];
    if([self canAddItemWithLabel: lbl]){
        JRDTodoItem *item = [JRDTodoItem todoItemWithLabel: lbl];
        [self addItem: item];
    }
}

-(BOOL)canAddItem:(JRDTodoItem*)item
{
    return [self canAddItemWithLabel: item.label];
}

-(BOOL)canAddItemWithLabel:(NSString*)label
{
    NSString *lbl = [self scrub: label];
    if(lbl.length == 0){ return NO; } else { return YES; }
}

-(void)addItem:(JRDTodoItem*)item {
    if([self canAddItem: item]){
        [_listItems insertObject: item atIndex: 0];                             // Add to begining of List
        [self.delegate todoList:self didAddItem: item];
    }
}

#pragma mark - DELETE METHODS

-(void)removeItem:(JRDTodoItem *)item{
    [self.listItems removeObjectIdenticalTo: item];
    DLog(@"ITEM REMOVED");
}

#pragma mark - LABEL COLLECTOR & CHECKERS

-(NSArray*)itemLabels
{
    NSMutableArray *array = [NSMutableArray new];
    for (id anObject in self.listItems) {
        [array addObject: [anObject label]];
    }
    return [NSArray arrayWithArray: array];
}

-(NSArray  *)allItems
{
    return _listItems;
}

-(NSUInteger)itemCount
{
    return _listItems.count;
}

#pragma mark - OVERRIDE METHODS

-(NSString *)description {
    NSString *boolean = self.allowDuplicates ? @"YES" : @"NO";
    NSString *array   = [self.itemLabels componentsJoinedByString: @", "];
    NSString *desc    = [NSString stringWithFormat: @"\n<JRDTodoList:\n  DUPLICATES ALLOWED: %@ \n  COUNT: %lu\n  ITEMS: %@ \n>", boolean, self.itemCount, array];
    return desc;
}

#pragma mark - Encode & Decode

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject: self.listItems forKey: todoListKey];
    NSLog(@"ENCODED");
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        self.listItems  = [aDecoder decodeObjectForKey:  todoListKey];
        NSLog(@"DECODED");
    }
    return self;
}

#pragma mark - HELPER METHODS

-(NSString*)scrub:(NSString*)label
{
    return [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
