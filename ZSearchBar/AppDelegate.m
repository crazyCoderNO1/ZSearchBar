//
//  AppDelegate.m
//  ZSearchBar
//
//  Created by bigZZZ on 2021/3/18.
//

#import "AppDelegate.h"
#import "ViewControllerB.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ViewControllerB.new];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}


@end
