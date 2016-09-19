//
//  PlayingInfoViewController.m
//  AudioPlayerDemo
//
//  Created by wangchangyang on 16/9/18.
//  Copyright © 2016年 wangchangyang. All rights reserved.
//

#import "PlayingInfoViewController.h"
#import "PlayManager.h"

@interface PlayingInfoViewController ()<PlayManagerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *positionSlider;
@property (weak, nonatomic) IBOutlet UIButton *toggleBtn;

@end

@implementation PlayingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PlayManager sharedInstance] playAtIndex:_playIndex withPlaylist:_playlist];
    [PlayManager sharedInstance].delegate = self;
}

- (void)playingPositionChanaged:(CGFloat)position {
    _positionSlider.value = position;
}

- (void)playingStatusChanaged:(BOOL)isPlay {
    
    if (_toggleBtn.isSelected == isPlay) {
        _toggleBtn.selected = !isPlay;
    }
}


- (IBAction)pauseOrPlay:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [[PlayManager sharedInstance] pauseOrPlay];
}
- (IBAction)playNext:(UIButton *)sender {
    [[PlayManager sharedInstance] playNext];
}

- (IBAction)playPrevious:(UIButton *)sender {
    [[PlayManager sharedInstance] playPrevious];
}
- (IBAction)positionValueChanged:(UISlider *)sender {
    [[PlayManager sharedInstance] seekToPosition:sender.value];
}

- (void)dealloc {
    
    [PlayManager sharedInstance].delegate = nil;
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
