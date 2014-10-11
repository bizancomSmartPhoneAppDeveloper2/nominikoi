//
//  NewidViewController.h
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/11.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewidViewController : UIViewController
//IDを入力するテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *IDtext;
//パスワードを入力するテキストフィールド
@property (weak, nonatomic) IBOutlet UITextField *Passtext;
//新規登録ボタンを押したら呼ばれるメソッド
- (IBAction)IDadd:(id)sender;
//警告メッセージを表示するためのラベル
@property (weak, nonatomic) IBOutlet UILabel *warning;

@end
