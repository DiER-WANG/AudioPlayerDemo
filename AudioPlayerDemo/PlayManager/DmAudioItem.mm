//
//  DmAudioItem.m
//  zapyaNewPro
//
//  Created by LiuFei on 7/16/15.
//  Copyright (c) 2015 dongxin. All rights reserved.
//

#import "DmAudioItem.h"
@implementation DmAudioItem

@synthesize title;
@synthesize album;
@synthesize artist;
@synthesize artwork;
@synthesize url;
@synthesize path;
@end

//#import "tag_c.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
//#import "tag.h"

@implementation DmAudioItemManager

+ (DmAudioItem *)getMusicInfo:(NSURL *)fileURL {

    DmAudioItem *audioItem = [[DmAudioItem alloc]init];
    NSString *title;
    NSString *artist;
    NSString *album;
    if ([[fileURL.pathExtension lowercaseString] isEqualToString:@"ape"] || [[fileURL.pathExtension lowercaseString] isEqualToString:@"flac"]) {
//        TagLib_File *file;
//        TagLib_Tag *tag;
//        taglib_set_strings_unicode(TRUE);
//        file = taglib_file_new([path UTF8String]);
//        tag = taglib_file_tag(file);
//        if (tag != NULL) {
//           title = [NSString stringWithCString:(char const *) taglib_tag_title(tag) encoding:NSUTF8StringEncoding];
//            artist = [NSString stringWithCString:(char const *) taglib_tag_artist(tag) encoding:NSUTF8StringEncoding];
//        }
//        taglib_tag_free_strings();
//        taglib_file_free(file);
        
    }else{
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
        NSArray *medieDataList = [asset commonMetadata];
        for (AVMetadataItem *metaItem in medieDataList) {
            NSString *key = [metaItem commonKey];
            if ([key isEqualToString:AVMetadataCommonKeyTitle]) {
                title = [metaItem stringValue];
            }else if ([key isEqualToString:AVMetadataCommonKeyAlbumName]){
                album = [metaItem stringValue];
            }else if ([key isEqualToString:AVMetadataCommonKeyArtist]){
                artist = [metaItem stringValue];
            }
        }
        
    }
    if (title == nil || title.length < 1) {
        title = [fileURL lastPathComponent];
        if (![[fileURL.pathExtension lowercaseString] isEqualToString:@"ape"] && ![[fileURL.pathExtension lowercaseString] isEqualToString:@"flac"]) {
            title = [title stringByDeletingPathExtension];
        }
    }
    if (!artist) {
        artist = @"1";
    }
    if (!album) {
        album = @"1";
    }
    
    audioItem.title     = title;
    audioItem.album     = album;
    audioItem.artist    = artist;
    audioItem.url       = fileURL;
    
    return audioItem;
}

+ (UIImage *)getArtwork:(NSString *)path
{
//    ID3_Tag tag;
//    tag.Link([path UTF8String], ID3TT_ALL);
//    ID3_Frame *frame = tag.Find(ID3FID_PICTURE);
//    if (frame){
//        ID3_Field *field= frame->GetField(ID3FN_DATA);
//        if (field) {
//            const char *value = (char *)field->GetRawBinary();
//            size_t size = field->BinSize();
//            if (size == 0) {
//                return nil;
//            }
//            NSData *data = [NSData dataWithBytes:(void*)value length:size];
//            UIImage *albumImage = [UIImage imageWithData:data];
//            return albumImage;
//        }
//    }
    return nil;
}


@end
