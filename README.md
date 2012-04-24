JGAFacebookHelper
=================

Work in Progress. Trying to make the Facebook sharing experience simpler.


Setup
======
Follow the instructions on [the facebook sdk github page](https://github.com/facebook/facebook-ios-sdk).
import "JGAFacebookHelper.h" wherever you need it

Add the following to your app delegate:

     - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        [[NSNotificationCenter defaultCenter] postNotificationName:kFBHandleOpenUrl object:url];
        return YES;
    }

Add the following to the .pch header file
     code:
    #define kFbId <YOUR_ID_HERE>
    #define kFBHandleOpenUrl @"fbHandleOpenUrl" 

Add an instance of JGAFacebookHelper to your view controller:
`@property (nonatomic, strong) JGAFacebookHelper *fbHelper;`

Make your view controller a delegate of JGAFacebookHelper
`@interface YourViewController : UIViewController <JGAFacebookHelperDelegate>`

Set up Login and Callbacks:
        if (!_fbHelper) {
            self.fbHelper = [[JGAFacebookHelper alloc] initWithDelegate:self];
            [_fbHelper login];
        }else {
            // call your sharing method
        }
 
    - (void)helperDidLogin:(JGAFacebookHelper *)helper
    {
        // call your sharing method
    }
    - (void)helperDidNotLogin:(JGAFacebookHelper *)helper
    {
        // perform any necessary cleanup
    }


Methods
=======
Refer to source code for method calls and delegate reference.


