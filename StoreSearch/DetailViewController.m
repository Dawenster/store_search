//
//  DetailViewController.m
//  StoreSearch
//
//  Created by David Wen on 2013-07-13.
//  Copyright (c) 2013 David Wen. All rights reserved.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchResult.h"
#import "UIImageView+AFNetworking.h"
#import "GradientView.h"
#import "MenuViewController.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *kindLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *storeButton;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) UIPopoverController *masterPopoverController;
@property (nonatomic, strong) UIPopoverController *menuPopoverController;

@end

@implementation DetailViewController {
    GradientView *gradientView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)layoutForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGRect rect = self.closeButton.frame;
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        rect.origin = CGPointMake(28, 87);
    } else {
        rect.origin = CGPointMake(108, 7);
    }
    self.closeButton.frame = rect;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutForInterfaceOrientation:toInterfaceOrientation];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateUI
{
    self.nameLabel.text = self.searchResult.name;
    
    NSString *artistName = self.searchResult.artistName;
    if (artistName == nil) {
        artistName = NSLocalizedString(@"Unknown", @"Unknown artist name");
    }
    
    self.artistNameLabel.text = artistName;
    self.kindLabel.text = [self.searchResult kindForDisplay];
    self.genreLabel.text = self.searchResult.genre;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:self.searchResult.currency];
    self.priceLabel.text = [formatter stringFromNumber:self.searchResult.price];
    
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:self.searchResult.artworkURL100] placeholderImage:[UIImage imageNamed:@"DetailPlaceholder"]];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.backgroundView.hidden = NO;
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    UIImage *image = [[UIImage imageNamed:@"StoreButton"] stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    [self.storeButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundView.layer.borderWidth = 3.0f;
    self.backgroundView.layer.cornerRadius = 10.0f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground"]];
        self.backgroundView.hidden = (self.searchResult == nil);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(menuButtonPressed:)];
    }
    
    if (self.searchResult != nil) {
        [self updateUI];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentInParentViewController:(UIViewController *)parentViewController
{
    gradientView = [[GradientView alloc] initWithFrame:parentViewController.view.bounds];
    [parentViewController.view addSubview:gradientView];
    self.view.frame = parentViewController.view.bounds;
    [self layoutForInterfaceOrientation:parentViewController.interfaceOrientation];
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    bounceAnimation.duration = 0.4;
    bounceAnimation.delegate = self;
    
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.7f],
                              [NSNumber numberWithFloat:1.2f],
                              [NSNumber numberWithFloat:0.9f],
                              [NSNumber numberWithFloat:1.0f],
                              nil];
    
    bounceAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.334f],
                                [NSNumber numberWithFloat:0.666f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
    
    bounceAnimation.timingFunctions = [NSArray arrayWithObjects:
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                       nil];
    
    [self.view.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    fadeAnimation.duration = 0.1;
    [gradientView.layer addAnimation:fadeAnimation forKey:@"fadeAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self didMoveToParentViewController:self.parentViewController];
}

- (IBAction)close:(id)sender
{
    [self dismissFromParentViewControllerWithAnimationType:DetailViewControllerAnimationTypeSlide];
}

- (void)dismissFromParentViewControllerWithAnimationType:(DetailViewControllerAnimationType)animationType;
{
    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.4 animations:^{
        if (animationType == DetailViewControllerAnimationTypeSlide) {
            CGRect rect = self.view.bounds;
            rect.origin.y += rect.size.height;
            self.view.frame = rect;
        } else {
            self.view.alpha = 0.0f;
        }
        gradientView.alpha = 0.0f;
    }
    completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [gradientView removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)openInStore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.searchResult.storeURL]];
}

- (void)setSearchResult:(SearchResult *)newSearchResult
{
    if (_searchResult != newSearchResult) {
        _searchResult = newSearchResult;
        
        if ([self isViewLoaded]) {
            [self updateUI];
        }
    }
}

- (void)menuButtonPressed:(UIBarButtonItem *)sender
{
    if ([self.masterPopoverController isPopoverVisible]) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
    if ([self.menuPopoverController isPopoverVisible]) {
        [self.menuPopoverController dismissPopoverAnimated:YES];
    } else {
        [self.menuPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (UIPopoverController *)menuPopoverController
{
    if (_menuPopoverController == nil) {
        MenuViewController *menuViewController = [[MenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
        menuViewController.detailViewController = self;
        _menuPopoverController = [[UIPopoverController alloc] initWithContentViewController:menuViewController];
    }
    return _menuPopoverController;
}

- (void)sendSupportEmail
{
    [self.menuPopoverController dismissPopoverAnimated:YES];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if (picker != nil) {
        [picker setSubject:NSLocalizedString(@"Support Request", @"Email subject")];
        [picker setToRecipients:[NSArray arrayWithObject:@"david@justsaywen.com"]];
        
        picker.modalPresentationStyle = UIModalPresentationFormSheet;
        picker.mailComposeDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
    [self.artworkImageView cancelImageRequestOperation];
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Search", @"Split-view master button");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)splitViewController:(UISplitViewController *)splitController
          popoverController:(UIPopoverController *)popoverController
  willPresentViewController:(UIViewController *)viewController
{
    if ([self.menuPopoverController isPopoverVisible]) {
        [self.menuPopoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
