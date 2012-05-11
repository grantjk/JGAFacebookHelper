//
//  FacebookHelper.h
//  Thirty3
//
//  Created by John Grant on 11-10-06.
//  Copyright 2011 Mobywan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGAFacebookFriendSelectionViewController.h"

#import "FBConnect.h"

@class JGAFacebookHelper;
@protocol JGAFacebookHelperDelegate <NSObject>

- (void)helperDidLogin:(JGAFacebookHelper *)helper;
- (void)helperDidNotLogin:(JGAFacebookHelper *)helper;

@optional
- (void)helper:(JGAFacebookHelper *)helper didLoadFriends:(NSArray *)friends;
- (void)helper:(JGAFacebookHelper *)helper didUploadPhoto:(NSString *)photoIdString;

- (void)helper:(JGAFacebookHelper *)helper didCompleteRequest:(FBRequest *)request;
- (void)helper:(JGAFacebookHelper *)helper didFailWithRequest:(FBRequest *)request;
@end



@interface JGAFacebookHelper : NSObject <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate, JGAFacebookFriendSelectionViewControllerDelegate>

// Setup
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) NSArray *permissions;

// Delegate
@property (nonatomic, weak) id <NSObject, JGAFacebookHelperDelegate> delegate;

// Requests
@property (nonatomic, strong) FBRequest *meRequest;
@property (nonatomic, strong) FBRequest *friendRequest;
@property (nonatomic, strong) FBRequest *photoPostRequest;

// Friends
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, weak) UIViewController *viewController;

// Photos
@property (nonatomic, strong) NSString *photoIdString;

// Me
@property (nonatomic, strong) JGAFacebookFriend *me;






- (id)initWithDelegate:(id)delegate permissions:(NSArray *)permissions;
- (void)login;
- (FBRequest *)shareImage:(UIImage *)image message:(NSString *)message;
- (FBRequest *)shareImage:(UIImage *)image message:(NSString *)message tagFriendsFromViewController:(UIViewController *)viewController;
- (FBRequest *)postMessage:(NSString *)message;

// link is required
- (void)openDialogWithLink:(NSString *)link name:(NSString *)name caption:(NSString *)caption description:(NSString *)description;

// Friends
- (FBRequest *)getFriendsList;
- (void)showFriendSelectionInViewController:(UIViewController *)vc;

@end
