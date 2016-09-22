//
//  DmAudioItem.h
//  zapyaNewPro
//
//  Created by LiuFei on 7/16/15.
//  Copyright (c) 2015 dongxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DmAudioItem : NSObject

@property (nonatomic, strong) NSString              *title;
@property (nonatomic, strong) NSString              *album;
@property (nonatomic, strong) NSString              *artist;
@property (nonatomic, strong) MPMediaItemArtwork    *artwork;

@end

@interface DmAudioItemManager : NSObject

+ (DmAudioItem *)getMusicInfo:(NSURL *)fileURL;

+ (UIImage *)getArtwork:(NSString *)path;

@end
