//
//  SequencerController.m
//  Autoloop
//
//  Created by Josh Billions on 2/1/15.
//  Copyright (c) 2015 Catalyze Chicago. All rights reserved.
//

#import "SequencerController.h"
#import "MSGridView.h"
#import "MSGridViewCell.h"


@interface SequencerController(){
    int currentPosition;
    int maxPosition;
}

@end

@implementation SequencerController

-(id)init{
    if(self = [super init]){
        currentPosition = 0;
        NSUInteger columns = [[self.gridView gridViewDataSource] numberOfGridColumns];
        for(int i = 0; i < columns; i++){
            NSIndexPath *columnSearcher = [NSIndexPath indexPathForRow:1 inSection:i];
            maxPosition += [[self.gridView gridViewDataSource] numberOfColumnsForGridAtIndexPath:columnSearcher];
        }
        NSLog(@"maxPosition: %i", maxPosition);
    }
    
    return self;
}

-(void)colorCurrentColumn{
    
}

@end
