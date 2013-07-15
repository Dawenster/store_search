//
//  ViewController.h
//  StoreSearch
//
//  Created by David Wen on 2013-07-13.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) DetailViewController *detailViewController;

@end
