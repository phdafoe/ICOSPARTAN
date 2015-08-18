//
//  ViewController.h
//  ICOMusicPlayerTest_1
//
//  Created by User on 20/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import <Social/Social.h>

#import "NSString+TimeToString.h"
#import "EFCircularSlider.h"
#import "RoundImageView.h"
#import "SVStatusHUD.h"
//#import "EAIntroView.h"

#import "REFrostedViewController.h"



@interface ICOMusicPlayer : UIViewController <MPMediaPickerControllerDelegate>

@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;
@property (nonatomic, strong) MPMediaItemCollection *mediaCollection;
@property (nonatomic, strong) MPMediaPickerController *mediaPicker;

@property (nonatomic, weak) IBOutlet UIImageView *artWorkBAckground;

@property (weak, nonatomic) IBOutlet RoundImageView *artwork;
@property (nonatomic, weak) IBOutlet EFCircularSlider *progressTime;

@property (nonatomic, weak) IBOutlet UILabel *albumLabel;
@property (nonatomic, weak) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

- (IBAction)playPause:(id)sender;
- (IBAction)toPreviusRight:(id)sender;
- (IBAction)toNextLeft:(id)sender;
- (IBAction)shareDown:(id)sender;
- (IBAction)showMusicLibrary:(id)sender;

- (IBAction)showMenu:(id)sender;



@end

