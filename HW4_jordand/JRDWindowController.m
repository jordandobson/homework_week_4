//
//  JRDWindowController.m
//  HW4_jordand
//
//  Created by Jordan Dobson on 8/3/14.
//  Copyright (c) 2014 Jordan Dobson. All rights reserved.
//

#import "JRDWindowController.h"
#import "JRDTodoList.h"


/////////////////////////////////////////////
//                                         //
//  THIS FILE IS ALL ACTIONS TO & FROM UI  //
//                                         //
/////////////////////////////////////////////
// Actions / Delegates / TableViews / Fields

@interface JRDWindowController () <NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate>
    @property (strong, nonatomic, readwrite) JRDTodoList *noteableTodoList;
    @property (weak, nonatomic) IBOutlet NSTableView *notableTableView;
    @property (weak, nonatomic) IBOutlet NSImageView *selectedItemImageInput;
    @property (weak, nonatomic) IBOutlet NSTextField *selectedItemLabelInput;
    @property (weak, nonatomic) IBOutlet NSButton    *removeItemButton;
@end



@implementation JRDWindowController

static NSImage  *emptyImageState;
static NSString *disabledLabelText   = @" Select or add an item.";
static NSString *newItemLabelText    = @" New Item";
static NSString *initWindowLabelText = @" Add an item to the list.";

// This is for the file loaded versions

+ (instancetype)notableCollectionWindowControllerWithList:(JRDTodoList*)list
{
    DLog(@"Controller Called with List");
    JRDWindowController *wc = [self new];
    wc.noteableTodoList = list;
    return wc;
}

- (id)init
{
    DLog(@"Controller Init");
    self = [super initWithWindowNibName: @"JRDWindowController"];
    if (self){
        self.noteableTodoList = [JRDTodoList new];
    }
    return self;
}

#pragma mark LIST RESET

-(void)resetDocumentWithList:(JRDTodoList *)todoList
{
    DLog(@"Reset");
    self.noteableTodoList = todoList;
    [self.notableTableView reloadData];
    [self updateInterfaceForItem:nil];
}

#pragma mark Window methods

- (void)windowDidLoad
{
    DLog(@"Window Loaded");
    [super windowDidLoad];
    self.notableTableView.delegate       = self;
    self.notableTableView.dataSource     = self;
    self.selectedItemLabelInput.delegate = self;

    emptyImageState = self.selectedItemImageInput.image;
    [self updateInterfaceForItem: nil];
    [self.notableTableView selectRowIndexes: [NSIndexSet indexSetWithIndex: 0] byExtendingSelection: NO];
    if(self.notableTableView.selectedRowIndexes.count == 0){
        self.selectedItemLabelInput.stringValue = initWindowLabelText;
    }
}


-(void) windowWillClose:(NSNotification *)notification {
    DLog(@"WINDOW WILL CLOSE");
}

#pragma mark TextField Delegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    if (obj.object == self.selectedItemLabelInput){
        JRDTodoItem *selItem = [self currentlySelectedItem];
        selItem.label = [self scrub:self.selectedItemLabelInput.stringValue];

        [self.notableTableView reloadDataForRowIndexes: self.notableTableView.selectedRowIndexes columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        DLog(@"Label Input Changed");
        [self updateDocumentChangeCount];
    }
}


#pragma mark Button Actions

