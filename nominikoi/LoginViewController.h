//
//  LoginViewController.h
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/09.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
//IDを入力するためのテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *IDtextfield;
//パスワードを入力するためのテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *Passtextfield;

@end
