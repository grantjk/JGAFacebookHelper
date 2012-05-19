//
//  FacebookHelper.m
//  Thirty3
//
//  Created by John Grant on 11-10-06.
//  Copyright 2011 Mobywan Corporation. All rights reserved.
//

#import "JGAFacebookHelper.h"
#import "JGAFacebookFriend.h"
#import "JGAFacebookFriendSelectionViewController.h"

#define kbAccessKey @"FBAccessTokenKey"
#define kFbExpirationDate @"FBExpirationDateKey"

@implementation JGAFacebookHelper

@synthesize facebook = _facebook;
@synthesize delegate = _delegate;
@synthesize permissions = _permissions;
@synthesize meRequest = _meRequest;
@synthesize friendRequest = _friendRequest;
@synthesize photoPostRequest = _photoPostRequest;
@synthesize friends = _friends;
@synthesize photoIdString = _photoIdString;
@synthesize me = _me;
@synthesize viewController = _viewController;

- (id)initWithDelegate:(id)delegate permissions:(NSArray *)permissions
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.permissions = permissions;
        self.friends = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

-(void)checkForSavedFBToken
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:kbAccessKey] 
        && [defaults objectForKey:kFbExpirationDate]) {
        _facebook.accessToken = [defaults objectForKey:kbAccessKey];
        _facebook.expirationDate = [defaults objectForKey:kFbExpirationDate];
    }
}

- (void)handleOpenURL:(NSNotification *)notification
{
    [self.facebook handleOpenURL:notification.object];
}

- (void)login{
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(handleOpenURL:) 
                                                 name:kFBHandleOpenUrl 
                                               object:nil];
    
    self.facebook = [[Facebook alloc] initWithAppId:kFbId andDelegate:self];
    [self checkForSavedFBToken];

    if (![_facebook isSessionValid]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoggingIn object:nil];
        [_facebook authorize:_permissions];
    }else {
        [self fbDidLogin];
    }
}

- (FBRequest *)getFriendsList
{
    return [self getFriendsListAndShowInViewController:nil];
}

- (FBRequest *)getFriendsListAndShowInViewController:(UIViewController *)viewController
{
    if(viewController) self.viewController = viewController;
    
    // If we don't have current user, then fetch them as well
    if (!_me) {
        // Reset friends
        [_friends removeAllObjects];
        
        // Can't pass nil in params as it removes the token
        self.meRequest = [_facebook requestWithGraphPath:@"me" andDelegate:self];
        return _meRequest;
    }else {
        // Reset friends but add me back
        [_friends removeAllObjects];
        [_friends addObject:_me];
        
        self.friendRequest = [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
        return _friendRequest;
    }
}

#pragma mark - Post Photo
- (FBRequest *)shareImage:(UIImage *)image message:(NSString *)message
{
    return [self shareImage:image message:message tagFriendsFromViewController:nil];
}

- (FBRequest *)shareImage:(UIImage *)image message:(NSString *)message tagFriendsFromViewController:(UIViewController *)viewController
{
    if (!image) return nil;
    if (viewController) self.viewController = viewController;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:image forKey:@"picture"];
    if(message)[params setObject:message forKey:@"name"];
    
    self.photoPostRequest = [_facebook requestWithGraphPath:@"me/photos" 
                                                  andParams:params
                                              andHttpMethod:@"POST"
                                                andDelegate:self];
    return _photoPostRequest;    
}

- (FBRequest *)postMessage:(NSString *)message
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    if(message)[params setObject:message forKey:@"message"];
    
    return [_facebook requestWithGraphPath:@"me/feed" 
                                 andParams:params
                             andHttpMethod:@"POST"
                               andDelegate:self];
}

