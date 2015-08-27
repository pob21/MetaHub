//
//  HomeWindowController.m
//  
//
//  Created by Preston Brown on 8/26/15.
//
//

#import "HomeWindowController.h"

@interface HomeWindowController ()

@end



@implementation HomeWindowController


@synthesize pasteSongView;


- (void)windowDidLoad {

    [super windowDidLoad];
}




- (void)showWindow:(id)sender {
    
    [super showWindow: sender];


    
    self.window.titlebarAppearsTransparent = YES;
    
    
   // [self.window registerForDraggedTypes:[NSArray arrayWithObjects:
                                  // NSColorPboardType, NSFilenamesPboardType, nil]];
    
    
    pasteSongView = [[PasteSongView alloc] initWithFrame: NSMakeRect(self.window.frame.size.width/2, self.window.frame.size.height/2, 100, 100)];
    pasteSongView.layer.backgroundColor = [NSColor colorWithRed:0.11 green:0.48 blue:0.69 alpha:1].CGColor;
    
    [self.window.contentView addSubview: pasteSongView];
    
    
    
    NSView *searchBarAndButton  = [[NSView alloc] initWithFrame: NSMakeRect(0, self.window.frame.size.height-55, 300, 200)];
    searchBarAndButton.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self.window.contentView addSubview: searchBarAndButton];
}



- (void)testAudio {
    
    
    //[[NSBundle mainBundle] URLForResource: @"08 G.O.M.D." withExtension: @"m4a"];
    
    // NSString *audioFilePath = [[NSString stringWithUTF8String:argv[1]];
    //  stringByExpandingTildeInPath];
    
    
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource: @"08 G.O.M.D." withExtension: @"m4a"];
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
    [dic setValue: @"Good Shit" forKey: @"genre"];
    
    dictionary = (__bridge CFDictionaryRef)dic;
    
    theErr = AudioFileSetProperty(audioFile,
                                  kAudioFilePropertyInfoDictionary,  dictionarySize, &dictionary);
    
    
    
    CFRelease (dictionary);
    theErr = AudioFileClose (audioFile);
    assert (theErr == noErr);
    
    
    //NSDictionary *original = [NSDictionary dictionaryWithObject:@"World" forKey:@"Hello"];
    //CFDictionaryRef dict = (__bridge CFDictionaryRef)original;
    //NSDictionary *andBack = (__bridge NSDictionary*)dict;
    //NSLog(@"%@", andBack);
    
}








@end
