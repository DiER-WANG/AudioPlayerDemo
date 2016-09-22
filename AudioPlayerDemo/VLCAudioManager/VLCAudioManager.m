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

typedef NS_ENUM(NSInteger, RefreshMode) {
    RefreshModePlay = 1,
    RefreshModePause,
    RefreshModeBegin,
    RefreshModeSeek
};


@interface VLCAudioManager()<VLCMediaPlayerDelegate>

@property (nonatomic, strong) VLCMediaListPlayer *player;
@property (nonatomic, assign) NSUInteger currentIndex;

@property(nonatomic, assign) RefreshMode refreshMode;

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
    
    VLCMediaPlayer *mediaPlayer = (VLCMediaPlayer *)aNotification.object;
    // 改变 时间
    if (_delegate && [_delegate respondsToSelector:@selector(vlcAudioPlayerTimeChanged:position:)]) {
        if (mediaPlayer.state == VLCMediaPlayerStatePlaying ||
            mediaPlayer.state == VLCMediaPlayerStateBuffering) {
            [_delegate vlcAudioPlayerTimeChanged:[NSString stringWithFormat:@"%@", mediaPlayer.time] position:mediaPlayer.position];
        }
    }
}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    
    
    
    VLCMediaPlayer *mediaPlayer = (VLCMediaPlayer *)aNotification.object;
    
    if (mediaPlayer.state == VLCMediaPlayerStateStopped) {
        [self playNext];
    } else {
        
        if (_refreshMode == RefreshModeSeek) {
            return;
        }
        
        [self configNowPlayingInfoWithMeida:mediaPlayer.media];
    }
}

- (void)playAtIndex:(NSUInteger)index withPlaylist:(NSArray *)playList {
    
    _refreshMode = RefreshModeBegin;
    
    NSMutableArray *mediaArr = [NSMutableArray new];
    
    for (NSString *path in playList) {
        VLCMedia *media = [VLCMedia mediaWithPath:path];
        [mediaArr addObject:media];
    }
    
    _player.mediaList = [[VLCMediaList alloc] initWithArray:mediaArr];
    [_player playItemAtIndex:(int)index];
}

- (void)configNowPlayingInfoWithMeida:(VLCMedia *)media  {

    NSDictionary *metaData = [media metaDictionary];
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];

    if (_refreshMode == RefreshModeBegin) {
        
        NSMutableDictionary *playingInfo = [NSMutableDictionary new];
        
        NSString *title = media.url.lastPathComponent;
        if ([metaData objectForKey:@"title"]) {
            title = [metaData objectForKey:@"title"];
        }
        
        NSString *artist = @"";
        if ([metaData objectForKey:@"artist"]) {
            artist = [metaData objectForKey:@"artist"];
        }
        
        [playingInfo setObject:title  forKey:MPMediaItemPropertyTitle];
        [playingInfo setObject:artist forKey:MPMediaItemPropertyArtist];
        [playingInfo setObject:@([media.length intValue] / (60 * 24.f)) forKey:MPMediaItemPropertyPlaybackDuration];
        [playingInfo setObject:@(0.0) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [playingCenter setNowPlayingInfo:playingInfo];
        
        if (_delegate && [_delegate respondsToSelector:@selector(vlcAudioPlayerInfoChanged:)]) {
            [_delegate vlcAudioPlayerInfoChanged:metaData];
        }
    }
    if (_refreshMode == RefreshModePlay) {
        
        NSMutableDictionary *playingInfo = [[NSMutableDictionary alloc] initWithDictionary:playingCenter.nowPlayingInfo];
        [playingInfo setObject:@([media.length intValue] / (60 * 24.f)) forKey:MPMediaItemPropertyPlaybackDuration];
        [playingInfo setObject:@([_player.mediaPlayer.time intValue] / (60 * 24.f)) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [playingInfo setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
        [playingCenter setNowPlayingInfo:playingInfo];
    }
    
    if (_refreshMode == RefreshModePause) {
        NSMutableDictionary *playingInfo = [[NSMutableDictionary alloc] initWithDictionary:playingCenter.nowPlayingInfo];
        [playingInfo setObject:@([_player.mediaPlayer.time intValue] / (60 * 24.f)) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [playingInfo setObject:@(0) forKey:MPNowPlayingInfoPropertyPlaybackRate];
        [playingCenter setNowPlayingInfo:playingInfo];
    }
    
    if (_refreshMode == RefreshModeSeek) {
        _refreshMode = -1;
    }
}


- (void)playNext {

    _refreshMode = RefreshModeBegin;
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
    _refreshMode = RefreshModeBegin;
    [_player previous];
}

- (void)pauseOrPlay {
    if (_player.mediaPlayer.isPlaying) {
        _refreshMode = RefreshModePause;
        [_player pause];
    } else {
        _refreshMode = RefreshModePlay;
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
    
    _refreshMode = RefreshModeSeek;
    VLCMedia *media = _player.mediaPlayer.media;
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *playingInfo = [[NSMutableDictionary alloc] initWithDictionary:playingCenter.nowPlayingInfo];
    [playingInfo setObject:@([media.length intValue] * position / (60 * 24.f)) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [playingInfo setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
    [playingCenter setNowPlayingInfo:playingInfo];
    
    [_player.mediaPlayer setPosition:position];
}



@end
