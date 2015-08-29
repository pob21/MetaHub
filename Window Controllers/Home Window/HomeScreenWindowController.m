//
//  HomeScreenWindowController.m
//  CineFile
//
//  Created by Preston Brown on 10/10/14.
//  Copyright (c) 2014 Dream Flow Studios. All rights reserved.
//

#import "HomeScreenWindowController.h"



@implementation HomeScreenWindowController


@synthesize dropSongView, songTitleField, albumTitleField, artistField, yearField, saveButton, searchButton, songSelectorWindow, songSelector, albumArtImageView, fileLocation, songDictionary;




-(void)showWindow:(id)sender {
    
    [super showWindow: sender];
    
    self.window.titlebarAppearsTransparent = YES;
    
    dropSongView = [[DropSongView alloc] initWithFrame: NSMakeRect(0, self.window.frame.size.height-300, 300, 300) withDelegate: self];
    [self.window.contentView addSubview: dropSongView];
    
    
    albumArtImageView = [[NSImageView alloc] initWithFrame: NSMakeRect(0, self.window.frame.size.height-300, 300, 300)];
    [albumArtImageView setWantsLayer: YES];
    albumArtImageView.layer.backgroundColor = [NSColor purpleColor].CGColor;
    
    [self setupDataFields];
    

    
}



#pragma mark - GUI


- (void)setupDataFields {
    
    
    songTitleField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.window.frame.size.height-355, 300, 50)];
    songTitleField.stringValue = @"";
    songTitleField.placeholderString = @"Song Title";
    songTitleField.backgroundColor = [NSColor whiteColor];
    songTitleField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 20];
    songTitleField.editable = YES;
    songTitleField.bordered = NO;
    [self.window.contentView addSubview: songTitleField];
    
    
    
    albumTitleField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.window.frame.size.height-415, 300, 50)];
    albumTitleField.stringValue = @"";
    albumTitleField.placeholderString = @"Album Title";
    albumTitleField.backgroundColor = [NSColor whiteColor];
    albumTitleField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 20];
    albumTitleField.editable = YES;
    albumTitleField.bordered = NO;
    [self.window.contentView addSubview: albumTitleField];

    
    
    artistField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.window.frame.size.height-475, 300, 50)];
    artistField.stringValue = @"";
    artistField.placeholderString = @"Artist";
    artistField.backgroundColor = [NSColor whiteColor];
    artistField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 20];
    artistField.editable = YES;
    artistField.bordered = NO;
    [self.window.contentView addSubview: artistField];

    
    
    
    yearField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.window.frame.size.height-540, 300, 50)];
    yearField.stringValue = @"";
    yearField.placeholderString = @"Year";
    yearField.backgroundColor = [NSColor whiteColor];
    yearField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 20];
    yearField.editable = YES;
    yearField.bordered = NO;
    [self.window.contentView addSubview: yearField];


    
    
    searchButton = [[NSButton alloc] initWithFrame: CGRectMake(0, 60, 300, 60)];
    [searchButton setTitle: @"Search"];
    [searchButton setFont: [NSFont fontWithName: @"HelveticaNeue-Thin" size: 25]];
    [searchButton setWantsLayer: YES];
    searchButton.layer.backgroundColor = [NSColor colorWithRed:0.26 green:0.81 blue:0.49 alpha:1].CGColor;
    searchButton.bordered = NO;
    [searchButton setTarget: self];
    [searchButton setAction: @selector(search)];
    [self.window.contentView addSubview: searchButton];

    
    
    
    
    saveButton = [[NSButton alloc] initWithFrame: CGRectMake(0, 0, 300, 60)];
    [saveButton setTitle: @"Save And Export"];
    [saveButton setFont: [NSFont fontWithName: @"HelveticaNeue-Thin" size: 25]];
    [saveButton setWantsLayer: YES];
    saveButton.layer.backgroundColor = [NSColor colorWithRed:0.99 green:0.43 blue:0.38 alpha:1].CGColor;
    saveButton.bordered = NO;
    [saveButton setTarget: self];
    [saveButton setAction: @selector(saveAndExport)];
    [self.window.contentView addSubview: saveButton];
}





#pragma mark - Actions



