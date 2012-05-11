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

+ (JGAFacebookFriend *)meFromResult:(id)result
{
    JGAFacebookFriend *me = [[JGAFacebookFriend alloc] init];
    me.name = [result objectForKey:@"name"];
    me.facebookId = [[result objectForKey:@"id"]intValue];
    return me;
}

+ (NSMutableArray *)friendsArrayFromFacebookResult:(id)result
{
    NSArray *data = [result objectForKey:@"data"];

    int count = data.count;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++){
        id object = [data objectAtIndex:i];
        JGAFacebookFriend *friend = [[JGAFacebookFriend alloc] init];
        friend.name = [object objectForKey:@"name"];
        friend.facebookId = [[object objectForKey:@"id"]intValue];
        [array addObject:friend];
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
