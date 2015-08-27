//
//  HomeScreenWindowController.m
//  CineFile
//
//  Created by Preston Brown on 10/10/14.
//  Copyright (c) 2014 Dream Flow Studios. All rights reserved.
//

#import "HomeScreenWindowController.h"



@implementation HomeScreenWindowController


- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



-(void)showWindow:(id)sender {
    
    [super showWindow: sender];
    
    
    self.window.titlebarAppearsTransparent = NO;
    
    
    
    NSView *searchBarAndButton  = [[NSView alloc] initWithFrame: NSMakeRect(0, 0, 300, 300)];
    [searchBarAndButton setWantsLayer: YES];
    searchBarAndButton.layer.backgroundColor = [NSColor orangeColor].CGColor;
    [self.window.contentView addSubview: searchBarAndButton];
    


    
    
    
    
    NSLog(@"Test: %@", searchBarAndButton);
}




@end