#pragma mark - Open Dialog
- (void)openDialogWithLink:(NSString *)link name:(NSString *)name caption:(NSString *)caption description:(NSString *)description
{
    if ([_facebook isSessionValid]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
        [params setObject:kFbId forKey:@"app_id"];
        [params setObject:link forKey:@"link"];
        if (name) [params setObject:name forKey:@"name"];
        if (caption) [params setObject:caption forKey:@"caption"];
        if (description) [params setObject:description forKey:@"description"];
        
        [_facebook dialog:@"feed" andParams:params andDelegate:self];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoggingIn object:nil];
        [_facebook authorize:nil];
    }    
}

#pragma mark - FB Delegate
- (void)fbDidLogin 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    // notify delegate we logged in
    if ([_delegate respondsToSelector:@selector(helperDidLogin:)]) {
        [_delegate helperDidLogin:self];
    }
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    [_delegate helperDidNotLogin:self];
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{

}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    
}


/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{

}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    if (request == _photoPostRequest){
        self.photoIdString = [result objectForKey:@"id"];
        
        // If we already know the view controller, just get the friends
        if (_viewController) {
            [self getFriendsListAndShowInViewController:_viewController];
        }else {
            [_delegate helper:self didUploadPhoto:_photoIdString];
        }
    }
    else if (request == _meRequest) {
        self.me = [JGAFacebookFriend meFromResult:result];
        [_friends addObject:_me];
        self.friendRequest = [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
    }
    else if (request == _friendRequest) {
        [_friends addObjectsFromArray:[JGAFacebookFriend friendsArrayFromFacebookResult:result]];
        
        // If the view controller was originall passed in, then show the view controller
        if (_viewController) {
            [self showFriendSelectionInViewController:_viewController];
        }
        // Otherwise just notify the delegate
        else {
            [_delegate helper:self didLoadFriends:_friends];
        }
    }
    else {
        [_delegate helper:self didCompleteRequest:request];
    }
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(helper:didFailWithRequest:)]) {
        DLog(@"Facebook Error -> %@", error);
        [_delegate helper:self didFailWithRequest:request];
    }else{
        NSString *message = @"An error occured posting to facebook. Please try again later.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                        message: message 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark - FB Dialog
- (void)dialogDidComplete:(FBDialog *)dialog{
    DLog(@"complete");
}
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
    DLog(@"Error -> %@", error);
}
- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    DLog(@"did not complete");
}

#pragma mark - Friend Selection
- (void)showFriendSelectionInViewController:(UIViewController *)vc
{
    JGAFacebookFriendSelectionViewController *selectionController = [[JGAFacebookFriendSelectionViewController alloc] 
                                                                     initWithStyle:UITableViewStylePlain
                                                                     friends: _friends];
    selectionController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectionController];
    [vc.navigationController presentModalViewController:nav animated:YES];
}

#pragma mark - Friend Selection Delegate
- (void)controllerDidCancel:(JGAFacebookFriendSelectionViewController *)controller
{
    [_delegate helper:self didCompleteRequest:nil];
}
- (void)controller:(JGAFacebookFriendSelectionViewController *)controller didSelectFriends:(NSArray *)friends
{
    [self tagFriends:friends];
}

#pragma mark - Friend Tagging
- (void)tagFriends:(NSArray *)friends
{
    if(friends.count == 0) return;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableString *tags = [NSMutableString stringWithFormat:@"["];
    
    for (int i = 0; i<friends.count; i++) {
        JGAFacebookFriend *friend = [friends objectAtIndex:i];
        [tags appendString:[NSString stringWithFormat:@"{tag_uid: \"%d\"}", friend.facebookId]];
        
        if (i != friends.count -1) {
            [tags appendString:@","];
        }
    }
    [tags appendString:@"]"];
    
    [params setObject:tags forKey:@"tags"];
    NSString *photoPath = [NSString stringWithFormat:@"%@/tags", _photoIdString];
    
    [_facebook requestWithGraphPath:photoPath 
                          andParams:params
                      andHttpMethod:@"POST" 
                        andDelegate:self];
    
}


@end
