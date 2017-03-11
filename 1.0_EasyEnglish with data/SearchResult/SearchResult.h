//
//  SearchResult.h
//  JokePlayer
//
//  Created by apple on 11-12-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResult : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *allDataSource;
    UISearchBar *SearchBarOfSR;
    NSMutableArray * resultDataSource;

}
-(id)initWihtSearchBar:(UISearchBar*) sb WithDataSource:(NSMutableArray*) ds;
-(void)fillResultDataSource: (NSArray*) datasource;
@end
