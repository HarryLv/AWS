//
//  AppDelegate.m
//  APNS
//
//  Created by ll on 2019/4/10.
//  Copyright © 2019 lenovo. All rights reserved.
//
#define IOS10_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending )

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "AWSPinpoint.h"
#import "AWSCore.h"
#import "APNS-BridgeAWS.h"
//#import ""
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (strong, nonatomic) AWSPinpoint *pinpoint;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Register for remote notifications.
    
    [[[BridgeAWS alloc] init] initialize];
    
    AWSPinpointConfiguration *pinpointConfiguration = [AWSPinpointConfiguration defaultPinpointConfigurationWithLaunchOptions:launchOptions];
    self.pinpoint = [AWSPinpoint pinpointWithConfiguration:pinpointConfiguration];
    
    [self registerRemoteNotificationsForApplication:application];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}

#pragma mark Remote Notification
- (void)registerRemoteNotificationsForApplication:(UIApplication *)application {
    
    if (IOS10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                NSLog(@"UNUserNotificationCenter requestAuthorization successfully");
            }else{
                NSLog(@"UNUserNotificationCenter requestAuthorization failed");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken===========%@",deviceString);
    
    [_pinpoint.notificationManager interceptDidRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
   NSString *str = [[_pinpoint.targetingClient currentEndpointProfile ] endpointId];
    NSLog(@"%@",str);
    //TODO: 将token传送给服务器
}

#pragma mark UNUserNotificationCenterDelegate
//app 处于前台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    UNNotificationSound *sound = content.sound;
    NSString *subtitle = content.subtitle;
    NSString *title = content.title;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"will prsent the remote notification:%@",userInfo);
        
    }else {
        NSLog(@"will prsent the local notification:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    UNNotificationRequest *request = response.notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    UNNotificationSound *sound = content.sound;
    NSString *subtitle = content.subtitle;
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"received the remote notification:%@",userInfo);
      
        
    }else {
        NSLog(@"received the local notification:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
