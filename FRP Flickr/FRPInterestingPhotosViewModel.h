//
//  FRPInterestingPhotosViewModel.h
//  FRP Flickr
//
//  Created by Don Huff on 7/31/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;


@interface FRPInterestingPhotosViewModel : NSObject

@property (nonatomic, readonly) NSArray *photos;

@property (nonatomic, readonly) RACCommand *refresh;

@end
