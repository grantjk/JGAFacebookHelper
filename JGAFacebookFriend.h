//
//  JGAFacebookFriend.h
//  ticktalk
//
//  Created by John Grant on 12-05-11.
//  Copyright (c) 2012 Healthcare Made Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGAFacebookFriend : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int facebookId;


+ (NSArray *)friendsArrayFromFacebookResult:(id)result;
@end
