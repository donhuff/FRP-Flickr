//
//  FRPMasterViewController.m
//  FRP Flickr
//
//  Created by Don Huff on 7/30/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import "FRPMasterViewController.h"

#import "FRPDetailViewController.h"
#import "FRPInterestingPhotosViewModel.h"
#import "FRPPhoto.h"
#import "FRPPhotoCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>


@interface FRPMasterViewController ()

@property (nonatomic, getter = isFirstAppearanceHandled) BOOL firstAppearanceHandled;
@property (nonatomic, readonly) FRPInterestingPhotosViewModel *viewModel;

@end


@implementation FRPMasterViewController

@synthesize viewModel = _viewModel;

#pragma mark - Private

- (FRPInterestingPhotosViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [FRPInterestingPhotosViewModel new];
    }
    
    return _viewModel;
}

#pragma mark - NSObject

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRPPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSAssert([cell isKindOfClass:FRPPhotoCell.class], @"Expected FRPPhotoCell: %@.", cell);
    
    cell.photo = self.viewModel.photos[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController.photo = self.viewModel.photos[indexPath.row];
    }
}

#pragma mark - UIVIewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FRPPhoto *photo = self.viewModel.photos[indexPath.row];
        ((FRPDetailViewController *)segue.destinationViewController).photo = photo;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.isFirstAppearanceHandled) {
        self.firstAppearanceHandled = YES;
        [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
        CGPoint contentOffset = self.tableView.contentOffset;
        contentOffset.y -= CGRectGetHeight(self.refreshControl.frame);
        self.tableView.contentOffset = contentOffset;
        [self.refreshControl beginRefreshing];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewController = (FRPDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.rac_command = self.viewModel.refresh;
    
    @weakify(self);
    
    [RACObserve(self.viewModel, photos) subscribeNext:^(id _){
        @strongify(self);
        [self.tableView reloadData];
    }];
}

@end
