//
//  Controller.m
//  Dut Mac Home Tool
//
//  Created by 何振邦 on 16/12/9.
//  Copyright © 2016年 何振邦. All rights reserved.
//

#import "Controller.h"
#import "STPrivilegedTask.h"
@implementation Controller
#pragma mark - 基础功能&初始化
-(NSString*)execCmd:(NSString*)cmd{
    // 初始化并设置shell路径
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    // -c 用来执行string-commands（命令字符串），也就说不管后面的字符串里是什么都会被当做shellcode来执行
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    
    //获得输出
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task setStandardError:[task standardOutput]];
    [task setStandardInput:[NSPipe pipe]];
    [task launch];
    //[task waitUntilExit];//貌似加了屏保也没什么用
    
    //运行结果
    NSData *data = [file readDataToEndOfFile];
    NSString* result=[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    //NSLog(@"the result of cmd %@ is %@",cmd,result);
    return result;
}
-(NSString*)execPrivilegedCmd:(NSString*)cmd{
    STPrivilegedTask* task=[[STPrivilegedTask alloc]init];
    [task setLaunchPath:@"/bin/bash"];
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    OSStatus err=[task launch];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            NSLog(@"用户取消");
            return@"User cancelled";
        }  else {
            NSLog(@"Something went wrong: %d", (int)err);
        }
    }
    [task waitUntilExit];
    NSFileHandle *readHandle = [task outputFileHandle];
    NSData *outputData = [readHandle readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    return outputString;
}
-(NSString*)dealSpecChar:(NSString*)cmd{
    NSMutableString* temp=[NSMutableString stringWithString:cmd];
    [temp replaceOccurrencesOfString:@"#" withString:@"\\#" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"%" withString:@"\\%" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&" withString:@"\\&" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"$" withString:@"\\$" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"," withString:@"\\," options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"=" withString:@"\\=" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"*" withString:@"\\*" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@" " withString:@"\\ " options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"|" withString:@"\\|" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"~" withString:@"\\~" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"{" withString:@"\\{" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"<" withString:@"\\<" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"}" withString:@"\\}" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@">" withString:@"\\>" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"'" withString:@"\\'" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@";" withString:@"\\;" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    return temp;
}

-(void)setCheckBoxState{
    NSString* showAllFileState=[self execCmd:@"defaults read com.apple.finder AppleShowAllFiles"];
    NSString* transIconState=[self execCmd:@"defaults read com.apple.Dock showhidden"];
    NSString* disableSmoothState=[self execCmd:@"defaults read -g NSScrollAnimationEnabled"];
    NSString* disableBounceState=[self execCmd:@"defaults read -g NSScrollViewRubberbanding"];
    NSString* disableAnimationState=[self execCmd:@"defaults read NSGlobalDomain NSAutomaticWindowAnimationsEnabled"];
    NSString* safariNewTabState=[self execCmd:@"defaults read com.apple.Safari TargetedClickCreate Tabs"];
    NSString* finderShowPathState=[self execCmd:@"defaults read com.apple.finder _FXShowPosixPathInTitle"];
    NSString* suckEffectState=[self execCmd:@"defaults read com.apple.dock mineffect"];
    //设置各个checkbox的状态，注意：优先判断的条件是功能开启后的状态
    //注意NSPipe的输出后面带有\n
    if([showAllFileState isEqualToString:@"1\n"]){
        [showAllFileCheck setState:1];
    }else{
        [showAllFileCheck setState:0];
    }
    if([transIconState isEqualToString:@"1\n"]){
        [transIconCheck setState:1];
    }else{
        [transIconCheck setState:0];
    }
    if([disableSmoothState isEqualToString:@"0\n"]){//默认是开了是1或者没有
        [disableSmoothCheck setState:1];
    }else{
        [disableSmoothCheck setState:0];
    }
    if([disableBounceState isEqualToString:@"0\n"]){//默认是开了是1或者没有
        [disableBounceCheck setState:1];
    }else{
        [disableBounceCheck setState:0];
    }
    if([disableAnimationState isEqualToString:@"0\n"]){
        [disableAnimationCheck setState:1];
    }else{
        [disableAnimationCheck setState:0];
    }
    if([safariNewTabState isEqualToString:@"1\n"]){
        [safariNewTabCheck setState:1];
    }else{
        [safariNewTabCheck setState:0];
    }
    if([finderShowPathState isEqualToString:@"1\n"]){
        [finderShowPathCheck setState:1];
    }else{
        [finderShowPathCheck setState:0];
    }
    if ([suckEffectState isEqualToString:@"suck\n"]) {
        [suckEffectCheck setState:1];
    }else{
        [suckEffectCheck setState:0];
    }
    //变量初始化
    pathArray=[[NSMutableArray alloc]init];
    pkgPathArray=[[NSMutableArray alloc]init];
}
-(void)awakeFromNib{
    //获得系统信息并显示
    [self setCheckBoxState];//初始化checkbox
    NSMutableString* cpuType=[NSMutableString stringWithString:[self execCmd:@"sysctl machdep.cpu.brand_string"]];
    [cpuType deleteCharactersInRange:NSMakeRange(0, 25)];
    NSString* osType=[self execCmd:@"sw_vers | grep 'ProductVersion:' | grep -o '[0-9]*\\.[0-9]*\\.[0-9]*'"];
    [cpuTypeLabel setStringValue:[NSString stringWithFormat:@"处理器型号：%@",cpuType]];
    [osTypeLabel setStringValue:[NSString
                                 stringWithFormat:@"MacOS X版本号：%@",osType]];
    [showHidePathText registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    //方便输入mac地址
    [macAddText1 setDelegate:self];
    [macAddText2 setDelegate:self];
    [macAddText3 setDelegate:self];
    [macAddText4 setDelegate:self];
    [macAddText5 setDelegate:self];
    [macAddText6 setDelegate:self];
}
#pragma mark
//处理显示隐藏文件拖拽
-(void) doGetDragDropArrayFiles:(NSArray*) fileLists{
    [pathArray addObjectsFromArray:fileLists];
    NSMutableString* tempText=[[NSMutableString alloc]init];
    for (NSString *fileName in pathArray) {
        [tempText appendFormat:@" %@",fileName.lastPathComponent];
    }
    [showHidePathText setStringValue:tempText];
}
-(IBAction)showHideClick:(id)sender{
    [pathArray removeAllObjects];
    [showHidePathText setStringValue:@""];
    if([[showHidePop titleOfSelectedItem]isEqualToString:@"隐藏"]){
        [showHideNoteText setStringValue:@"将要隐藏的文件拖拽入路径文本框中或者选择路径↑↑↑"];
    }else{
        [showHideNoteText setStringValue:@"将要显示的文件拖拽入路径文本框中↑↑↑"];
    }
}
-(IBAction)selectPath:(id)sender{
    [pathArray removeAllObjects];
    int i;
    NSMutableString* tempText=[[NSMutableString alloc]init];
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [openDlg URLs];
        for( i = 0; i < [files count]; i++ )
        {
            NSURL* fileName = [files objectAtIndex:i];
            [pathArray addObject:fileName.path];//要隐藏、显示的文件保存在pathArray
            [tempText appendFormat:@" %@",fileName.lastPathComponent];
            NSLog(@"%@",fileName.path);
        } 
    }
    [showHidePathText setStringValue:tempText];
}
-(IBAction)pkgSelectPath:(id)sender{
    [pkgPathArray removeAllObjects];
    int i;
    NSMutableString* tempText=[[NSMutableString alloc]init];
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [openDlg URLs];
        for( i = 0; i < [files count]; i++ )
        {
            NSURL* fileName = [files objectAtIndex:i];
            [pkgPathArray addObject:fileName.path];//
            [tempText appendFormat:@" %@",fileName.lastPathComponent];
            NSLog(@"%@",fileName.path);
        }
    }
    [unpackPathText setStringValue:tempText];
}
-(IBAction)showHideFile:(id)sender{
    if ([pathArray count]==0) {
        NSAlert* alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"好"];
        [alert setMessageText:@"未选择文件"];
        [alert beginSheetModalForWindow:notSleepButton.window completionHandler:^(NSInteger result) {
        }];
        return;
    }
    if([[showHidePop titleOfSelectedItem]isEqualToString:@"隐藏"]){
        for(int i=0;i<[pathArray count];++i){
            [self execCmd:[NSString stringWithFormat:@"chflags hidden %@",[self dealSpecChar:[pathArray objectAtIndex:i]]]];
        }
    }else{
        for(int i=0;i<[pathArray count];++i){
            [self execCmd:[NSString stringWithFormat:@"chflags nohidden %@",[self dealSpecChar:[pathArray objectAtIndex:i]]]];
        }
    }
}
-(IBAction)showHideChecked:(id)sender{
    if (showAllFileCheck.state==1) {
        [self execCmd:@"defaults write com.apple.finder AppleShowAllFiles -bool true;killall Finder"];
    }else{
        [self execCmd:@"defaults write com.apple.finder AppleShowAllFiles -bool false;killall Finder"];
    }
}
-(IBAction)transIconChecked:(id)sender{
    if (transIconCheck.state==1) {
        [self execCmd:@"defaults write com.apple.Dock showhidden -bool YES;killall Dock"];
    }else{
        [self execCmd:@"defaults write com.apple.Dock showhidden -bool NO;killall Dock"];
    }
}
-(IBAction)disableSmoothChecked:(id)sender{
    if (disableSmoothCheck.state==1) {
        [self execCmd:@"defaults write -g NSScrollAnimationEnabled -bool NO"];
    }else{
        [self execCmd:@"defaults write -g NSScrollAnimationEnabled -bool YES"];
    }
}
-(IBAction)disableBounceChecked:(id)sender{
    if (disableBounceCheck.state==1) {
        [self execCmd:@"defaults write -g NSScrollViewRubberbanding -int 0"];
    }else{
        [self execCmd:@"defaults write -g NSScrollViewRubberbanding -int 1"];
    }
}
-(IBAction)disableAnimationChecked:(id)sender{
    if (disableAnimationCheck.state==1) {
        [self execCmd:@"defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false"];
    }else{
        [self execCmd:@"defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool true"];
    }
}
-(IBAction)setScrSaverBg:(id)sender{
    [self execCmd:@"/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/Mac\\ OS/ScreenSaverEngine -background"];
}
-(IBAction)notSleep:(id)sender{
    NSInteger wakeTime=unsleepTimeText.integerValue;
    if(wakeTime<=0){
        NSAlert* alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"好"];
        [alert setMessageText:@"请输入合适的时间"];
        [alert beginSheetModalForWindow:notSleepButton.window completionHandler:^(NSInteger result) {
        }];
        return;
    }
    wakeTime=wakeTime*60;
    NSString* cmd=[NSString stringWithFormat:@"caffeinate -t %ld",wakeTime];
    [self execCmd:cmd];
}
-(IBAction)setPicType:(id)sender{
    if([[picTypePop titleOfSelectedItem]isEqualToString:@"PDF"]){
        [self execCmd:@"defaults write com.apple.screencapture type PDF"];
        NSLog(@"PDF");
    }else if([[picTypePop titleOfSelectedItem]isEqualToString:@"PNG"]){
        [self execCmd:@"defaults write com.apple.screencapture type PNG"];
        NSLog(@"PNG");
    }else{
        [self execCmd:@"defaults write com.apple.screencapture type JPG"];
        NSLog(@"JPG");
    }
}
-(IBAction)purge:(id)sender{
    [self execCmd:@"purge"];
}
-(IBAction)safariNewTab:(id)sender{
    if(safariNewTabCheck.state==1){
        [self execCmd:@"defaults write com.apple.Safari TargetedClickCreate Tabs -bool true"];
    }else{
        [self execCmd:@"defaults write com.apple.Safari TargetedClickCreate Tabs -bool false"];
    }
}
-(IBAction)finderShowPath:(id)sender{
    if (finderShowPathCheck.state==1) {
        [self execCmd:@"defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES"];
    }else{
        [self execCmd:@"defaults write com.apple.finder _FXShowPosixPathInTitle -bool NO"];
    }
}
-(IBAction)unpack:(id)sender{
    if([pkgPathArray count]==0){
        NSAlert* alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"好"];
        [alert setMessageText:@"未选择文件"];
        [alert beginSheetModalForWindow:notSleepButton.window completionHandler:^(NSInteger result) {
        }];
        return;
    }
    for(int i=0;i<[pkgPathArray count];++i){
        [self execCmd:[NSString stringWithFormat:@"pkgutil --expand %@ ~/Desktop/",[self dealSpecChar:[pkgPathArray objectAtIndex:i]]]];
    }
}
-(IBAction)suckEffectChecked:(id)sender{
    if (suckEffectCheck.state==1) {
        [self execCmd:@"defaults write com.apple.dock mineffect -string suck;killall Dock"];
    }else{
        [self execCmd:@"defaults write com.apple.dock mineffect -string genie;killall Dock"];
    }
}
-(IBAction)changeMacAdd:(id)sender{
    NSString* type=[enType titleOfSelectedItem];
    if(macAddText4.stringValue.length!=2||macAddText3.stringValue.length!=2||macAddText2.stringValue.length!=2||macAddText1.stringValue.length!=2||macAddText5.stringValue.length!=2||macAddText6.stringValue.length!=2){
        NSAlert* alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"好"];
        [alert setMessageText:@"请输入正确的mac地址"];
        [alert beginSheetModalForWindow:notSleepButton.window completionHandler:^(NSInteger result) {
        }];
        return;
    }
    NSString* newMacAdd=[NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",macAddText1.stringValue,macAddText2.stringValue,macAddText3.stringValue,macAddText4.stringValue,macAddText5.stringValue,macAddText6.stringValue];
    NSString* cmd=[NSString stringWithFormat:@"sudo ifconfig %@ ether %@",type,newMacAdd];
    NSString* result=[self execCmd:cmd];
    if([result containsString:@"power is off"]){
        NSAlert* alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"好"];
        [alert setMessageText:@"该网卡没有被开启，请开启该网卡"];
        [alert beginSheetModalForWindow:notSleepButton.window completionHandler:^(NSInteger result) {
        }];
    }else{
        NSAlert* alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"好"];
        [alert setMessageText:@"修改成功，但重启后将会失效"];
        [alert setInformativeText:@"您可以在终端中输入命令ifconfig来查看当前mac地址"];
        [alert beginSheetModalForWindow:notSleepButton.window completionHandler:^(NSInteger result) {
        }];
    }
    
}
-(void)controlTextDidChange:(NSNotification *)obj{
    if(((NSTextField*)obj.object).stringValue.length==2){
        if([obj.object isEqual:macAddText1])[macAddText2 becomeFirstResponder];
        else if ([obj.object isEqual:macAddText2])[macAddText3 becomeFirstResponder];
        else if([obj.object isEqual:macAddText3])[macAddText4 becomeFirstResponder];
        else if([obj.object isEqual:macAddText4])[macAddText5 becomeFirstResponder];
        else if([obj.object isEqual:macAddText5])[macAddText6 becomeFirstResponder];
    }
}
#pragma mark - macOS启动盘制作
-(IBAction)OSSelectPath:(id)sender{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    openDlg.allowsMultipleSelection=NO;
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [openDlg URLs];
        NSURL* fileName = [files objectAtIndex:0];
        OSPath=[self dealSpecChar:fileName.path];
        NSLog(@"%@",OSPath);
        [OSPathText setStringValue:fileName.path];
    }
}
-(IBAction)selectVolume:(id)sender{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    openDlg.allowsMultipleSelection=NO;
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [openDlg URLs];
        NSURL* fileName = [files objectAtIndex:0];
        Volume=[self dealSpecChar:fileName.path];
        NSLog(@"%@",Volume);
        [drivePathText setStringValue:fileName.path];
    }
}
-(IBAction)makeOS:(id)sender{
    if(OSPath.length<1||Volume.length<1||[OSPath isEqual:nil]||[Volume isEqual:nil]){
        NSAlert* alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"好"];
        [alert setMessageText:@"未选择文件或目标磁盘"];
        [alert beginSheetModalForWindow:OSMakeButton.window completionHandler:^(NSInteger result) {
        }];
        return;
    }else{
        NSAlert* alert=[[NSAlert alloc]init];
        [alert addButtonWithTitle:@"取消"];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"此操作将抹除您选择的磁盘"];
        [alert setInformativeText:@"磁盘文件将会全部抹除且不可恢复，此过程将持续数分钟请勿拔出目标磁盘"];
        [alert beginSheetModalForWindow:OSMakeButton.window completionHandler:^(NSInteger result) {
            if(result==NSAlertFirstButtonReturn)return;
            else{
                //make os!!!
                OSTask = [[NSTask alloc] init];
                [OSTask setLaunchPath: @"/bin/bash"];
                NSString* cmd=@"ls ~/";
                NSString* OSCmd=[NSString stringWithFormat:@"sudo %@/Contents/Resources/createinstallmedia --volume %@ --applicationpath %@",OSPath,Volume,OSPath];
                NSArray *arguments = [NSArray arrayWithObjects: @"-c", OSCmd,nil];
                [OSTask setArguments: arguments];
                
                //获得输出
                NSPipe *OSPipe = [NSPipe pipe];
                [OSTask setStandardOutput: OSPipe];
                NSFileHandle *file = [OSPipe fileHandleForReading];
                [OSTask setStandardError:[OSTask standardOutput]];
                [OSTask setStandardInput:[NSPipe pipe]];
                //add notification
                NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
                [nc removeObserver:self];
                [nc addObserver:self selector:@selector(update:) name:NSFileHandleReadCompletionNotification object:file];
                [nc addObserver:self selector:@selector(taskTerminated:) name:NSTaskDidTerminateNotification object:OSTask];
                NSString* input=@"y\n";
                [[[OSTask standardInput]fileHandleForWriting] writeData:[input dataUsingEncoding:NSUTF8StringEncoding]];
                [OSTask launch];
                [file readInBackgroundAndNotify];
                [OSMakeProg startAnimation:self];
                OSMakeButton.enabled=NO;
                //make os!!!
            }
        }];
    }
    
    
}
-(void)update:(NSNotification*)n{
    NSData* data=[[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
    NSString* output=[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    //NSLog(@"%@",output);
    NSTextStorage* ts=[OSOutputText textStorage];
    [ts replaceCharactersInRange:NSMakeRange([ts length], 0) withString:output];
    if(OSTask){
        [[OSTask.standardOutput fileHandleForReading] readInBackgroundAndNotify];
    }
}
-(void)taskTerminated:(NSNotification*)n{
    NSAlert* alert=[[NSAlert alloc]init];
    [alert addButtonWithTitle:@"好"];
    [alert setMessageText:@"macOS系统盘制作完成"];
    [alert setInformativeText:@"您可以在开机时按住option键进入启动选择界面，选择安装macOS"];
    [alert beginSheetModalForWindow:OSMakeButton.window completionHandler:^(NSInteger result) {
    }];
    OSMakeButton.enabled=YES;
    [OSMakeProg stopAnimation:self];
}
@end
