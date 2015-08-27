//
//  DropSongView.h
//  
//
//  Created by Preston Brown on 8/26/15.
//
//

#import <Cocoa/Cocoa.h>



@interface DropSongView : NSView


// Constructor
- (instancetype)initWithFrame:(NSRect)frameRect withDelegate: (id)__delegate;




@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSImageView *addImageView;
@property (nonatomic, strong) NSTextField *addSongTextField;

@end
