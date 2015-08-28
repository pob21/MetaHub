//
//  SongSelector.h
//  
//
//  Created by Preston Brown on 8/27/15.
//
//

#import <Cocoa/Cocoa.h>

@interface SongSelectorWindowController : NSWindowController <NSTableViewDataSource, NSTableViewDelegate>



// Constructor
- (instancetype)initWithWindow:(NSWindow *)window usingDelegate:(id)__delegate;



@property (nonatomic, strong) NSDictionary *resultDictionary;


@end
