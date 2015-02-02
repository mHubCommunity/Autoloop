//
//  ViewController.h
//  Autoloop
//
//  Created by Josh Billions on 2/1/15.
//  Copyright (c) 2015 Catalyze Chicago. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSGridView;

@interface ViewController : UIViewController

@property (nonatomic, assign) IBOutlet MSGridView *gridView;
@property (nonatomic, assign) IBOutlet UIButton *startStopButton;
@property (nonatomic, assign) IBOutlet UILabel *bpmLabel;
@property (nonatomic, assign) IBOutlet UISlider *bpmSlider;

-(IBAction)startStopTapped:(id)sender;
-(IBAction)sliderChanged:(id)sender;

@end

