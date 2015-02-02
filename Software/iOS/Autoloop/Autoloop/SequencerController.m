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
#import "NetworkController.h"


@interface SequencerController(){
    BOOL currentlyActive;
    NSUInteger currentPosition;
    NSUInteger maxColumns;
    NSUInteger maxRows;
    NSTimer *sequencerTimer;
    UIColor *onColor;
    UIColor *offColor;
    
    NSUInteger drumSwitches[7];
}

-(void)advanceSequencer;
-(void)setColumn:(NSUInteger)column withTintColor:(UIColor *)color;
-(void)checkIndexPathForActiveInstruments:(NSIndexPath *)indexPath;

@end

@implementation SequencerController

-(id)init{
    if(self = [super init]){
        currentlyActive = NO;
        self.currentBPM = @120;
        currentPosition = 0;
        maxColumns = 16;
        maxRows = 9;
        onColor = [UIColor yellowColor];
        offColor = [UIColor darkGrayColor];
    }
    return self;
}

-(void)advanceSequencer{
    if (currentPosition == maxColumns) {
        [self setColumn:maxColumns-1 withTintColor:offColor];
        currentPosition = 0;
    }else if(currentPosition > 0){
        [self setColumn:currentPosition-1 withTintColor:offColor];
    }
    [self setColumn:currentPosition withTintColor:onColor];
    currentPosition++;
}

-(void)setColumn:(NSUInteger)column withTintColor:(UIColor *)color{
    for(int i  = 0; i < maxRows; i++){
        const NSUInteger pathArray[4] = {0, 0, i, column};
        NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:pathArray length:4];
        
        MSGridViewCell *cell = [self.gridView cellAtIndexPath:path];
        cell.layer.borderWidth = 2.0f;
        cell.layer.borderColor = color.CGColor;
        
        //Make sure that the cell is active, and we're not just removing the old border color
        if (cell.active && column == currentPosition) {
            [self checkIndexPathForActiveInstruments:path];
        }
    }
}

-(void)setCurrentBPM:(NSNumber *)currentBPM{
    _currentBPM = currentBPM;
    if(currentlyActive){
        [sequencerTimer invalidate];
        sequencerTimer = [NSTimer scheduledTimerWithTimeInterval:60/self.currentBPM.doubleValue target:self selector:@selector(advanceSequencer) userInfo:nil repeats:YES];
    }
}

-(void)startStopToggled{
    if (currentlyActive) {
        [self setColumn:currentPosition-1 withTintColor:offColor];
        currentlyActive = NO;
        [sequencerTimer invalidate];
        currentPosition = 0;
    }else{
        currentPosition = 0;
        currentlyActive = YES;
        sequencerTimer = [NSTimer scheduledTimerWithTimeInterval:60/self.currentBPM.doubleValue target:self selector:@selector(advanceSequencer) userInfo:nil repeats:YES];
    }
    
}

-(void)checkIndexPathForActiveInstruments:(NSIndexPath *)indexPath{
    MSGridViewCell *cell = [self.gridView cellAtIndexPath:indexPath];
    if (cell.active) {
        switch ([indexPath indexAtPosition:2] ) {
            case 0:{
                [[NetworkController sharedInstance] sendMessage:@"12"];
                break;
            }
                
            case 1:{
                [[NetworkController sharedInstance] sendMessage:@"14"];
                break;
            }
                
            case 2:{
                if (drumSwitches[0] == 0) {
                    [[NetworkController sharedInstance] sendMessage:@"15"];
                    drumSwitches[0] = 1;
                }else{
                    [[NetworkController sharedInstance] sendMessage:@"23"];
                    drumSwitches[0] = 0;
                }
                break;
            }
                
            case 3:{
                if (drumSwitches[1] == 0) {
                    [[NetworkController sharedInstance] sendMessage:@"27"];
                    drumSwitches[1] = 1;
                }else{
                    [[NetworkController sharedInstance] sendMessage:@"28"];
                    drumSwitches[1] = 0;
                }
                break;
            }
                
            case 4:{
                if (drumSwitches[2] == 0) {
                    [[NetworkController sharedInstance] sendMessage:@"21"];
                    drumSwitches[2] = 1;
                }else{
                    [[NetworkController sharedInstance] sendMessage:@"24"];
                    drumSwitches[2] = 0;
                }
                break;
            }
                
            case 5:{
                if (drumSwitches[3] == 0) {
                    [[NetworkController sharedInstance] sendMessage:@"18"];
                    drumSwitches[3] = 1;
                }else{
                    [[NetworkController sharedInstance] sendMessage:@"25"];
                    drumSwitches[3] = 0;
                }
                break;
            }
                
            case 6:{
                if (drumSwitches[4] == 0) {
                    [[NetworkController sharedInstance] sendMessage:@"19"];
                    drumSwitches[4] = 1;
                }else{
                    [[NetworkController sharedInstance] sendMessage:@"20"];
                    drumSwitches[4] = 0;
                }
                break;
            }
                
            case 7:{
                if (drumSwitches[5] == 0) {
                    [[NetworkController sharedInstance] sendMessage:@"26"];
                    drumSwitches[5] = 1;
                }else{
                    [[NetworkController sharedInstance] sendMessage:@"17"];
                    drumSwitches[5] = 0;
                }
                break;
            }
                
            case 8:{
                if (drumSwitches[6] == 0) {
                    [[NetworkController sharedInstance] sendMessage:@"16"];
                    drumSwitches[6] = 1;
                }else{
                    [[NetworkController sharedInstance] sendMessage:@"22"];
                    drumSwitches[6] = 0;
                }
                break;
            }
                
            default:
                break;
        }
    }
}

@end
