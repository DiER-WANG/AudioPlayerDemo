//
//  PlayingInfoViewController.m
//  AudioPlayerDemo
//
//  Created by wangchangyang on 16/9/18.
//  Copyright © 2016年 wangchangyang. All rights reserved.
//

#import "PlayingInfoViewController.h"
#import "PlayManager.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


#import "VLCAudioManager.h"

@interface PlayingInfoViewController ()<VLCAudioManagerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *positionSlider;
@property (weak, nonatomic) IBOutlet UIButton *toggleBtn;

@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIImageView *artwork;

@end

@implementation PlayingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[[PlayManager sharedInstance] playAtIndex:_playIndex withPlaylist:_playlist];
    //[PlayManager sharedInstance].delegate = self;
    
    [[VLCAudioManager sharedInstance] playAtIndex:_playIndex withPlaylist:_playlist];
    [VLCAudioManager sharedInstance].delegate = self;
    [self showCustomizedControlCenter];
    
}


- (void)showCustomizedControlCenter {
    /* basic audio initialization */
//    NSString *soundFilePath = [NSString stringWithFormat:@"%@/test.mp3", [[NSBundle mainBundle] resourcePath]];
//    
//    soundFilePath = [[NSBundle mainBundle] pathForResource:@"8.mp3" ofType:nil];
//    
//    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
//    self.player = [[AVAudioPlayer alloc] init];
////    self.player.numberOfLoops = -1;
//    [self.player play];
//    
    /* registering as global audio playback */
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    
//    /* the cool control center registration */
//    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
//    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    [commandCenter.dislikeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    [commandCenter.likeCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    [commandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//    
//    /* setting the track title, album title and button texts to match the screenshot */
//    commandCenter.likeCommand.localizedTitle = @"Thumb Up";
//    commandCenter.dislikeCommand.localizedTitle = @"Thumb down";
//    
//    MPNowPlayingInfoCenter* info = [MPNowPlayingInfoCenter defaultCenter];
//    NSMutableDictionary* newInfo = [NSMutableDictionary dictionary];
//    
//    [newInfo setObject:@"Mixtape" forKey:MPMediaItemPropertyTitle];
//    [newInfo setObject:@"Jamie Cullum" forKey:MPMediaItemPropertyArtist];
//    
//    info.nowPlayingInfo = newInfo;
}

- (void)vlcAudioPlayerTimeChanged:(NSString *)time position:(CGFloat)position {
    _positionSlider.value = position;
}

- (void)vlcRemoteControlStateChanged:(BOOL)isPlaying {
        _toggleBtn.selected = !isPlaying;    
}

- (void)vlcAudioPlayerInfoChanged:(NSDictionary *)playInfo {
    
    if ([playInfo objectForKey:@"title"]) {
        self.title = [playInfo objectForKey:@"title"];
    }
    
    if ([playInfo objectForKey:@"artist"]) {
        self.title = [self.title stringByAppendingString:[playInfo objectForKey:@"artist"]];
    }
    
    if ([playInfo objectForKey:@"artworkURL"]) {
        NSString *filePath = [[playInfo objectForKey:@"artworkURL"] stringByRemovingPercentEncoding];
        
        NSURL *imageURL = [NSURL fileURLWithPath:filePath];
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        _artwork.image = image;
    }
}


- (IBAction)pauseOrPlay:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [[VLCAudioManager sharedInstance] pauseOrPlay];
}
- (IBAction)playNext:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [[VLCAudioManager sharedInstance] playNext];
}

- (IBAction)playPrevious:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [[VLCAudioManager sharedInstance] playPrevious];
}
- (IBAction)positionValueChanged:(UISlider *)sender {
    [[VLCAudioManager sharedInstance] seekToPosition:sender.value];
}

- (void)dealloc {
    [VLCAudioManager sharedInstance].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
