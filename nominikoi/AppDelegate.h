//
//  AppDelegate.h
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/03.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *accoutid;
}

@property (strong, nonatomic) UIWindow *window;
//アカウントのIDを保存するための変数
@property (nonatomic,readwrite) NSString *accoutid;

@end

