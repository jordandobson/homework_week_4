//
//  JRDDocument.m
//  HW4_jordand
//
//  Created by Jordan Dobson on 8/3/14.
//  Copyright (c) 2014 Jordan Dobson. All rights reserved.
//

#import "JRDDocument.h"
#import "JRDWindowController.h"
#import "JRDTodoList.h"


/////////////////////////////////////////////
//                                         //
//  THIS FILE IS ALL DOCUMENT LEVEL STUFF  //
//                                         //
/////////////////////////////////////////////


// Setup Vars for List and Window

@interface JRDDocument ()
    @property (strong, nonatomic) JRDTodoList         *todoList;
    @property (strong, nonatomic) JRDWindowController *docWindowController;
@end


@implementation JRDDocument

- (id)init
{
    DLog(@"Document Initialized With New List");

    self = [super init];
    if (self) {
        self.todoList = [JRDTodoList new];
        //self.todoList = [JRDTodoList beginTheDayList];
        NSLog(@"%@",self.todoList);
    }
    return self;
}

// Recieve Updates to the data via a delegate

-(void)makeWindowControllers
{
    DLog(@"Making Window Controllers");
    
    if(!self.docWindowController){
        // Create Instance of Window Contorller
        // Send controller a pointer to the list
        self.docWindowController = [JRDWindowController notableCollectionWindowControllerWithList: self.todoList];
    }

    [self addWindowController: self.docWindowController];

    // Perform Any Setup
    // Setup calling methods in the controller class to manipulate UI
    //
    [self.docWindowController showWindow: self];

}

#pragma mark Saving & Loading

+ (BOOL)autosavesInPlace
{
    return YES;
}

-(BOOL)prepareSavePanel:(NSSavePanel *)savePanel {
    NSDateFormatter *docDateformatter = [NSDateFormatter new];
    docDateformatter.dateStyle = NSDateFormatterShortStyle;
    NSDate   *now     = [NSDate date];
    NSString *docName = [@"Noteable " stringByAppendingString: [docDateformatter stringFromDate:now]];
    [savePanel setNameFieldStringValue: docName];
    [savePanel setExtensionHidden:NO];
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    DLog(@"Data Saving");
    return [NSKeyedArchiver archivedDataWithRootObject: self.todoList];
    [self updateChangeCount: NSChangeCleared];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    DLog(@"Data Read In");
    self.todoList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if( self.todoList ){ return YES; }

    *outError = [NSError errorWithDomain:NSInternalInconsistencyException code:666 userInfo: @{NSLocalizedDescriptionKey: @"Could not read data."}];
    return NO;
}

#pragma mark Nil Targeted Methods / Actions here

-(IBAction)debugDocEndDayChosen:(id)sender
{
    self.todoList = [JRDTodoList endTheDayList];
    [self.docWindowController resetDocumentWithList: self.todoList];
}

-(IBAction)debugDocBeginDayChosen:(id)sender
{
    self.todoList = [JRDTodoList beginTheDayList];
    [self.docWindowController resetDocumentWithList: self.todoList];

}

@end
