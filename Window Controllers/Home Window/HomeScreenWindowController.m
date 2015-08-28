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
    

    if(fileLocation.length == 0) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Error"];
        [alert setInformativeText:@"You haven't selected a file yet."];
        [alert addButtonWithTitle:@"Ok"];
        [alert runModal];
        
        
        return;
        
    }
    [self store];
    return;
    
 /*
    NSURL *audioURL = [[NSURL alloc] initFileURLWithPath: fileLocation];
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
    
    
    
    //NSMutableDictionary *dic = (__bridge NSMutableDictionary*)dictionary;
    
   // NSLog (@"dictionary: %@", dic);
    
  
    
    
//    NSMutableDictionary *newDic = [NSMutableDictionary new];
//    [newDic setObject: albumTitleField.stringValue forKey: @"album"];
//    [newDic setObject: artistField.stringValue forKey: @"artist"];
//    [newDic setObject: songTitleField.stringValue forKey: @"title"];
//    [newDic setObject: yearField.stringValue forKey: @"year"];
    
    
    //CFDictionaryRef newDicRef = (__bridge CFDictionaryRef)newDic;
*/
    
   
   // NSURL *audioURL1 = [[NSURL alloc] initFileURLWithPath: fileLocation];
    //AudioFileID audioFile1;
    
    /*OSStatus theErr1 = noErr;
    theErr1 = AudioFileOpenURL((__bridge CFURLRef)audioURL, kAudioFileWritePermission, 0, &audioFile);
    
    
    
    assert (theErr1 == noErr);
    UInt32 dictionarySize1 = 0;
    theErr = AudioFileGetPropertyInfo (audioFile,
                                       kAudioFilePropertyInfoDictionary,
                                       &dictionarySize,
                                       0);
    
    //AudioFileGetProperty(<#AudioFileID inAudioFile#>, <#AudioFilePropertyID inPropertyID#>, <#UInt32 *ioDataSize#>, <#void *outPropertyData#>)
    theErr = AudioFileSetProperty(audioFile1, kAudioFilePropertyInfoDictionary, dictionarySize1, &dictionary);
    */
    
    
    /*
    
    AudioFileID fileID = nil;
    AudioFileOpenURL((__bridge CFURLRef) audioURL1, kAudioFileReadWritePermission, 0, &fileID);
    CFDictionaryRef piDict = nil;
    UInt32 piDataSize   = sizeof(piDict);
    AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
    NSLog(@"Before: %@", (__bridge NSDictionary *)piDict);
    
    NSMutableDictionary *dict = (__bridge NSMutableDictionary*)piDict;
    [dict setObject: albumTitleField.stringValue forKey: @"album"];
    [dict setObject: artistField.stringValue forKey: @"artist"];
    [dict setObject: songTitleField.stringValue forKey: @"title"];
    [dict setObject: yearField.stringValue forKey: @"year"];
    piDict = (__bridge CFDictionaryRef)dict;
    piDataSize = sizeof(dict);
    OSStatus status = AudioFileSetProperty(fileID, kAudioFilePropertyInfoDictionary, piDataSize, &piDict);
    
    NSLog(@"After: %@", (__bridge NSDictionary *)piDict);
    
    
    NSError *error = [NSError errorWithDomain: NSOSStatusErrorDomain code:status userInfo:nil];
    NSLog(@"Error: %@", [error description]);
    
    
    
    CFRelease (piDict);
    OSStatus status1 = AudioFileClose (fileID);
    NSError *error1 = [NSError errorWithDomain: NSOSStatusErrorDomain code:status1 userInfo:nil];
    NSLog(@"Error1: %@", error1);
    //assert (theErr == noErr);
 */
}



- (void)store {
    
    
    NSLog(@"File Location: %@", fileLocation);
    
    NSError *error;
    AVAssetWriter *assetWrtr = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath: fileLocation] fileType:AVFileTypeAppleM4A error:&error];
    
    NSLog(@"Error: %@",error);
    
    NSArray *existingMetadataArray = assetWrtr.metadata;
    NSMutableArray *newMetadataArray = nil;
    NSLog(@"The Data: %@", existingMetadataArray);
    if (existingMetadataArray)
    {
       
        NSLog(@"Existing Metadata: %@", [existingMetadataArray mutableCopy]);
        newMetadataArray = [existingMetadataArray mutableCopy]; // To prevent overriding of existing metadata
    }
    else
    {
        newMetadataArray = [[NSMutableArray alloc] init];
    }
    
//
//    AVMutableMetadataItem *item = [[AVMutableMetadataItem alloc] init];
//    item.keySpace = AVMetadataKeySpaceCommon;
//    item.key = AVMetadataCommonKeyArtwork;
//    item.value = [NSData dataWithContentsOfURL: [NSURL URLWithString: [songDictionary objectForKey: @"artworkUrl100"]]];
//    [newMetadataArray addObject:item];
//
    
    
    AVMutableMetadataItem *titleItem = [[AVMutableMetadataItem alloc] init];
    titleItem.keySpace = AVMetadataKeySpaceCommon;
    titleItem.key = AVMetadataCommonKeyTitle;
    titleItem.value = songTitleField.stringValue;
    [newMetadataArray addObject:titleItem];

    
    
    AVMutableMetadataItem *artistItem = [[AVMutableMetadataItem alloc] init];
    artistItem.keySpace = AVMetadataKeySpaceCommon;
    artistItem.key = AVMetadataCommonKeyArtist;
    artistItem.value = artistField.stringValue;
    [newMetadataArray addObject: artistItem];

    
    
    AVMutableMetadataItem *albumItem = [[AVMutableMetadataItem alloc] init];
    albumItem.keySpace = AVMetadataKeySpaceCommon;
    albumItem.key = AVMetadataCommonKeyAlbumName;
    albumItem.value = albumTitleField.stringValue;
    [newMetadataArray addObject: albumItem];

    
   
    AVMutableMetadataItem *creationDateItem = [[AVMutableMetadataItem alloc] init];
    creationDateItem.keySpace = AVMetadataKeySpaceCommon;
    creationDateItem.key = AVMetadataCommonKeyCreationDate;
    creationDateItem.value = yearField.stringValue;
    [newMetadataArray addObject:creationDateItem];

    
    assetWrtr.metadata = newMetadataArray;
    
    
    
    [assetWrtr startWriting];
    [assetWrtr startSessionAtSourceTime:kCMTimeZero];
    
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
    
    
    //NSDictionary *original = [NSDictionary dictionaryWithObject:@"World" forKey:@"Hello"];
    //CFDictionaryRef dict = (__bridge CFDictionaryRef)original;
    //NSDictionary *andBack = (__bridge NSDictionary*)dict;
    //NSLog(@"%@", andBack);
    
    
    
    //[self getAlbumArtworkInfo: audioURL];
}









- (void)getAlbumArtworkInfo:(NSURL *)url
{

    
    AVURLAsset *avURLAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    for (NSString *format in [avURLAsset availableMetadataFormats]) {
        
        for (AVMutableMetadataItem *metadataItem in [avURLAsset metadataForFormat:format]) {
            
            
 
            NSLog(@"Data: %@\t%@", metadataItem.commonKey, metadataItem.value);
            
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
    NSData *imageData = [imageURL resourceDataUsingCache: YES];
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
