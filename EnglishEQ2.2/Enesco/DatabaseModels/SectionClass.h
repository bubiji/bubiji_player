//
//  SectionClass.h
//  Enesco
//
//  Created by wangjie on 16/6/2.
//  Copyright © 2016年 aufree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordClass.h"

@interface SectionClass : NSObject
@property(nonatomic,copy) NSString *sectionName;
@property(nonatomic,retain) NSMutableArray *records;
@end
