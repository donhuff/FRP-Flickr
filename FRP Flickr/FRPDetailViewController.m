//
//  FRPDetailViewController.m
//  FRP Flickr
//
//  Created by Don Huff on 7/30/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import "FRPDetailViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FRPPhoto.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface FRPDetailViewController () <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end


@implementation FRPDetailViewController

#pragma mark - Managing the detail item

- (void)setPhoto:(FRPPhoto *)photo
{
    _photo = photo;
    
    if (self.masterPopoverController) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    
    RACMulticastConnection *photoConnection = [RACObserve(self, photo) publish];
    
    RAC(self.navigationItem, title) = [photoConnection.signal
                                       map:^NSString *(FRPPhoto *photo) {
                                           return photo.title;
                                       }];
    
    [photoConnection.signal subscribeNext:^(FRPPhoto *photo) {
        @strongify(self);
        
        if (!photo) {
            [self.imageView cancelImageRequestOperation];
            self.imageView.image = nil;
            return;
        }
        
        [self.imageView setImageWithURL:[photo url]];
    }];
    
    [photoConnection connect];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Photos", @"Photos");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
