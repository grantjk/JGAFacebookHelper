//
//  FacebookHelper.m
//  Thirty3
//
//  Created by John Grant on 11-10-06.
//  Copyright 2011 Mobywan Corporation. All rights reserved.
//

#import "JGAFacebookHelper.h"

#define kbAccessKey @"FBAccessTokenKey"
#define kFbExpirationDate @"FBExpirationDateKey"

@implementation JGAFacebookHelper

@synthesize facebook = _facebook;
@synthesize delegate = _delegate;
@synthesize permissions = _permissions;

- (id)initWithDelegate:(id)delegate permissions:(NSArray *)permissions
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.permissions = permissions;
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

#pragma mark - Post Photo
- (FBRequest *)shareImage:(UIImage *)image message:(NSString *)message
{
    if (!image) return nil;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:image forKey:@"picture"];
    if(message)[params setObject:message forKey:@"message"];
    
    return [_facebook requestWithGraphPath:@"me/photos" 
                                 andParams:params
                             andHttpMethod:@"POST"
                               andDelegate:self];
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
    if ([_delegate respondsToSelector:@selector(helper:didCompleteRequest:)]) {
        [_delegate helper:self didCompleteRequest:request];
    }
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(helper:didFailWithRequest:)]) {
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
/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog{
    DLog(@"complete");
    // temp code for testing
        [_facebook logout];
}
/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
    DLog(@"Error -> %@", error);
    // temp code for testing
    [_facebook logout];

}
- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    DLog(@"did not complete");
    // temp code for testing
    [_facebook logout];
    
}

@end
