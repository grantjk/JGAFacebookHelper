//
//  JGATTFacebookFriendSelectionViewController.h
//  ticktalk
//
//  Created by John Grant on 12-05-11.
//  Copyright (c) 2012 Healthcare Made Simple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGAFacebookFriendSelectionViewController;
@protocol JGAFacebookFriendSelectionViewControllerDelegate <NSObject>
- (void)controller:(JGAFacebookFriendSelectionViewController *)controller didSelectFriends:(NSArray *)friends;
@end

@class JGAFacebookFriend;
@interface JGAFacebookFriendSelectionViewController : UITableViewController

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *selectedFriends;
@property (nonatomic, weak) id <NSObject, JGAFacebookFriendSelectionViewControllerDelegate> delegate;

@end
