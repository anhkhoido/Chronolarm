//
//  workout.h
//  Chronolarm
//
//  Created by Anh Khoi Do on 2014-03-30.
//  Copyright (c) 2014 Anh Khoi Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <iAd/iAd.h>

@interface workout : UIViewController <ADBannerViewDelegate>
{
    
    // The advertisement banner
    ADBannerView *advertisement;
    
    
    // The three labels where timer is stored
    IBOutlet UILabel *workoutLabel;
    NSTimer *workoutTimer;
    
    IBOutlet UILabel *repetitionLabel;
    NSTimer *repetitionTimer;
    
    IBOutlet UILabel *breakLabel;
    NSTimer *breakTimer;
}


// The three steppers
@property (strong, nonatomic) IBOutlet UIStepper *secondsWorkoutChanged;

@property (strong, nonatomic) IBOutlet UIStepper *secondsRepetitionChanged;

@property (strong, nonatomic) IBOutlet UIStepper *secondsBreakChanged;



// The three buttons
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) IBOutlet UIButton *pauseButton;

@property (strong, nonatomic) IBOutlet UIButton *resetButton;

@end
