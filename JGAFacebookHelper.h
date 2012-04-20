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

@optional
- (void)helper:(JGAFacebookHelper *)helper didCompleteRequest:(FBRequest *)request;
- (void)helper:(JGAFacebookHelper *)helper didFailWithRequest:(FBRequest *)request;

@end

@interface JGAFacebookHelper : NSObject <FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>

@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, weak) id <NSObject, JGAFacebookHelperDelegate> delegate;

- (id)initWithDelegate:(id)delegate;
- (void)login;
- (FBRequest *)shareImage:(UIImage *)image message:(NSString *)message;
- (void)openDialogWithName:(NSString *)name caption:(NSString *)caption description:(NSString *)description;
@end
