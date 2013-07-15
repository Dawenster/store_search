//
//  Search.h
//  StoreSearch
//
//  Created by David Wen on 2013-07-14.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SearchBlock)(BOOL success);

@interface Search : NSObject

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, readonly, strong) NSMutableArray *searchResults;

- (void)performSearchForText:(NSString *)text category:(NSInteger)category completion:(SearchBlock)block;

@end
