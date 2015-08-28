//
//  SongSelector.m
//  
//
//  Created by Preston Brown on 8/27/15.
//
//

#import "SongSelectorWindowController.h"

@interface SongSelectorWindowController ()


@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSTableView *songTableView;

@end



@implementation SongSelectorWindowController



@synthesize delegate, resultDictionary, songTableView, results;



- (instancetype)initWithWindow:(NSWindow *)window usingDelegate:(id)__delegate {
    
    
    if(self = [super initWithWindow: window]) {
        
        delegate = __delegate;
    }
    
    return self;
}



- (void)showWindow:(id)sender {

    
    
    [super showWindow: sender];
    
    
    
    self.window.titlebarAppearsTransparent = YES;
    
    
    
    
    NSScrollView *tableContainer = [[NSScrollView alloc] initWithFrame: NSMakeRect(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    NSTableColumn *firstColumn = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
    firstColumn.width = 400;
    [[firstColumn headerCell] setStringValue: @""];
    
    
    songTableView = [[NSTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
    songTableView.delegate = self;
    songTableView.dataSource = self;
    [tableContainer setDocumentView: songTableView];
    [songTableView addTableColumn: firstColumn];
    [tableContainer setHasVerticalScroller:YES];
    //tableContainer.autoresizingMask = NSViewHeightSizable | NSViewMinXMargin;
    [self.window.contentView addSubview: tableContainer];
    
    
    
    
    
    
    results = [resultDictionary objectForKey: @"results"];
    
    [songTableView reloadData];
    
    NSLog(@"Data: %li", results.count);
}






#pragma mark - NSTableView



-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return results.count;
}


-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    return 100;
}



-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    
    NSView *view = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    
    
    //[tableView setTarget: self];
    //[tableView setAction: @selector(click)];
    
    if (view == nil) {
        

        
        NSDictionary *currentSong = [results objectAtIndex: row];
        NSLog(@"Current Song: %@", currentSong);
        
        view = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, 400, 10)];
        [view setWantsLayer: YES];
        
        NSImageView *albumArtImageView = [[NSImageView alloc] initWithFrame: CGRectMake(10, 10, 80, 80)];
        NSURL *imageURL = [NSURL URLWithString: [currentSong objectForKey: @"artworkUrl100"]];
        NSData *imageData = [imageURL resourceDataUsingCache: YES];
        NSImage *imageFromBundle = [[NSImage alloc] initWithData:imageData];
        albumArtImageView.image = imageFromBundle;
        [albumArtImageView setWantsLayer: YES];
        //albumArtImageView.layer.backgroundColor = [NSColor greenColor].CGColor;
        
        [view addSubview: albumArtImageView];
        
        
        
        
        
        NSTextField *titleField = [[NSTextField alloc] initWithFrame:NSMakeRect(90, 50, 290, 50)];
        titleField.stringValue = [currentSong objectForKey: @"trackName"];
        titleField.backgroundColor = [NSColor orangeColor];
        titleField.font = [NSFont fontWithName: @"HelveticaNeue-Light" size: 18];
        titleField.editable = NO;
        titleField.selectable = NO;
        titleField.bordered = NO;
        [view addSubview:titleField];
        
        
        NSTextField *artistField = [[NSTextField alloc] initWithFrame:NSMakeRect(90, 10, 290, 30)];
        artistField.stringValue = [currentSong objectForKey: @"artistName"];
        artistField.backgroundColor = [NSColor orangeColor];
        artistField.font = [NSFont fontWithName: @"HelveticaNeue-Light" size: 18];
        artistField.editable = NO;
        artistField.selectable = NO;
        artistField.bordered = NO;
        [view addSubview: artistField];
        
        [view setNeedsDisplay:YES];
    }
    
    return view;
    
}







@end
