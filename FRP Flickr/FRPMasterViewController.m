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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    FRPPhoto *photo = self.viewModel.photos[indexPath.row];
    cell.textLabel.text = photo.title;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = self.viewModel.photos[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

#pragma mark - UIVIewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.viewModel.photos[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
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
