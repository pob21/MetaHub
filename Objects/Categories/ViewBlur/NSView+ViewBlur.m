//
//  NSView+ViewBlur.m
//  CineFile
//
//  Created by Preston Brown on 10/11/14.
//  Copyright (c) 2014 Dream Flow Studios. All rights reserved.
//

#import "NSView+ViewBlur.h"

@implementation NSView (ViewBlur)


-(instancetype) insertVibrancyViewBlendingMode: (NSVisualEffectBlendingMode)mode {
    
    Class vibrantClass = NSClassFromString(@"NSVisualEffectView");
    
    if(vibrantClass) {
        
        NSVisualEffectView *vibrant = [[vibrantClass alloc] initWithFrame: self.bounds];
        [vibrant setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
        [vibrant setBlendingMode: mode];
        [self addSubview: vibrant positioned: NSWindowBelow relativeTo: nil];
        
        return  vibrant;
    }
    
    return nil;
}


@end
