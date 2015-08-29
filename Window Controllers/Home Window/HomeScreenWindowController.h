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
#import "SongSelectorWindowController.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "iTunes.h"
#include "id3v2lib.h"



@interface HomeScreenWindowController : NSWindowController <NSTextFieldDelegate>



// GUI
- (void)setupDataFields;
- (void)cleanUpAfterExport;


// Utilities
- (void)linkSongInArray:(NSArray *)fileArray;
- (void)songSelected:(NSDictionary *)songDict;


// Actions
- (void)search;
- (void)saveAndExport;


@property (nonatomic, strong) DropSongView *dropSongView;
@property (nonatomic, strong) NSTextField *songTitleField;
@property (nonatomic, strong) NSTextField *albumTitleField;
@property (nonatomic, strong) NSTextField *artistField;
@property (nonatomic, strong) NSTextField *yearField;
@property (nonatomic, strong) NSButton *saveButton;
@property (nonatomic, strong) NSButton *searchButton;
@property (nonatomic, strong) NSWindow *songSelectorWindow;
@property (nonatomic, strong) SongSelectorWindowController *songSelector;
@property (nonatomic, strong) NSImageView *albumArtImageView;
@property (nonatomic, strong) NSString *fileLocation;
@property (nonatomic, strong) NSDictionary *songDictionary;
@property (nonatomic, strong) MBProgressHUD *progressHUD;


@end

