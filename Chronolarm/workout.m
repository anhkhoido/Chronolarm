//
//  workout.m
//  Chronolarm
//
//  Created by Anh Khoi Do on 2014-03-30.
//  Copyright (c) 2014 Anh Khoi Do. All rights reserved.
//

#import "workout.h"

@interface workout ()

@end

@implementation workout
{
    // Instance variables
    int seconds;
    int minutes;
    
    int secondsRepetition;
    int minutesRepetition;
    
    int secondsBreak;
    int minutesBreak;
    
    int secondsValue;
    int minutesValue;
    
    BOOL startRepetitionTimer;
    BOOL startBreakTimer;
}



// The steppers
-(IBAction)secondsWorkoutChanged:(UIStepper *)sender {
    seconds = [sender value];
    minutes = [sender value] / 60;
    
    if (seconds >= 60) {
        seconds = seconds % 60;
    }
    
    [workoutLabel setText: [NSString stringWithFormat:@"%2i : %2i", (int) minutes, (int) seconds]];
}


-(IBAction)secondsRepetitionChanged:(UIStepper *)sender {
    minutesRepetition = [sender value] / 60;
    secondsRepetition = (int)[sender value] % 60;
    secondsValue = secondsRepetition;
    minutesValue = minutesRepetition;
    [repetitionLabel setText: [NSString stringWithFormat:@"%2i : %2i", (int) minutesRepetition, (int) secondsRepetition]];
    
}

-(IBAction)secondsBreakChanged:(UIStepper *)sender {
    minutesBreak = [sender value] / 60;
    secondsBreak = (int)[sender value] % 60;
    [breakLabel setText: [NSString stringWithFormat:@"%2i : %2i", (int) minutesBreak, (int) secondsBreak]];
}



// The buttons
-(void) chrono:(NSTimer *) timer {
    seconds -= 1;
    secondsValue -= 1;
    
    if (seconds < 0) {
        seconds = 59;
        minutes -= 1;
        
        if (minutes < 0) {
            minutes = 0;
        }
    } // End of first if statement.
    
    if (secondsValue < 0) {
        secondsValue = 59;
        minutesValue -= 1;
        
        if (minutesValue < 0) {
            minutesValue = 0;
        }
    } // End of second if statement
    
    
    
    
    workoutLabel.text = [NSString stringWithFormat:@"%2i : %2i", minutes, seconds];
    
    
    if (startRepetitionTimer) {
        repetitionLabel.text = [NSString stringWithFormat:@"%2i : %2i", minutesValue, secondsValue];
        breakLabel.text = [NSString stringWithFormat:@"%2i : %2i", minutesBreak, secondsBreak];
        
        if (secondsValue == 0) {
            if (minutesValue == 0) {
                startBreakTimer = YES;
                startRepetitionTimer = NO;
                
                secondsValue = secondsBreak;
                minutesValue = minutesBreak;
                
                // Alarm for a series
                CFBundleRef repetitionAlarm = CFBundleGetMainBundle();
                CFURLRef soundFileURLRef;
                soundFileURLRef = CFBundleCopyResourceURL(repetitionAlarm, (CFStringRef) @"DigitalNightstand", CFSTR ("wav"), NULL);
                
                UInt32 soundIDRepAlarm;
                AudioServicesCreateSystemSoundID(soundFileURLRef, &soundIDRepAlarm);
                AudioServicesPlaySystemSound(soundIDRepAlarm);
            }
        }
    } // End of third if statement.
    else if (startBreakTimer) {
        repetitionLabel.text = [NSString stringWithFormat:@"%2i : %2i", minutesRepetition, secondsRepetition];
        breakLabel.text = [NSString stringWithFormat:@"%2i : %2i", minutesValue, secondsValue];
        if (secondsValue == 0) {
            if (minutesValue == 0) {
                startBreakTimer = NO;
                startRepetitionTimer = YES;
                
                secondsValue = secondsRepetition;
                minutesValue = minutesRepetition;
                
                
                // Alarm for the break
                CFBundleRef breakAlarm = CFBundleGetMainBundle();
                CFURLRef soundFileURLRef;
                soundFileURLRef = CFBundleCopyResourceURL(breakAlarm, (CFStringRef) @"DigitalNightstand", CFSTR ("wav"), NULL);
                
                UInt32 soundIDBreak;
                AudioServicesCreateSystemSoundID(soundFileURLRef, &soundIDBreak);
                AudioServicesPlaySystemSound(soundIDBreak);
            }
        }
    } // End of else if statement
    
    if (seconds == 0) {
        if (minutes == 0) {
            [workoutTimer invalidate];
            
            // Alarm for end of workout.
            CFBundleRef endAlarm = CFBundleGetMainBundle();
            CFURLRef soundFileURLRef;
            soundFileURLRef = CFBundleCopyResourceURL(endAlarm, (CFStringRef) @"alarm_clock_ringing", CFSTR ("wav"), NULL);
            
            UInt32 soundIDEnd;
            AudioServicesCreateSystemSoundID(soundFileURLRef, &soundIDEnd);
            AudioServicesPlaySystemSound(soundIDEnd);
            
            
            UIAlertView *congratulations = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"TITLE", @"Congratulations!") message:NSLocalizedString(@"WORKOUT_OVER", @"Your workout is over!") delegate:self cancelButtonTitle:NSLocalizedString(@"OKAY", @"Okay") otherButtonTitles: nil];
            
            [congratulations show];
            
            // Reset all steppers when workout ends.
            _secondsWorkoutChanged.value = 0;
            _secondsRepetitionChanged.value = 0;
            _secondsBreakChanged.value = 0;
            
            // Reset the text displayed in the label to zero.
            [workoutLabel setText:@"00 : 00"];
            [repetitionLabel setText:@"00 : 00"];
            [breakLabel setText:@"00 : 00"];
            
            
            
            return;
        }
    }
    
    
    
} // End of chrono method


