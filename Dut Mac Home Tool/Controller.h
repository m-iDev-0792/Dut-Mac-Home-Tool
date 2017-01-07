//
//  Controller.h
//  Dut Mac Home Tool
//
//  Created by 何振邦 on 16/12/9.
//  Copyright © 2016年 何振邦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
@interface Controller : NSObject<NSTextFieldDelegate>{
    IBOutlet NSTextField* cpuTypeLabel;
    IBOutlet NSTextField* osTypeLabel;
    //check box buttons
    IBOutlet NSButton* showAllFileCheck;//显示隐藏文件按钮
    IBOutlet NSButton* transIconCheck;//隐藏APP图标透明按钮
    IBOutlet NSButton* disableSmoothCheck;//禁止平滑按钮
    IBOutlet NSButton* disableBounceCheck;//禁止弹性动画按钮
    IBOutlet NSButton* disableAnimationCheck;//禁止窗口动画按钮
    IBOutlet NSButton* safariNewTabCheck;//Safari新tab打开页面按钮
    IBOutlet NSButton* finderShowPathCheck;//finder显示路径按钮
    IBOutlet NSButton* suckEffectCheck;//吸入效果
    //pop buttons
    IBOutlet NSPopUpButton* showHidePop;
    IBOutlet NSPopUpButton* picTypePop;
    IBOutlet NSPopUpButton* enType;
    //buttons
    IBOutlet NSButton* showHideButton;
    IBOutlet NSButton* setScrSaverButton;
    IBOutlet NSButton* notSleepButton;
    IBOutlet NSButton* purgeButton;
    IBOutlet NSButton* unpackButton;
    IBOutlet NSButton* OSMakeButton;
    
    //textfields
    IBOutlet NSTextField* showHidePathText;
    IBOutlet NSTextField* unsleepTimeText;
    IBOutlet NSTextField* unpackPathText;
    IBOutlet NSTextField* macAddText1;
    IBOutlet NSTextField* macAddText2;
    IBOutlet NSTextField* macAddText3;
    IBOutlet NSTextField* macAddText4;
    IBOutlet NSTextField* macAddText5;
    IBOutlet NSTextField* macAddText6;
    IBOutlet NSTextField* OSPathText;
    IBOutlet NSTextField* drivePathText;
    IBOutlet NSTextView* OSOutputText;
    //
    IBOutlet NSProgressIndicator* OSMakeProg;
    NSTask* OSTask;
    //arrays
    NSMutableArray* pathArray;
    NSMutableArray* pkgPathArray;
    NSString* OSPath;
    NSString* Volume;
}
-(IBAction)selectPath:(id)sender;
-(IBAction)pkgSelectPath:(id)sender;
-(IBAction)showHideFile:(id)sender;
-(IBAction)showHideChecked:(id)sender;
-(IBAction)transIconChecked:(id)sender;
-(IBAction)disableSmoothChecked:(id)sender;
-(IBAction)disableBounceChecked:(id)sender;
-(IBAction)disableAnimationChecked:(id)sender;
-(IBAction)setScrSaverBg:(id)sender;
-(IBAction)notSleep:(id)sender;
-(IBAction)setPicType:(id)sender;
-(IBAction)purge:(id)sender;
-(IBAction)safariNewTab:(id)sender;
-(IBAction)finderShowPath:(id)sender;
-(IBAction)unpack:(id)sender;
-(IBAction)suckEffectChecked:(id)sender;
-(IBAction)changeMacAdd:(id)sender;
-(IBAction)OSSelectPath:(id)sender;
-(IBAction)selectVolume:(id)sender;
-(IBAction)makeOS:(id)sender;
@end
