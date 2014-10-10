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
//ログインボタンを押したら呼ばれるメソッド
- (IBAction)login:(id)sender;
//警告メッセージを表示するためのラベル
@property (weak, nonatomic) IBOutlet UILabel *warning;
//backボタンを押したら呼ばれるメソッド
- (IBAction)back:(id)sender;

@end
