//
//  FRPPhotoCell.m
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import "FRPPhotoCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "FRPPhoto.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation FRPPhotoCell

#pragma mark - NSObject

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    RACMulticastConnection *multicast = [RACObserve(self, photo) publish];
    
    RAC(self.textLabel, text) = [multicast.signal
                                 map:^NSString *(FRPPhoto *photo) {
                                     return photo.title;
                                 }];
    
    @weakify(self);
    
    [multicast.signal subscribeNext:^(FRPPhoto *photo) {
        @strongify(self);
        
        if (photo) {
            NSURL *url = [photo urlForThumbnail];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            
            [self.imageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               @strongify(self);
                                               self.imageView.image = image;
                                               [self setNeedsLayout];
                                           }
                                           failure:nil];
        } else {
            [self.imageView cancelImageRequestOperation];
            self.imageView.image = nil;
        }
    }];
    
    [multicast connect];
}

#pragma mark - UITableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.photo = nil;
}

@end
