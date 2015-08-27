//
//  DropSongView.m
//  
//
//  Created by Preston Brown on 8/26/15.
//
//

#import "DropSongView.h"

@implementation DropSongView

@synthesize addImageView, addSongTextField, delegate;

- (instancetype)initWithFrame:(NSRect)frameRect withDelegate: (id)__delegate {
    
    if(self = [super initWithFrame: frameRect]) {
        
        delegate = __delegate;
        
        [self setWantsLayer: YES];
        self.layer.backgroundColor = [NSColor colorWithRed:0.11 green:0.48 blue:0.69 alpha:1].CGColor;
        
        
        addImageView = [[NSImageView alloc] initWithFrame: NSMakeRect((self.frame.size.width/2)-50, (self.frame.size.height/2)-50, 100, 100)];
        [addImageView setWantsLayer: YES];

        addImageView.image = [NSImage imageNamed: @"add-icon.png"];
        addImageView.imageScaling = NSImageScaleAxesIndependently;
        [self addSubview: addImageView];
        
        
        addSongTextField = [[NSTextField alloc] initWithFrame: NSMakeRect(50, 30, 200, 40)];
        addSongTextField.alignment = NSCenterTextAlignment;
        addSongTextField.editable = NO;
        addSongTextField.backgroundColor = [NSColor colorWithRed:0.11 green:0.48 blue:0.69 alpha:1];
        addSongTextField.font = [NSFont fontWithName: @"HelveticaNeue-Thin" size: 25];
        addSongTextField.stringValue = @"Drop Song Here";
        addSongTextField.bordered = NO;
        [self addSubview: addSongTextField];
        
        
        
        
        
        [self registerForDraggedTypes:[NSArray arrayWithObjects:
                                       NSColorPboardType, NSFilenamesPboardType, nil]];
        
    }
    
    return self;
}



- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}






#pragma mark - Drag & Drop




- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if ( [[pboard types] containsObject:NSColorPboardType] ) {
        if (sourceDragMask & NSDragOperationGeneric) {
            return NSDragOperationGeneric;
        }
    }
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        } else if (sourceDragMask & NSDragOperationCopy) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}



- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    
    if ( [[pboard types] containsObject:NSColorPboardType] ) {
       
        
    }
    
    else if ([[pboard types] containsObject:NSFilenamesPboardType] ) {
        
        
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        //NSLog(@"Files: %@", files);

        if (sourceDragMask & NSDragOperationLink) {
            

            //[self addLinkToFiles:files];
            
            [delegate performSelector: @selector(linkSongInArray:) withObject: files];
            
        }
        
        
        else {

            //[self addDataFromFiles:files];
        }
    }
    return YES;
}



@end
