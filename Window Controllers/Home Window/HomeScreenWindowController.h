//
//  HomeScreenWindowController.h
//  CineFile
//
//  Created by Preston Brown on 10/10/14.
//  Copyright (c) 2014 Dream Flow Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NSView+ViewBlur.h"
#import "DropSongView.h"


@interface HomeScreenWindowController : NSWindowController <NSTextFieldDelegate>



// GUI
- (void)setupDataFields;


// Utilities
- (void)linkSongInArray:(NSArray *)fileArray;



@property (nonatomic, strong) DropSongView *dropSongView;

@property (nonatomic, strong) NSTextField *songTitleField;
@property (nonatomic, strong) NSTextField *albumTitleField;
@property (nonatomic, strong) NSTextField *artistField;
@property (nonatomic, strong) NSTextField *yearField;
@property (nonatomic, strong) NSButton *saveButton;


@end

