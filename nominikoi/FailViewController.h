//
//  FailViewController.h
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/08.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *fukidashi;
@property (weak, nonatomic) IBOutlet UIView *backview;
//アカウントのIDを格納するための変数
@property (nonatomic) NSString* accoutid;

@end
