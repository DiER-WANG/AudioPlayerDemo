//
//  VLCAudioManager.m
//  AudioPlayerDemo
//
//  Created by wangchangyang on 16/9/21.
//  Copyright © 2016年 wangchangyang. All rights reserved.
//

#import "VLCAudioManager.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface VLCAudioManager()<VLCMediaPlayerDelegate>

@property (nonatomic, strong) VLCMediaListPlayer *player;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation VLCAudioManager

+ (instancetype)sharedInstance {
    
    static VLCAudioManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
        singleton.player = [[VLCMediaListPlayer alloc] init];
        singleton.player.repeatMode = VLCRepeatAllItems;
        singleton.player.mediaPlayer.delegate = singleton;
        
        MPRemoteCommandCenter *cmdCenter = [MPRemoteCommandCenter sharedCommandCenter];
        
        [cmdCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            [singleton pauseOrPlay];
            
            if (singleton.delegate && [singleton.delegate respondsToSelector:@selector(vlcRemoteControlStateChanged:)]) {
                [singleton.delegate vlcRemoteControlStateChanged:NO];
            }
            
            return 0;
        }];
        
        [cmdCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            
            [singleton pauseOrPlay];
            
            if (singleton.delegate && [singleton.delegate respondsToSelector:@selector(vlcRemoteControlStateChanged:)]) {
                [singleton.delegate vlcRemoteControlStateChanged:YES];
            }
            
            return 0;
        }];
        
        [cmdCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            [singleton playNext];
            return 0;
        }];
        
        [cmdCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            [singleton playPrevious];
            return 0;
        }];
        
        [cmdCenter.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
           
            [singleton pauseOrPlay];
            
            if (singleton.delegate && [singleton.delegate respondsToSelector:@selector(vlcRemoteControlStateChanged:)]) {
                [singleton.delegate vlcRemoteControlStateChanged:singleton.player.mediaPlayer.isPlaying];
            }
            
            return 0;
        }];
    }); 
    return singleton;
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {
    // 改变 时间
    if (_delegate && [_delegate respondsToSelector:@selector(vlcAudioPlayerTimeChanged:position:)]) {
        VLCMediaPlayer *mediaPlayer = (VLCMediaPlayer *)aNotification.object;
        if (mediaPlayer.state == VLCMediaPlayerStateBuffering) {
            [_delegate vlcAudioPlayerTimeChanged:[NSString stringWithFormat:@"%@", mediaPlayer.time] position:mediaPlayer.position];
        }
    }
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    if (_delegate && [_delegate respondsToSelector:@selector(vlcAudioPlayerStateChanged:)]) {
        VLCMediaPlayer *mediaPlayer = (VLCMediaPlayer *)aNotification.object;
        if (mediaPlayer.state == VLCMediaPlayerStateBuffering) {
        }
        if (mediaPlayer.state == VLCMediaPlayerStatePlaying) {
            // 从 暂停 到 播放
        }
        if (mediaPlayer.state == VLCMediaPlayerStatePaused) {
            // 从 播放 到 暂停
        }
    }
}

- (void)playAtIndex:(NSUInteger)index withPlaylist:(NSArray *)playList {
    
    NSMutableArray *mediaList = [[NSMutableArray alloc] init];
    
    for (NSString *path in playList) {
        VLCMedia *media = [VLCMedia mediaWithPath:path];
        [mediaList addObject:media];
    }
    
    VLCMediaList *list = [[VLCMediaList alloc] initWithArray:mediaList];
    _player.mediaList = list;
    _currentIndex = index;
    [_player playItemAtIndex:(int)index];
}


- (void)playNext {

    NSUInteger playMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"VLC_PLAYER_MODE"] unsignedIntegerValue];
    
    if (playMode == 0) {
        _currentIndex++;
        [_player next];
    } else if (playMode == 1) {
        [_player playItemAtIndex:(int)_currentIndex];
    } else {
        _currentIndex = arc4random()%_player.mediaList.count;
        [_player playItemAtIndex:(int)_currentIndex];
    }
}



- (void)playPrevious {
    [_player previous];
}

- (void)pauseOrPlay {
    if (_player.mediaPlayer.isPlaying) {
        [_player pause];
    } else {
        [_player play];
    }
}
- (void)changePlayMode {
    // 0 顺序， 1 单曲， 2 随机
    NSUInteger playMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"VLC_PLAYER_MODE"] unsignedIntegerValue];
    
    playMode++;
    if (playMode == 3) {
        playMode = 1;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@(playMode) forKey:@"VLC_PLAYER_MODE"];
}

- (void)addMusic:(NSURL *)musicURL {
    [_player.mediaList addMedia:[VLCMedia mediaWithURL:musicURL]];
}
- (void)removeMusicAtIndex:(NSUInteger)index {
    [_player.mediaList removeMediaAtIndex:index];
}

- (void)seekToPosition:(CGFloat)position {
    [_player.mediaPlayer setPosition:position];    
}



@end
