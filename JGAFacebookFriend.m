//
//  JGAFacebookFriend.m
//  ticktalk
//
//  Created by John Grant on 12-05-11.
//  Copyright (c) 2012 Healthcare Made Simple. All rights reserved.
//

#import "JGAFacebookFriend.h"

@implementation JGAFacebookFriend
@synthesize name = _name;
@synthesize facebookId = _facebookId;

+ (JGAFacebookFriend *)userFromDictionary:(id)result
{
    JGAFacebookFriend *user = [[JGAFacebookFriend alloc] init];
    user.name = [result objectForKey:@"name"];
    user.facebookId = [[result objectForKey:@"id"]intValue];
    return user;
    
}

+ (JGAFacebookFriend *)meFromResult:(id)result
{
    return [JGAFacebookFriend userFromDictionary:result];
}

+ (NSMutableArray *)friendsArrayFromFacebookResult:(id)result
{
    NSArray *data = [result objectForKey:@"data"];

    int count = data.count;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++){
        id object = [data objectAtIndex:i];
        [array addObject:[JGAFacebookFriend userFromDictionary:object]];
    }
    
    NSArray *descriptors = [NSArray arrayWithObjects:
                            [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    
    return [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:descriptors]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%d)", _name, _facebookId];
}

@end
