//
//  MusicListEntity.m
//  Ting
//
//  Created by Aufree on 11/13/15.
//  Copyright © 2015 Ting. All rights reserved.
//

#import "MusicSessionEntity.h"

@implementation MusicSessionEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"sessionid" : @"id",
             @"name" : @"name"
             };
}

@end
