//
//  DragableTextField.h
//  Dut Mac Home Tool
//
//  Created by 何振邦 on 17/1/14.
//  Copyright © 2017年 何振邦. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol DragableTextFieldDelegate;

@interface DragableTextField : NSTextField
@property(assign) IBOutlet id<DragableTextFieldDelegate> MyDelegate;

@end

@protocol DragableTextFieldDelegate <NSObject>
//设置代理方法
-(void) doGetDragDropArrayFiles:(NSArray*) fileLists;

@end
