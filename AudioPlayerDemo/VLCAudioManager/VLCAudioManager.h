//
//  VLCAudioManager.h
//  AudioPlayerDemo
//
//  Created by wangchangyang on 16/9/21.
//  Copyright © 2016年 wangchangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VLCAudioManagerDelegate <NSObject>

@optional
- (void)vlcAudioPlayerTimeChanged:(NSString *)time position:(CGFloat)position;
- (void)vlcAudioPlayerStateChanged:(BOOL)isPlaying;
- (void)vlcAudioPlayerInfoChanged:(NSDictionary *)playInfo;

// Remote Control 操作，改变 播放 UI 的 播放按钮的状态
- (void)vlcRemoteControlStateChanged:(BOOL)isPlaying;

@end


@interface VLCAudioManager : NSObject

+ (instancetype)sharedInstance;

- (void)playAtIndex:(NSUInteger)index withPlaylist:(NSArray *)playList;

- (void)playNext;
- (void)playPrevious;

- (void)pauseOrPlay;
- (void)changePlayMode;

- (void)addMusic:(NSURL *)musicURL;
- (void)removeMusicAtIndex:(NSUInteger)index;

- (void)seekToPosition:(CGFloat)position;

@property(nonatomic, weak) id<VLCAudioManagerDelegate> delegate;

@end
