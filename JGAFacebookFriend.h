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
@property (nonatomic, assign) BOOL isMe;
@property (nonatomic, assign) int facebookId;

+ (JGAFacebookFriend *)meFromResult:(id)result;
+ (NSMutableArray *)friendsArrayFromFacebookResult:(id)result;

// Returns an array of dictionaries with the section header and the list of friends for that section
+ (NSArray *)indexedFriendsList:(NSMutableArray *)friends;
@end
