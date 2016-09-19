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
        
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"1.wav" withExtension:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"2.flac" withExtension:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"3.wav" withExtension:@""]];
        
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"4.flac" withExtension:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"5.wav" withExtension:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"6.mp3" withExtension:@""]];
        
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"7.flac" withExtension:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"8.mp3" withExtension:@""]];
        [_playlistArr addObject:[[NSBundle mainBundle] URLForResource:@"9.flac" withExtension:@""]];
    }
    
    return _playlistArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlistArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.playlistArr[indexPath.row] absoluteString] lastPathComponent]];
    
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
