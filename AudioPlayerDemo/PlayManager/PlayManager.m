//
//  PlayManager.m
//  AudioPlayerDemo
//
//  Created by wangchangyang on 16/9/18.
//  Copyright © 2016年 wangchangyang. All rights reserved.
//

#import "PlayManager.h"
#import "APAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

#import "DmAudioItem.h"

@interface PlayManager ()<APAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray    *playList;
@property (nonatomic, strong) APAudioPlayer     *player;
@property (nonatomic, assign) NSUInteger        currentIndex;
@property (nonatomic, strong) NSTimer           *playingTimer;

@end


@implementation PlayManager

+ (instancetype)sharedInstance {    
    static PlayManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[PlayManager alloc] init];
        singleton.player = [APAudioPlayer new];
        singleton.player.delegate = singleton;
        [[NSNotificationCenter defaultCenter] addObserver:singleton
                                                 selector:@selector(outputDeviceChanged:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:[AVAudioSession sharedInstance]];
        
        
        
        MPRemoteCommandCenter *cmdCenter = [MPRemoteCommandCenter sharedCommandCenter];
        
        [cmdCenter.pauseCommand addTarget:singleton action:@selector(pauseCmd)];
        
    });
    return singleton;
}

- (void)pauseCmd {
    
    NSLog(@"xxxx");
    
}

- (void)outputDeviceChanged:(NSNotification *)notify {
    if ([[notify.userInfo objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue] == 2) {
        if (_player.isPlaying) {
            [self pauseOrPlay];
        }
    }
}

- (void)playAtIndex:(NSUInteger)index withPlaylist:(NSArray *)playList {
    
    if (_playingTimer) {        
        [_playingTimer invalidate];
        _playingTimer = nil;
    }
    
    _currentIndex = (index < playList.count ? index : 0);
    _playList = [playList mutableCopy];
    
    NSURL *url = [playList objectAtIndex:_currentIndex];
    
    [self.player loadItemWithURL:url autoPlay:YES];
}

- (void)playNext {
    
    [self playAtIndex:++_currentIndex withPlaylist:_playList];
}

- (void)playPrevious {
    
    NSUInteger nextIndex = _currentIndex == 0 ? (_playList.count - 1) : (_currentIndex - 1);
    
    [self playAtIndex:nextIndex withPlaylist:_playList];   
}

- (void)pauseOrPlay {
    
    if (_player.isPlaying) {
        [_player pause];
    } else {
        [_player play];
    }
}

- (void)changePlayMode {
    
}

- (void)addMusic:(NSURL *)musicURL {
    
}

- (void)removeMusic:(NSURL *)musicURL {
    
}

- (void)seekToPosition:(CGFloat)position {
    [_player setPosition:position];
}

#pragma mark - APAudioPlayerDelegate
/**
 *  Notifies the delegate about playing status changed
 *  // 播放 暂停
 *  @param player APAudioPlayer
 */
- (void)playerDidChangePlayingStatus:(APAudioPlayer *)player {
    
    if (_delegate && [_delegate respondsToSelector:@selector(playingStatusChanaged:)]) {
        [_delegate playingStatusChanaged:player.isPlaying];
    }
    
    if (player.isPlaying) {
        if (!_playingTimer) {
            _playingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startPlaying) userInfo:nil repeats:YES];
        }
        _playingTimer.fireDate = [NSDate distantPast];
    } else {
        if (_playingTimer) {
            _playingTimer.fireDate = [NSDate distantFuture];
        }
    }
}

- (void)startPlaying {
    if (_delegate && [_delegate respondsToSelector:@selector(playingPositionChanaged:)]) {
        [_delegate playingPositionChanaged:_player.position];
    }
}

/**
 *  Will be called when track is over
 *
 *  @param player APAudioPlayer
 */
- (void)playerDidFinishPlaying:(APAudioPlayer *)player {
    
    [self playNext];
}

/**
 *   Will be called when interruption occured. For ex. phone call. Basically you should call - (void)pause in this case.
 *
 *  @param player APAudioPlayer
 */
- (void)playerBeginInterruption:(APAudioPlayer *)player {
    [_player pause];
}

/**
 *   Will be called when interruption ended. For ex. phone call ended. It's up to you to decide to call - (void)resume or not.
 *
 *  @param player APAudioPlayer
 *  @param should BOOL
 */
- (void)playerEndInterruption:(APAudioPlayer *)player shouldResume:(BOOL)should {
    
}

@end
