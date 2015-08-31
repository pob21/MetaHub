//
//  HomeScreenWindowController.m
//  CineFile
//
//  Created by Preston Brown on 10/10/14.
//  Copyright (c) 2014 Dream Flow Studios. All rights reserved.
//

#import "HomeScreenWindowController.h"



@implementation HomeScreenWindowController


@synthesize dropSongView, songTitleField, albumTitleField, artistField, yearField, saveButton, searchButton, songSelectorWindow, songSelector, albumArtImageView, fileLocation, songDictionary, progressHUD;


#define METAHUB_DOC_LOCATION [NSString stringWithFormat: @"%@/Documents/MetaHub", NSHomeDirectory()]
#define METAHUB_DOWNLOADS_LOCATION [METAHUB_DOC_LOCATION stringByAppendingString: @"/Downloads"]


-(void)showWindow:(id)sender {
    
    [super showWindow: sender];
    
    [self.window setStyleMask:NSBorderlessWindowMask];

    
    dropSongView = [[DropSongView alloc] initWithFrame: NSMakeRect(0, self.window.frame.size.height-300, 300, 300) withDelegate: self];
    [self.window.contentView addSubview: dropSongView];
    
    
    albumArtImageView = [[NSImageView alloc] initWithFrame: NSMakeRect(0, self.window.frame.size.height-300, 300, 300)];
    [albumArtImageView setWantsLayer: YES];
    albumArtImageView.layer.backgroundColor = [NSColor purpleColor].CGColor;
    
    [self setupDataFields];
    

    

    if(![[NSUserDefaults standardUserDefaults] boolForKey: @"InitialSetupComplete"]) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView: self.window.contentView];
        progressHUD.labelText = @"Setting Up...";
        [self.window.contentView addSubview: progressHUD];
        [progressHUD showWhileExecuting: @selector(doInitialSetup) onTarget: self withObject: nil animated: YES];
        
        [[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"InitialSetupComplete"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
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



- (void)cleanUpAfterExport {
    
    self.dropSongView.hidden = NO;
    
    [self.window.contentView addSubview: dropSongView];

    
    albumArtImageView.image = nil;
    [albumArtImageView removeFromSuperview];
    songTitleField.stringValue = @"";
    albumTitleField.stringValue = @"";
    artistField.stringValue = @"";
    yearField.stringValue = @"";
    fileLocation = @"";
    songDictionary = nil;
    
    
}


#pragma mark - Actions



- (void)search {
    
    progressHUD = [[MBProgressHUD alloc] initWithView: self.window.contentView];
    progressHUD.labelText = @"Searching...";
    [self.window.contentView addSubview: progressHUD];
    [progressHUD showWhileExecuting: @selector(performSearch) onTarget: self withObject: nil animated: YES];
}



- (void)performSearch {
    
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
    
    
    // If no search results are found
    if([[results objectForKey: @"resultCount"] integerValue] == 0) {
        
        [self performSelectorOnMainThread: @selector(showAlertWithData:) withObject: @[@"No search results found", @"Adjust your query and try again"] waitUntilDone: YES];
        
        return;
    }
    
    
    songSelectorWindow = [[NSWindow alloc] init];
    [songSelectorWindow setFrame: NSMakeRect(self.window.frame.origin.x+330, 100, 500, 300) display: YES animate: YES];
    songSelectorWindow.opaque = NO;
    songSelectorWindow.alphaValue = .95f;
    
    songSelector = [[SongSelectorWindowController alloc] initWithWindow: songSelectorWindow usingDelegate: self];
    songSelector.resultDictionary = results;
    [songSelector showWindow: songSelectorWindow];

}


- (void)saveAndExport {
    
    progressHUD = [[MBProgressHUD alloc] initWithView: self.window.contentView];
    progressHUD.labelText = @"Saving Changes...";
    [self.window.contentView addSubview: progressHUD];
    [progressHUD showWhileExecuting: @selector(performSaveAndExport) onTarget: self withObject: nil animated: YES];
}



- (void)performSaveAndExport {
    
    
    // If the user selected "Save and Export" without dropping a song
    if(fileLocation.length == 0) {
        
        [self performSelectorOnMainThread: @selector(showAlertWithData:) withObject: @[@"Error", @"You haven't selected a file yet."] waitUntilDone: YES];
        
        return;
    }
    
    
    
    NSURL *imageURL = [NSURL URLWithString: [songDictionary objectForKey: @"artworkUrl600"]];
    NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
    char *minetype = get_mime_type_from_filename([[songDictionary objectForKey: @"artworkUrl600"] UTF8String]);
    
    
    
    //ID3v2_tag* tag = load_tag(fileLocation.UTF8String); // Load the full tag from the file
    ID3v2_tag* tag = new_tag();
    
    
    // Set the new info
    tag_set_title((char *)songTitleField.stringValue.UTF8String, 0, tag);
    tag_set_artist((char *)artistField.stringValue.UTF8String, 0, tag);
    tag_set_album_artist((char *)artistField.stringValue.UTF8String, 0, tag);
    tag_set_genre((char *)[[songDictionary objectForKey: @"primaryGenreName"] UTF8String], 0, tag);
    tag_set_album((char *)albumTitleField.stringValue.UTF8String, 0, tag);
    tag_set_year((char *)yearField.stringValue.UTF8String, 0, tag);
    tag_set_album_cover_from_bytes((char *)[imageData bytes], minetype, (int)[imageData length], tag);
    
    // Write the new tag to the file
    set_tag(fileLocation.UTF8String, tag);
    
    
    
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = @"Exporting to iTunes...";
    
    
    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    [iTunes add:[NSArray arrayWithObject:[NSURL fileURLWithPath:fileLocation]] to: nil];
    
    
    NSLog(@"Export complete");
    
    
    // UIImageView is a UIKit class, we have to initialize it on the main thread
    __block NSImageView *imageView;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSImage *image = [NSImage imageNamed:@"checkmark.png"];
        imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 37.0f, 37.0f)];
        imageView.image = image;
    });
    progressHUD.customView = imageView;
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.labelText = @"Export Complete!";
    sleep(2);
    
    [self cleanUpAfterExport];
}





