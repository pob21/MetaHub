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
    
    NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton];
    [closeButton setHidden:YES];
    
    self.window.titlebarAppearsTransparent = YES;
    self.window.title = @"Search Results";
    
    
    
    NSScrollView *tableContainer = [[NSScrollView alloc] initWithFrame: NSMakeRect(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    NSTableColumn *firstColumn = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
    firstColumn.width = 500;
    [[firstColumn headerCell] setStringValue: @""];
    
    
    songTableView = [[NSTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
    songTableView.delegate = self;
    songTableView.dataSource = self;
    [tableContainer setDocumentView: songTableView];
    [songTableView addTableColumn: firstColumn];
    [tableContainer setHasVerticalScroller:YES];

    [self.window.contentView addSubview: tableContainer];
    
    
    results = [resultDictionary objectForKey: @"results"];
    
    [songTableView reloadData];
}




#pragma mark - Actions



- (void)albumSelected:(id)sender {
    
    NSButton *button = (NSButton *)sender;
    
    
    NSDictionary *song = [results objectAtIndex: button.tag];
    

    [delegate performSelector: @selector(songSelected:) withObject: song];
    
    
    [self close];
}






#pragma mark - NSTableView



-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return results.count;
}


-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    return 120;
}



-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    
    NSView *view = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    

    if (view == nil) {
        

        
        NSDictionary *currentSong = [results objectAtIndex: row];

        
        view = [[NSView alloc]initWithFrame:NSMakeRect(0, 0, 500, 10)];
        [view setWantsLayer: YES];
        
        NSImageView *albumArtImageView = [[NSImageView alloc] initWithFrame: CGRectMake(10, 30, 80, 80)];
        NSURL *imageURL = [NSURL URLWithString: [currentSong objectForKey: @"artworkUrl100"]];
        NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
        NSImage *imageFromBundle = [[NSImage alloc] initWithData:imageData];
        albumArtImageView.image = imageFromBundle;
        [albumArtImageView setWantsLayer: YES];
        //albumArtImageView.layer.backgroundColor = [NSColor greenColor].CGColor;
        
        [view addSubview: albumArtImageView];
        
        NSButton *selectButton = [[NSButton alloc] initWithFrame: NSMakeRect(10, 0, 80, 30)];
        [selectButton setTitle: @"Select"];
        selectButton.bordered = NO;
        [selectButton setWantsLayer: YES];
        selectButton.tag = row;
        selectButton.layer.backgroundColor = [NSColor colorWithRed:0.26 green:0.81 blue:0.49 alpha:1].CGColor;
        [selectButton setTarget: self];
        [selectButton setAction: @selector(albumSelected:)];
        [view addSubview: selectButton];
        
        
        
        NSTextField *titleField = [[NSTextField alloc] initWithFrame:NSMakeRect(90, 65, 390, 50)];
        titleField.stringValue = [currentSong objectForKey: @"trackName"];
        titleField.backgroundColor = [NSColor clearColor];
        titleField.font = [NSFont fontWithName: @"HelveticaNeue-Light" size: 18];
        titleField.editable = NO;
        titleField.selectable = NO;
        titleField.bordered = NO;
        [view addSubview:titleField];
        
        
        NSTextField *artistField = [[NSTextField alloc] initWithFrame:NSMakeRect(90, 35, 410, 30)];
        artistField.stringValue = [currentSong objectForKey: @"artistName"];
        artistField.backgroundColor = [NSColor clearColor];
        artistField.font = [NSFont fontWithName: @"HelveticaNeue-Light" size: 18];
        artistField.editable = NO;
        artistField.selectable = NO;
        artistField.bordered = NO;
        [view addSubview: artistField];

        
        NSString *year = [[currentSong objectForKey: @"releaseDate"] substringToIndex: 4];
        
        NSTextField *albumField = [[NSTextField alloc] initWithFrame:NSMakeRect(90, 5, 390, 30)];
        albumField.stringValue = [NSString stringWithFormat: @"%@ • %@", [currentSong objectForKey: @"collectionName"], year];
        albumField.backgroundColor = [NSColor clearColor];
        albumField.font = [NSFont fontWithName: @"HelveticaNeue-Light" size: 14];
        albumField.editable = NO;
        albumField.selectable = NO;
        albumField.bordered = NO;
        [view addSubview: albumField];

        
        [view setNeedsDisplay:YES];
    }
    
    return view;
}







@end
