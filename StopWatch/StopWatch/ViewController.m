//
//  ViewController.m
//  StopWatchDemo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIStopWatch.h"

// Create a KVOContext to identify the StopWatch observer
// AnyObject (void pointer)
// Gives us a unique value (memory address)
void *KVOContext = &KVOContext; // 0x2234234235

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

@property (nonatomic) LSIStopWatch *stopwatch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.stopwatch = [[LSIStopWatch alloc] init];
	[self.timeLabel setFont:[UIFont monospacedDigitSystemFontOfSize: self.timeLabel.font.pointSize  weight:UIFontWeightMedium]];
}

- (IBAction)resetButtonPressed:(id)sender {
    [self.stopwatch reset];
}

- (IBAction)startStopButtonPressed:(id)sender {
    if (self.stopwatch.isRunning) {
        [self.stopwatch stop];
    } else {
        [self.stopwatch start];
    }
}

- (void)updateViews {
    if (self.stopwatch.isRunning) {
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    self.resetButton.enabled = self.stopwatch.elapsedTime > 0;
    
    self.timeLabel.text = [self stringFromTimeInterval:self.stopwatch.elapsedTime];
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger timeIntervalAsInt = (NSInteger)interval;
    NSInteger tenths = (NSInteger)((interval - floor(interval)) * 10);
    NSInteger seconds = timeIntervalAsInt % 60;
    NSInteger minutes = (timeIntervalAsInt / 60) % 60;
    NSInteger hours = (timeIntervalAsInt / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld.%ld", (long)hours, (long)minutes, (long)seconds, (long)tenths];
}

// MARK: Setup Key Value Observing (KVO)

// Override the stopwatch setter
- (void)setStopwatch:(LSIStopWatch *)stopwatch
{
    
    if (stopwatch != _stopwatch) { // this check prevents accidentally removing observers twice and potentially causing a crash
        
        // willSet
        // Cleanup KVO - Remove Observers
        [_stopwatch removeObserver:self forKeyPath:@"running" context:KVOContext];
        [_stopwatch removeObserver:self forKeyPath:@"elapsedTime" context:KVOContext];

        [self willChangeValueForKey:@"stopwatch"];
        _stopwatch = stopwatch;
        [self didChangeValueForKey:@"stopwatch"];
        
        // didSet
        // Setup KVO - Add Observers
        [_stopwatch addObserver:self forKeyPath:@"running" options:0 context:KVOContext];
        [_stopwatch addObserver:self forKeyPath:@"elapsedTime" options:0 context:KVOContext];
    }
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == KVOContext) {
        if ([keyPath isEqualToString:@"running"]) {
            // If running changes states (e.g. NO -> YES), then update the views
            [self updateViews]; // NSLog(@"Update the UI! Running: %@", (self.stopwatch.running ? @"YES" : @"NO"));
            
        } else if ([keyPath isEqualToString:@"elapsedTime"]) {
            // If running changes states (e.g. NO -> YES), then update the views
            [self updateViews]; // NSLog(@"Update the UI! Elapsed Time: %.2f", self.stopwatch.elapsedTime);
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)dealloc {
	// Stop observing KVO (otherwise it will crash randomly when the VC is no longer on screen, for instance)
    self.stopwatch = nil;
    
}

@end