- (void)searchYouTube:(NSString *)url {
    
    progressHUD = [[MBProgressHUD alloc] initWithView: self.window.contentView];
    progressHUD.labelText = @"Fetching Song...";
    [self.window.contentView addSubview: progressHUD];
    [progressHUD showWhileExecuting: @selector(performYouTubeSearchAndDownload:) onTarget: self withObject: url animated: YES];
}



- (void)performYouTubeSearchAndDownload:(NSString *)url {
    
    
    NSURL *conversionURL = [NSURL URLWithString: [@"http://YouTubeInMP3.com/fetch/?format=JSON&video=[URL]" stringByReplacingOccurrencesOfString: @"[URL]" withString: url]];
    NSLog(@"Con URL: %@", conversionURL);
    
    // Download the song
    NSError *error;
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: conversionURL];
    [req setHTTPMethod: @"GET"];
    [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    
    // Get the JSON and parse it
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: req returningResponse: &response error: &error];
    NSDictionary * results = [NSJSONSerialization JSONObjectWithData: responseData options:kNilOptions error: &error];
    
    if(results == nil) {
        
        progressHUD.mode = MBProgressHUDModeText;
        progressHUD.labelText = @"Error Downloading video";
        NSLog(@"Response: %@", response);
        NSLog(@"Results: %@", results);
        sleep(1);
        return;
    }
    
    
    //NSLog(@"Results: %@", results);
    
    
    NSString *songTitle = [[results objectForKey: @"title"] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
    //songTitle = [songTitle stringByReplacingOccurrencesOfString: @" " withString: @""];
    songTitle = [songTitle stringByReplacingOccurrencesOfString: @"/" withString: @""];

    
    
    NSString *downloadLocation = [NSString stringWithFormat: @"%@/%@.mp3", METAHUB_DOWNLOADS_LOCATION, songTitle];
    NSString *downloadLink = [[results objectForKey: @"link"] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
    
    
    NSLog(@"Download loc: %@", downloadLocation);
    NSLog(@"Download link: %@", downloadLink);
    NSLog(@"Song Title: %@", songTitle);
    
    
    
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = @"Downloading song...";
    
    // Download song
    if([[NSFileManager defaultManager] createFileAtPath: downloadLocation
                                               contents: [NSData dataWithContentsOfURL:[NSURL URLWithString: downloadLink]] attributes: nil]) {
        
        NSLog(@"Download Complete");
        
        
        // UIImageView is a UIKit class, we have to initialize it on the main thread
        __block NSImageView *imageView;
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSImage *image = [NSImage imageNamed:@"checkmark.png"];
            imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 37.0f, 37.0f)];
            imageView.image = image;
        });
        progressHUD.customView = imageView;
        progressHUD.mode = MBProgressHUDModeCustomView;
        progressHUD.labelText = @"Download Complete!";
        sleep(0.5);
        
        
        
        fileLocation = downloadLocation;
        
        NSLog(@"Title: %@", [results objectForKey: @"title"]);
        songTitleField.stringValue = [[results objectForKey: @"title"] stringByReplacingOccurrencesOfString: @"\"" withString: @""];
        
        
    }
    
}



