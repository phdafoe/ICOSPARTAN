//
//  ViewController.m
//  ICOMusicPlayerTest_1
//
//  Created by User on 20/7/15.
//  Copyright (c) 2015 iCologic. All rights reserved.
//

#import "ICOMusicPlayer.h"

@interface ICOMusicPlayer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSUserDefaults *userDefaults;
@property (assign, nonatomic) BOOL wasSkip;

@end

@implementation ICOMusicPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    //notification about now playing
    [notificationCenter addObserver:self
                           selector:@selector(didChangeNowPlaying:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object:self.musicPlayer];
    
    [self.musicPlayer beginGeneratingPlaybackNotifications];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];
    [self.timer fire];
    
    //configure mediaPicker
    self.mediaPicker = [[MPMediaPickerController alloc] init];
    self.mediaPicker.delegate = self;
    self.mediaPicker.allowsPickingMultipleItems = YES;
    self.mediaPicker.showsCloudItems = YES;
    
    self.progressTime.enabled = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //show tutorial
    [self viewIntroduction];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.musicPlayer.nowPlayingItem == nil) {
        self.durationLabel.hidden =
        self.elapsedTimeLabel.hidden =
        self.artistLabel.hidden =
        self.albumLabel.hidden = YES;
        self.musicLabel.text = NSLocalizedString(@"noTrack", nil);
        self.artwork.image = [UIImage imageNamed:@"artwork"];
        self.artWorkBAckground.image = [UIImage imageNamed:@"artworkBackground"];
    }
    
}

- (void)time{
    
    self.progressTime.currentValue = self.musicPlayer.currentPlaybackTime;
    self.elapsedTimeLabel.text = [NSString stringFromTime:self.musicPlayer.currentPlaybackTime];
}

#pragma mark - Notification didChangeNowPlaying
-(void)didChangeNowPlaying:(NSNotification *)notification{
    
    if (self.musicPlayer.nowPlayingItem == nil) {
        self.durationLabel.hidden =
        self.elapsedTimeLabel.hidden =
        self.artistLabel.hidden =
        self.albumLabel.hidden = YES;
        self.musicLabel.text = NSLocalizedString(@"noTrack", nil);
        self.artwork.image = [UIImage imageNamed:@"artwork"];
        self.artWorkBAckground.image = [UIImage imageNamed:@"artworkBackground"];
    }
    else{
        self.durationLabel.hidden =
        self.elapsedTimeLabel.hidden =
        self.artistLabel.hidden =
        self.albumLabel.hidden = NO;
        
        NSTimeInterval trackLength = [[self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
        //label durantion
        self.durationLabel.text = [NSString stringFromTime:trackLength];
        self.progressTime.currentValue = 0;
        self.progressTime.maximumValue = trackLength;
        
        //label - artist - music - album
        self.artistLabel.text = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
        self.musicLabel.text = [self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
        self.albumLabel.text =[self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        // Artwork
        MPMediaItemArtwork *artwork = [self.musicPlayer.nowPlayingItem valueForProperty: MPMediaItemPropertyArtwork];
        UIImage *artworkImage =[artwork imageWithSize:self.artwork.bounds.size];
        
        if (artworkImage) {
            self.artWorkBAckground.image = artworkImage;
            self.artwork.image = artworkImage;
        }
        else {
            self.artwork.image = [UIImage imageNamed:@"artwork"];
            self.artWorkBAckground.image = [UIImage imageNamed:@"artworkBackground"];
        }
        
    }
    
}

#pragma Mark - MPMediaPickerControllerDelegate
-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    self.mediaCollection = mediaItemCollection;
    [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self.musicPlayer play];
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)playPause:(id)sender {
    
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        [self.musicPlayer pause];
        [SVStatusHUD showWithImage:[UIImage imageNamed:@"pause"]];
    } else {
        [self.musicPlayer play];
        [SVStatusHUD showWithImage:[UIImage imageNamed:@"play"]];
    }
}

- (IBAction)toPreviusRight:(id)sender {
    
    if ([self.mediaCollection.items.firstObject isEqual:self.musicPlayer.nowPlayingItem]||self.musicPlayer.nowPlayingItem == nil) {
        [self presentViewController:self.mediaPicker animated:YES completion:nil];
    }
    else{
        [self.musicPlayer skipToPreviousItem];
        [SVStatusHUD showWithImage:[UIImage imageNamed:@"previous"]];
    }
}

- (IBAction)toNextLeft:(id)sender {
    
    if ([self.mediaCollection.items.lastObject isEqual:self.musicPlayer.nowPlayingItem]||self.musicPlayer.nowPlayingItem == nil) {
        [self presentViewController:self.mediaPicker animated:YES completion:nil];
    }
    else{
        [self.musicPlayer skipToNextItem];
        [SVStatusHUD showWithImage:[UIImage imageNamed:@"next"]];
    }
}

- (IBAction)shareDown:(id)sender {
    
    if (self.musicPlayer.nowPlayingItem == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ops", nil) message: NSLocalizedString(@"noTrack", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0.0, 130.0);
            self.artWorkBAckground.transform = CGAffineTransformMakeTranslation(0.0, 130.0);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
                self.artWorkBAckground.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
                
            } completion:^(BOOL finished) {
                
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                    SLComposeViewController *escrevedor = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                    [escrevedor setInitialText:[NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"listening", nil),[self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtist],[self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle]]];
                    [escrevedor addImage:self.artwork.image];
                    [self presentViewController:escrevedor animated:YES completion:nil];
                };
                
            }];
        }];
    }
}

- (IBAction)showMusicLibrary:(id)sender {

    self.mediaPicker.title = [NSString stringWithFormat:@"%@", [UIColor blackColor]];
    
    //self.title = [UIColor blackColor];
    
    [self presentViewController:self.mediaPicker animated:YES completion:nil];
}


- (IBAction)showMenu:(id)sender{
    
    
    
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}




#pragma mark - Delegate View Introduction
- (void)introDidFinish {
    self.wasSkip = NO;
}

-(void)viewIntroduction{
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString *DidFirstRunKey = @"DidFirstRun";
    BOOL didFirstRun = [self.userDefaults boolForKey:DidFirstRunKey];
    if (self.wasSkip !=YES) {
        [self.userDefaults setBool:YES forKey:DidFirstRunKey];
    }
    if (!didFirstRun){
        
        //frist view tutorial
        UIView *viewInitial = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:viewInitial];
        UIImageView *imageViewInitial = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gestureOne"]];
        [viewInitial addSubview:imageViewInitial];
        //EAIntroPage *page1 = [EAIntroPage pageWithCustomView:viewInitial];
        
        //second view tutorial
        UIView *viewSecond = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:viewSecond];
        UIImageView *imageViewSecond = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gestureTwo"]];
        [viewSecond addSubview:imageViewSecond];
        
        
        //Parte de paginas de tutoriales
        //EAIntroPage *page2 = [EAIntroPage pageWithCustomView:viewSecond];
        //EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1, page2]];
        //[intro setDelegate:self];
        //[intro showInView:self.view animateDuration:0.5];
        
    }
    
}


@end
