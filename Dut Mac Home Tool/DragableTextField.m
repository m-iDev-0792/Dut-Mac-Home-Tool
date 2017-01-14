//
//  DragableTextField.m
//  Dut Mac Home Tool
//
//  Created by 何振邦 on 17/1/14.
//  Copyright © 2017年 何振邦. All rights reserved.
//

#import "DragableTextField.h"

@implementation DragableTextField
@synthesize MyDelegate =_MyDelegate;
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void) dealloc
{
    [self setMyDelegate:nil];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //只添加对文件进行监听
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    }
    
    return self;
}
-(void) awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
}

-(NSDragOperation) draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pb =[sender draggingPasteboard];
    NSArray *array=[pb types];
    if ([array containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

//
-(BOOL) prepareForDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pb =[sender draggingPasteboard];
    NSArray *list =[pb propertyListForType:NSFilenamesPboardType];
    if (self.MyDelegate && [self.MyDelegate respondsToSelector:@selector(doGetDragDropArrayFiles:)]) {
        [self.MyDelegate doGetDragDropArrayFiles:list];
    }
    return YES;
}

@end