#pragma mark - Utilities


// Called for drag and drop
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
    
    //NSLog (@"dictionary: %@", dic);


    songTitleField.stringValue = [dic objectForKey: @"title"] == nil ? @"" : [dic objectForKey: @"title"];
    albumTitleField.stringValue = [dic objectForKey: @"album"] == nil ? @"" : [dic objectForKey: @"album"];
    artistField.stringValue = [dic objectForKey: @"artist"] == nil ? @"" : [dic objectForKey: @"artist"];
    yearField.stringValue = [dic objectForKey: @"year"] == nil ? @"" : [dic objectForKey: @"year"];;
    
    
    CFRelease (dictionary);
    theErr = AudioFileClose (audioFile);
    assert (theErr == noErr);
    
}


// Called after song is selected from search results
- (void)songSelected:(NSDictionary *)songDict {
    
    
    self.dropSongView.hidden = YES;
    
    
    
    
    songDictionary = [NSMutableDictionary dictionaryWithDictionary: songDict];
    
    
    NSString *lowResAlbumArt = [songDictionary objectForKey: @"artworkUrl100"];
    NSString *highResAlbumArt = [lowResAlbumArt stringByReplacingOccurrencesOfString: @"100x100" withString: @"600x600"];
    
    
    [songDictionary setObject: highResAlbumArt forKey: @"artworkUrl600"];
    
    //NSLog(@"Song Selected: %@", songDictionary);
    
    
    NSURL *imageURL = [NSURL URLWithString: [songDictionary objectForKey: @"artworkUrl600"]];
    NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
    NSImage *imageFromBundle = [[NSImage alloc] initWithData:imageData];
    albumArtImageView.image = imageFromBundle;
    albumArtImageView.imageScaling = NSImageScaleAxesIndependently;
    [self.window.contentView addSubview: albumArtImageView];
    
    songTitleField.stringValue = [songDictionary objectForKey: @"trackName"];
    albumTitleField.stringValue = [songDictionary objectForKey: @"collectionName"];
    artistField.stringValue = [songDictionary objectForKey: @"artistName"];
    yearField.stringValue = [[songDictionary objectForKey: @"releaseDate"] substringToIndex: 4];
}





- (void)doInitialSetup {
    
    

    //NSLog(@"URL: %@", METAHUB_DOWNLOADS_LOCATION);
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:METAHUB_DOC_LOCATION]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath: METAHUB_DOC_LOCATION withIntermediateDirectories: YES attributes: nil error: nil];
        
    }
    
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath: METAHUB_DOWNLOADS_LOCATION]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath: METAHUB_DOWNLOADS_LOCATION withIntermediateDirectories: YES attributes: nil error: nil];
    }
    
}



- (void)showAlertWithData:(NSArray *)array {
    
    NSString *title = [array objectAtIndex: 0];
    NSString *details = [array objectAtIndex: 1];
    
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText: title];
    [alert setInformativeText: details];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
}




@end