-(IBAction)startButton:(UIButton *)sender {
    workoutTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chrono:) userInfo:nil repeats:YES];
    
    CFBundleRef startAlarm = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef;
    soundFileURLRef = CFBundleCopyResourceURL(startAlarm, (CFStringRef) @"Ping", CFSTR ("wav"), NULL);
    
    UInt32 soundIDStart;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundIDStart);
    AudioServicesPlaySystemSound(soundIDStart);
    
    // When everything is at zero.
    if (minutes == 0 && seconds == 0) {
        if (minutesRepetition == 0 && secondsRepetition == 0) {
            if (minutesBreak == 0 && secondsBreak == 0) {
                UIAlertView *warning = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"Warning") message:NSLocalizedString(@"WARNING_MESSAGE", @"Do not fool around.") delegate:self cancelButtonTitle:NSLocalizedString(@"OKAY", @"Okay") otherButtonTitles: nil];
                
                [warning show];
                
                [workoutTimer invalidate];
                
                [repetitionTimer invalidate];
                
                [breakTimer invalidate];
            }
        }
    }

}

-(IBAction)pauseButton:(UIButton *)sender {
    [workoutTimer invalidate];
    
    [repetitionTimer invalidate];
    
    [breakTimer invalidate];
}

-(IBAction)resetButton:(UIButton *)sender {
    _secondsWorkoutChanged.value = 0;
    _secondsRepetitionChanged.value = 0;
    _secondsBreakChanged.value = 0;
    
    
    [workoutLabel setText:@"00 : 00"];
    [repetitionLabel setText:@"00 : 00"];
    [breakLabel setText:@"00 : 00"];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner {
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:1];
    
    [UIView commitAnimations];
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1];
    
    [banner setAlpha:0];
    
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Boolean condition of supporting timers when view is loaded.
    startRepetitionTimer = YES;
    startBreakTimer = NO;
    
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
