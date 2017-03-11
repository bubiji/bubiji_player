//
//  MusicEntity.h
//  Ting
//
//  Created by Aufree on 11/13/15.
//  Copyright © 2015 Ting. All rights reserved.
//

#import "BaseEntity.h"

@interface MusicEntity : BaseEntity
@property (nonatomic, copy) NSNumber *musicId; //歌曲id
@property (nonatomic, copy) NSString *name; //歌曲名称
@property (nonatomic, copy) NSString *musicUrl; //歌曲网络地址，暂时无用
@property (nonatomic, copy) NSString *cover; //歌曲封面网络地址
@property (nonatomic, copy) NSString *artistName;//艺术家
@property (nonatomic, copy) NSString *fileName;//歌曲本地地址
@property (nonatomic, assign) BOOL isFavorited;//是否喜欢
@end