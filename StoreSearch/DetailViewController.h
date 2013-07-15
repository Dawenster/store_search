//
//  DetailViewController.h
//  StoreSearch
//
//  Created by David Wen on 2013-07-13.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResult;

typedef enum {
    DetailViewControllerAnimationTypeSlide,
    DetailViewControllerAnimationTypeFade
} DetailViewControllerAnimationType;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) SearchResult *searchResult;

- (void)presentInParentViewController:(UIViewController *)parentViewController;
- (void)dismissFromParentViewControllerWithAnimationType:(DetailViewControllerAnimationType)animationType;

@end
