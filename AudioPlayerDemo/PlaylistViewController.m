//
//  PlaylistViewController.m
//  AudioPlayerDemo
//
//  Created by wangchangyang on 16/9/18.
//  Copyright © 2016年 wangchangyang. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlayManager.h"

#import "PlayingInfoViewController.h"

@interface PlaylistViewController ()

@property (nonatomic, strong) NSMutableArray *playlistArr;

@end

@implementation PlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSMutableArray *)playlistArr {
    
    if (!_playlistArr) {
        
        _playlistArr = [NSMutableArray new];
        
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"1.wav" ofType:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"2.flac" ofType:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"3.wav" ofType:@""]];
        
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"4.flac" ofType:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"5.wav" ofType:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"6.mp3" ofType:@""]];
        
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"7.flac" ofType:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"8.mp3" ofType:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] pathForResource:@"9.flac" ofType:@""]];
    }
    
    return _playlistArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlistArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.playlistArr[indexPath.row] lastPathComponent]];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[PlayingInfoViewController class]]) {
     
        PlayingInfoViewController *infoVC = [segue destinationViewController];
        infoVC.playlist = self.playlistArr;
        infoVC.playIndex = [[self.tableView indexPathForSelectedRow] row];
    }
}


@end
