//
//  AppDelegate.m
//  Dut Mac Home Tool
//
//  Created by 何振邦 on 16/12/9.
//  Copyright © 2016年 何振邦. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [_window setDelegate:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(void)windowWillClose:(NSNotification *)notification{
    [NSApp terminate:self];
}
@end
