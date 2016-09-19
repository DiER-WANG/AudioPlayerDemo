//
//  PlayingInfoViewController.h
//  AudioPlayerDemo
//
//  Created by wangchangyang on 16/9/18.
//  Copyright © 2016年 wangchangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingInfoViewController : UIViewController

@property (nonatomic, assign) NSUInteger    playIndex;
@property (nonatomic, strong) NSArray       *playlist;

@end
