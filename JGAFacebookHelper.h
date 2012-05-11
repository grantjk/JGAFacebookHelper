//
//  FacebookHelper.h
//  Thirty3
//
//  Created by John Grant on 11-10-06.
//  Copyright 2011 Mobywan Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBConnect.h"

@class JGAFacebookHelper;
@protocol JGAFacebookHelperDelegate <NSObject>

- (void)helperDidLogin:(JGAFacebookHelper *)helper;
- (void)helperDidNotLogin:(JGAFacebookHelper *)helper;

@optional
- (void)helper:(JGAFacebookHelper *)helper didCompleteRequest:(FBRequest *)request;
- (void)helper:(JGAFacebookHelper *)helper didFailWithRequest:(FBRequest *)request;
@end

@interface JGAFacebookHelper : NSObject <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, weak) id <NSObject, JGAFacebookHelperDelegate> delegate;
@property (nonatomic, strong) NSArray *permissions;

- (id)initWithDelegate:(id)delegate permissions:(NSArray *)permissions;
- (void)login;

// Images
- (FBRequest *)shareImage:(UIImage *)image message:(NSString *)message;

// Share an image and add options for user generated messages and friend tagging
- (FBRequest *)shareImage:(UIImage *)image message:(NSString *)message showOptionsFromViewController:(UIViewController *)vc;

// Messages
- (FBRequest *)postMessage:(NSString *)message;

// link is required
- (void)openDialogWithLink:(NSString *)link name:(NSString *)name caption:(NSString *)caption description:(NSString *)description;
@end
