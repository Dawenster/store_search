//
//  MenuViewController.m
//  StoreSearch
//
//  Created by David Wen on 2013-07-15.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import "MenuViewController.h"
#import "DetailViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(320, 152);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Send Support Email", @"Menu: Email support");
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"Rate this App", @"Menu: Rate app");
    } else {
        cell.textLabel.text = NSLocalizedString(@"About", @"Menu: About");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self.detailViewController sendSupportEmail];
    }
}

@end
