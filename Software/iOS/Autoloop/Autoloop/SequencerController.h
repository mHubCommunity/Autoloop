//
//  SequencerController.h
//  Autoloop
//
//  Created by Josh Billions on 2/1/15.
//  Copyright (c) 2015 Catalyze Chicago. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSGridView;

@interface SequencerController : NSObject

@property (nonatomic, weak) MSGridView *gridView;
@property (nonatomic, strong) NSNumber *currentBPM;

-(void)startStopToggled;

@end


/*

 0      Small Cymbal            12
 1      Big Cymbal              14
 2      Cow Bell                15  23
 3      Miraca                  27  28
 4      Snare Drum              21  24
 5      Small Drum              18  25
 6      Medium Drum             19  20
 7      Big Drum                26  17
 8      Bass Drum               16  22

*/