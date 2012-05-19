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
@synthesize isMe = _isMe;

+ (JGAFacebookFriend *)userFromDictionary:(id)result
{
    JGAFacebookFriend *user = [[JGAFacebookFriend alloc] init];
    user.name = [result objectForKey:@"name"];
    user.facebookId = [[result objectForKey:@"id"]intValue];
    user.isMe = NO;
    return user;
    
}

+ (JGAFacebookFriend *)meFromResult:(id)result
{
    JGAFacebookFriend *me = [JGAFacebookFriend userFromDictionary:result];
    me.isMe = YES;
    return me;
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
    
    /* TEST */
#if DEBUG
    JGAFacebookFriend *friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Adam Gregory";
    [array addObject:friend];
    
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Jeff Grant";
    [array addObject:friend];
    
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Barry White";
    [array addObject:friend];
    
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Charlie";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Donnie";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Edgar";
    [array addObject:friend];

    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Mzry";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Mary";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Mfry";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Mcry";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Mxry";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Mtry";
    [array addObject:friend];

    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Larry";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Kevin";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Greg";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Sarah";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Zeus";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Harry";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Tammy";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Vanessa";
    [array addObject:friend];
    friend = [[JGAFacebookFriend alloc] init];
    friend.name = @"Yoomi";
    [array addObject:friend];    
#endif
    
    
    NSArray *descriptors = [NSArray arrayWithObjects:
                            [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    
    
    return [NSMutableArray arrayWithArray:[array sortedArrayUsingDescriptors:descriptors]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%d)", _name, _facebookId];
}

// Returns an array of dictionaries with the section header and the list of friends for that section
+ (NSArray *)indexedFriendsList:(NSMutableArray *)friends
{
    NSMutableDictionary *indexedDictionary = [NSMutableDictionary dictionaryWithCapacity:26];
    
    for (int i = 0; i<friends.count; i++) {
        // Get first letter of name
        JGAFacebookFriend *friend = [friends objectAtIndex:i];
        NSString *firstLetter = [NSString stringWithFormat:@"%C",[friend.name characterAtIndex:0]];
        
        // Add the person to the existing array, otherwise make a new array for that key
        NSMutableArray *nameArray = [indexedDictionary objectForKey:firstLetter];
        if (!nameArray) nameArray = [NSMutableArray arrayWithCapacity:1];
        [nameArray addObject:friend];
        [indexedDictionary setObject:nameArray forKey:firstLetter];
    }
    
    // Extract the objects and keys and put them into a dictionary structure header: 'A', friend: [array]
    NSInteger count = [indexedDictionary count];
    id __unsafe_unretained objects[count];
    id __unsafe_unretained keys[count];
    [indexedDictionary getObjects:objects andKeys:keys];
    
    NSMutableArray *index = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        id key = keys[i];
        id obj = objects[i];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
        [dictionary setObject:key forKey:@"header"];
        [dictionary setObject:obj forKey:@"friends"];
        [index addObject:dictionary];
    }

    return [index sortedArrayUsingComparator:^(id a, id b) {
        NSString *first = [a objectForKey:@"header"];
        NSString *second = [b objectForKey:@"header"];
        return [first compare:second];
    }];
}

@end