- (void)search {
    
    NSString *searchString = [NSString stringWithFormat: @"%@+%@", songTitleField.stringValue, artistField.stringValue];
    searchString = [searchString stringByReplacingOccurrencesOfString: @" " withString: @"+"];
    NSURL *searchURL = [NSURL URLWithString: [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", searchString]];

    
    // Get the song data from iTunes
    NSError *error;
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: searchURL];
    [req setHTTPMethod: @"GET"];
    [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    // Get the JSON and parse it
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: req returningResponse: &response error: &error];
    NSDictionary * results = [NSJSONSerialization JSONObjectWithData: responseData options:kNilOptions error: &error];
    
    
    songSelectorWindow = [[NSWindow alloc] init];
    [songSelectorWindow setFrame: NSMakeRect(self.window.frame.origin.x+330, 100, 500, 300) display: YES animate: YES];
    songSelectorWindow.opaque = NO;
    songSelectorWindow.alphaValue = .95f;
    
    songSelector = [[SongSelectorWindowController alloc] initWithWindow: songSelectorWindow usingDelegate: self];
    songSelector.resultDictionary = results;
    [songSelector showWindow: songSelectorWindow];
    [self showWindow: songSelectorWindow];

    
    [songSelectorWindow orderFront: songSelector];
}




- (void)saveAndExport {
    
    // If the user selected "Save and Export" without dropping a song
    if(fileLocation.length == 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"You haven't selected a file yet."];
        [alert addButtonWithTitle:@"Ok"];
        [alert runModal];
        
        
        return;
        
    }

    
    ID3v2_tag* tag = load_tag(fileLocation.UTF8String); // Load the full tag from the file
    tag = new_tag();
    
    if(tag == NULL)
    {
        NSLog(@"Tag is null");
        tag = new_tag();
    }


    
    // Set the new info
    tag_set_title((char *)songTitleField.stringValue.UTF8String, 0, tag);
    tag_set_artist((char *)artistField.stringValue.UTF8String, 0, tag);
    tag_set_album((char *)albumTitleField.stringValue.UTF8String, 0, tag);
    tag_set_year((char *)yearField.stringValue.UTF8String, 0, tag);

    
    // Write the new tag to the file
    set_tag(fileLocation.UTF8String, tag);

    
    
    
    NSLog(@"Export complete");
}




//2015-08-27 20:25:35.877 MetaHub[56593:1416431] dictionary: {
//    album = "2014 Forest Hills Drive";
//    "approximate duration in seconds" = "301.124";
//    artist = "J. Cole";
//    composer = pending;
//    genre = "Hip-Hop/Rap";
//    title = "G.O.M.D.";
//    "track number" = "8/13";
//    year = 2014;
//}


#pragma mark - Utilities


- (void)linkSongInArray:(NSArray *)fileArray {
    
    if(fileArray.count == 0)
        return;
    
    else if(fileArray.count == 1)
        fileLocation = [fileArray objectAtIndex: 0];
    
    else {
        
        NSLog(@"Too many files");
        return;
    }
        
    
    NSLog(@"File Location: %@", fileLocation);
    
    

    
    
    NSURL *audioURL = [[NSURL alloc] initFileURLWithPath: fileLocation];
    
    //NSLog(@"File URL: %@", audioURL);
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


    songTitleField.stringValue = [dic objectForKey: @"title"] == nil ? @"" : [dic objectForKey: @"title"];
    albumTitleField.stringValue = [dic objectForKey: @"album"] == nil ? @"" : [dic objectForKey: @"album"];
    artistField.stringValue = [dic objectForKey: @"artist"] == nil ? @"" : [dic objectForKey: @"artist"];
    yearField.stringValue = [dic objectForKey: @"year"] == nil ? @"" : [dic objectForKey: @"year"];;
    
    
    
    CFRelease (dictionary);
    theErr = AudioFileClose (audioFile);
    assert (theErr == noErr);
    
    
}









- (void)getAlbumArtworkInfo:(NSURL *)url
{

    
    AVURLAsset *avURLAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    for (NSString *format in [avURLAsset availableMetadataFormats]) {
        
        for (AVMutableMetadataItem *metadataItem in [avURLAsset metadataForFormat:format]) {
            
            
 
            NSLog(@"Data: %@", metadataItem);
            
            if([metadataItem.commonKey isEqualToString: @"title"]) {
               // NSLog(@"MDI: %@", metadataItem.value);
                //metadataItem.value = @"Control (feat. Kendrick Lamar & Jay Electronica)";
                
            }
            
            /*if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                NSImage *artImageInMp3 = [NSImage imageWithData:[(NSDictionary*)metadataItem.value objectForKey:@"data"]];
                NSLog(@"artImageInMp3 %@",artImageInMp3);
                break;
            }*/
        }
    }
}












- (void)songSelected:(NSDictionary *)songDict {
    
    //NSLog(@"Song Selected: %@", songDict);
    
    songDictionary = songDict;
    
    NSURL *imageURL = [NSURL URLWithString: [songDict objectForKey: @"artworkUrl100"]];
    //NSData *imageData = [imageURL resourceDataUsingCache: YES];
    NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
    NSImage *imageFromBundle = [[NSImage alloc] initWithData:imageData];
    albumArtImageView.image = imageFromBundle;
    albumArtImageView.imageScaling = NSImageScaleAxesIndependently;

    
    [self.window.contentView addSubview: albumArtImageView];
    
    
    
    
    songTitleField.stringValue = [songDict objectForKey: @"trackName"];
    albumTitleField.stringValue = [songDict objectForKey: @"collectionName"];
    artistField.stringValue = [songDict objectForKey: @"artistName"];
    yearField.stringValue = [[songDict objectForKey: @"releaseDate"] substringToIndex: 4];
    
}




@end
