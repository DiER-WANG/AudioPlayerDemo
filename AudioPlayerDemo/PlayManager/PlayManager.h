//
//  PlayManager.h
//  AudioPlayerDemo
//
//  Created by wangchangyang on 16/9/18.
//  Copyright © 2016年 wangchangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol PlayManagerDelegate <NSObject>

@optional
- (void)playingPositionChanaged:(CGFloat)position;
- (void)playingStatusChanaged:(BOOL)isPlay;


@end


@interface PlayManager : UIResponder

@property (nonatomic, assign) id<PlayManagerDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)playAtIndex:(NSUInteger)index withPlaylist:(NSArray *)playList;

- (void)playNext;
- (void)playPrevious;

- (void)pauseOrPlay;
- (void)changePlayMode;

- (void)addMusic:(NSURL *)musicURL;
- (void)removeMusic:(NSURL *)musicURL;

- (void)seekToPosition:(CGFloat)position;

@end
