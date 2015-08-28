//
//  AppDelegate.m
//  MetaHub
//
//  Created by Preston Brown on 8/26/15.
//  Copyright (c) 2015 Dream Flow Studios. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong, nonatomic) IBOutlet NSWindow *window;
@end

@implementation AppDelegate


@synthesize homeScreen;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    
    
    
    
    [self.window setFrame: NSMakeRect(100, 100, 300, 700) display: YES];
    [self.window setOpaque: NO];
    self.window.alphaValue = .9f;
    
    homeScreen = [[HomeScreenWindowController alloc] initWithWindow:self.window];
    
    
    [homeScreen showWindow: self];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
