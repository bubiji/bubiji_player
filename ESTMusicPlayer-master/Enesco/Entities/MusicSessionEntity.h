//
//  MusicListEntity.h
//  Ting
//
//  Created by Aufree on 11/13/15.
//  Copyright © 2015 Ting. All rights reserved.
//

#import "BaseEntity.h"

@interface MusicSessionEntity : BaseEntity
@property (nonatomic, copy) NSNumber *sessionid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSMutableArray *musics;
@end
