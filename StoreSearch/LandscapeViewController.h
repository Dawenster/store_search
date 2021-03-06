//
//  LandscapeViewController.h
//  StoreSearch
//
//  Created by David Wen on 2013-07-14.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Search;

@interface LandscapeViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) Search *search;

- (void)searchResultsReceived;

@end
