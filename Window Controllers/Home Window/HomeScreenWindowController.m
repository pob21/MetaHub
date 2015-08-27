//
//  HomeScreenWindowController.m
//  CineFile
//
//  Created by Preston Brown on 10/10/14.
//  Copyright (c) 2014 Dream Flow Studios. All rights reserved.
//

#import "HomeScreenWindowController.h"



@implementation HomeScreenWindowController


@synthesize dropSongView, songTitleField, albumTitleField, artistField, yearField, saveButton;


-(void)showWindow:(id)sender {
    
    [super showWindow: sender];
    
    self.window.titlebarAppearsTransparent = NO;
    
    dropSongView = [[DropSongView alloc] initWithFrame: NSMakeRect(0, self.window.frame.size.height-300, 300, 300) withDelegate: self];
    [self.window.contentView addSubview: dropSongView];
    
    [self setupDataFields];
}



#pragma mark - GUI


- (void)setupDataFields {
    
    
    songTitleField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.window.frame.size.height-370, 300, 60)];
    songTitleField.stringValue = @"";
    songTitleField.placeholderString = @"Song Title";
    songTitleField.backgroundColor = [NSColor whiteColor];
    songTitleField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 20];
    songTitleField.editable = YES;
    songTitleField.bordered = NO;
    [self.window.contentView addSubview: songTitleField];
    
    
    
    albumTitleField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.window.frame.size.height-440, 300, 60)];
    albumTitleField.stringValue = @"";
    albumTitleField.placeholderString = @"Album Title";
    albumTitleField.backgroundColor = [NSColor whiteColor];
    albumTitleField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 20];
    albumTitleField.editable = YES;
    albumTitleField.bordered = NO;
    [self.window.contentView addSubview: albumTitleField];

    
    
    artistField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.window.frame.size.height-510, 300, 60)];
    artistField.stringValue = @"";
    artistField.placeholderString = @"Artist";
    artistField.backgroundColor = [NSColor whiteColor];
    artistField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 20];
    artistField.editable = YES;
    artistField.bordered = NO;
    [self.window.contentView addSubview: artistField];

    
    
    
    yearField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.window.frame.size.height-580, 300, 60)];
    yearField.stringValue = @"";
    yearField.placeholderString = @"Year";
    yearField.backgroundColor = [NSColor whiteColor];
    yearField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 20];
    yearField.editable = YES;
    yearField.bordered = NO;
    [self.window.contentView addSubview: yearField];


    
    
    
    
    saveButton = [[NSButton alloc] initWithFrame: CGRectMake(0, 0, 300, 80)];
    [saveButton setTitle: @"Save And Export"];
    [saveButton setFont: [NSFont fontWithName: @"HelveticaNeue-Thin" size: 25]];
    
    [saveButton setWantsLayer: YES];
    saveButton.layer.backgroundColor = [NSColor colorWithRed:0.99 green:0.43 blue:0.38 alpha:1].CGColor;
    saveButton.bordered = NO;
    [self.window.contentView addSubview: saveButton];
}






#pragma mark - Utilities


- (void)linkSongInArray:(NSArray *)fileArray {
    
    NSString *fileLocation;
    
    
    if(fileArray.count == 0)
        return;
    
    else if(fileArray.count == 1)
        fileLocation = [fileArray objectAtIndex: 0];
    
    else {
        
        NSLog(@"Too many files");
        return;
    }
        
    
    NSLog(@"File Location: %@", fileLocation);
    
    
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath: fileLocation])
        NSLog(@"Exists");

    
    //NSURL *audioURL = [[NSBundle mainBundle] URLForResource: @"08 G.O.M.D." withExtension: @"m4a"];
    NSURL *audioURL = [[NSURL alloc] initFileURLWithPath: fileLocation];
    NSLog(@"File URL: %@", audioURL);
    AudioFileID audioFile;
    OSStatus theErr = noErr;
    theErr = AudioFileOpenURL((__bridge CFURLRef)audioURL,
                              kAudioFileReadPermission,
                              0,
                              &audioFile);
    assert (theErr == noErr);
    UInt32 dictionarySize = 0;
    theErr = AudioFileGetPropertyInfo (audioFile,
                                       kAudioFilePropertyInfoDictionary,
                                       &dictionarySize,
                                       0);
    assert (theErr == noErr);
    CFDictionaryRef dictionary;
    theErr = AudioFileGetProperty (audioFile,
                                   kAudioFilePropertyInfoDictionary,
                                   &dictionarySize,
                                   &dictionary);
    assert (theErr == noErr);
    
    
    
    NSMutableDictionary *dic = (__bridge NSMutableDictionary*)dictionary;
    
    NSLog (@"dictionary: %@", dic);


    songTitleField.stringValue = [dic objectForKey: @"title"];
    albumTitleField.stringValue = [dic objectForKey: @"album"];
    artistField.stringValue = [dic objectForKey: @"artist"];
    yearField.stringValue = [dic objectForKey: @"year"];
    
    
    
    CFRelease (dictionary);
    theErr = AudioFileClose (audioFile);
    assert (theErr == noErr);
    
    
    //NSDictionary *original = [NSDictionary dictionaryWithObject:@"World" forKey:@"Hello"];
    //CFDictionaryRef dict = (__bridge CFDictionaryRef)original;
    //NSDictionary *andBack = (__bridge NSDictionary*)dict;
    //NSLog(@"%@", andBack);

    
}



@end