- (IBAction)imageChanged:(id)sender
{
    if(sender == self.selectedItemImageInput){
        DLog(@"Image change from Selected Image View");
        JRDTodoItem *selItem = [self currentlySelectedItem];
        selItem.image = self.selectedItemImageInput.image;
        [self.notableTableView reloadDataForRowIndexes: self.notableTableView.selectedRowIndexes columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        [self updateDocumentChangeCount];
    }
}
- (IBAction)addItemButtonPushed:(id)sender {
    DLog(@"Add Item Pushed");
    NSIndexSet *insertionIndex = [NSIndexSet indexSetWithIndex: 0];
    [self.noteableTodoList addItemWithLabel: newItemLabelText];
    
    if(self.notableTableView.selectedRowIndexes.count != 0){
        [self.notableTableView deselectRow: self.notableTableView.selectedRow];
    }

    [self.notableTableView insertRowsAtIndexes: insertionIndex withAnimation: NSTableViewAnimationSlideDown];
    [self.notableTableView    selectRowIndexes: insertionIndex byExtendingSelection: NO];
    [self.selectedItemLabelInput selectText: self];
    [self updateDocumentChangeCount];
}

- (IBAction)removeItemButtonPushed:(id)sender {
    DLog(@"Remove Item Pushed");
    JRDTodoItem *item = self.currentlySelectedItem;
    if(item){
        NSInteger selectedRow = self.notableTableView.selectedRow;
        NSIndexSet  *removeAt = [NSIndexSet indexSetWithIndex: selectedRow];

        [self.noteableTodoList removeItem: item];

        [self.notableTableView         deselectRow: selectedRow];
        [self.notableTableView removeRowsAtIndexes: removeAt withAnimation: NSTableViewAnimationEffectFade];
        [self.notableTableView    selectRowIndexes: removeAt byExtendingSelection: YES];
        if(self.notableTableView.selectedRowIndexes.count == 0){
            DLog(@"Not Enough");
            NSIndexSet  *lastRow = [NSIndexSet indexSetWithIndex: self.noteableTodoList.allItems.count - 1] ;
            [self.notableTableView    selectRowIndexes: lastRow byExtendingSelection: YES];
            if(self.notableTableView.selectedRowIndexes.count == 0){
                self.selectedItemLabelInput.stringValue = initWindowLabelText;
            }
        }
        [self updateDocumentChangeCount];
    }
}

// #pragma mark Nil targeted actions
//-(IBAction)debugBeginDayChosen:(id)sender
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    self.noteableTodoList = [JRDTodoList beginTheDayList];
//    [self resetDocumentWithList: self.noteableTodoList];
//
//}
//-(IBAction)debugEndDayChosen:(id)sender
//{
//    self.noteableTodoList = [JRDTodoList endTheDayList];
//    [self resetDocumentWithList: self.noteableTodoList];
//}

#pragma mark Interface Manipulation Methods

-(void)updateInterfaceForItem:(JRDTodoItem*)item
{
    if(item){
        [self.selectedItemLabelInput setEnabled: YES];
        [self.selectedItemImageInput setEnabled: YES];
        [self.removeItemButton       setEnabled: YES];
        [self.selectedItemImageInput setEditable:YES];
        [self.selectedItemImageInput setAlphaValue:1.0];
        [self.selectedItemLabelInput setAlphaValue:1.0];
        self.selectedItemLabelInput.stringValue = [@" " stringByAppendingString:item.label];
        if(!item.image){
            self.selectedItemImageInput.image = emptyImageState;
        }else{
            self.selectedItemImageInput.image = item.image;
        }
    }else{
        [self.selectedItemLabelInput setEnabled: NO];
        [self.selectedItemImageInput setEnabled: NO];
        [self.removeItemButton       setEnabled: NO];
        [self.selectedItemImageInput setEditable:NO];
        [self.selectedItemLabelInput setAlphaValue:0.66];
        [self.selectedItemImageInput setAlphaValue:0.5];
        self.selectedItemLabelInput.stringValue = disabledLabelText;
        self.selectedItemImageInput.image       = emptyImageState;
    }
}

-(JRDTodoItem *)currentlySelectedItem
{
    if(self.notableTableView.selectedRowIndexes.count == 0){
        DLog(@"Currently Nothing Selected");
        return nil;
    }
    DLog(@"Currently Something Selected");
    return self.noteableTodoList.allItems[self.notableTableView.selectedRow];
}

#pragma mark Table View Delegate and DataView Methods

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{

    if(self.notableTableView == notification.object){
        DLog(@"Table Selection Changed");
        if(self.notableTableView.selectedRowIndexes.count == 0){
            DLog(@"Nothing Selected");
            [self updateInterfaceForItem:nil];
            return;
        }
        DLog(@"Row Selected");
        if(self.notableTableView == notification.object){
            JRDTodoItem *item = [self currentlySelectedItem];
            [self updateInterfaceForItem: item];
        }
    }
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.noteableTodoList.itemCount;
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // Don't forget to connect the imageView on the outlet inspector to connect it to the NSImageView in the NStableCellView

    // Creates all the cells in the table.
    NSTableCellView *cell = [tableView makeViewWithIdentifier: @"ItemCell" owner:self];
    JRDTodoItem     *item = self.noteableTodoList.allItems[row];

    cell.textField.stringValue = item.label;
    cell.imageView.image = item.image;
    
    return cell;
}

#pragma mark - HELPER METHODS

-(void)updateDocumentChangeCount
{
    [self.document updateChangeCount: NSChangeDone];
}

-(NSString*)scrub:(NSString*)string {
    // Removes whitespace at the beginning and end of a string
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
