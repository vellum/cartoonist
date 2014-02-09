//
//  VLMAppDelegate.m
//  ABCD
//
//  Created by David Lu on 11/19/13.
//  Copyright (c) 2013 David Lu. All rights reserved.
//

#import "VLMAppDelegate.h"
#import "VLMViewController.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "UIImage+Resize.h"
#import "UIImage+Alpha.h"

//#define PRINT_AVAILABLE_FONT_NAMES 1

@implementation VLMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Add a custom read-only cache path
    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Images"];
    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
    
    [[SDWebImageManager sharedManager] setDelegate:self];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];

    self.viewController = [[VLMViewController alloc] init];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
#ifdef PRINT_AVAILABLE_FONT_NAMES
    for (NSString *family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        for (NSString *name in [UIFont fontNamesForFamilyName:family]) {
            NSLog(@"\t\t%@", name);
        }
    }
#endif
    
    return YES;
}

- (BOOL)imageManager:(SDWebImageManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL
{
    return YES;
}

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    CGSize itemSize = kItemSize;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage *resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                        bounds:CGSizeMake(itemSize.height*scale, itemSize.height*scale)
                                          interpolationQuality:kCGInterpolationHigh];
    return resizedImage;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
