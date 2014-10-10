//
//  ChoiceViewController.h
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/03.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//　行きたい居酒屋の条件を選択する画面を管理するクラス

#import <UIKit/UIKit.h>


@interface ChoiceViewController : UIViewController{
    NSString *accountid;
}
//徒歩時間を選ぶためのUIPicker
@property (weak, nonatomic) IBOutlet UIPickerView *timepicker;
//予算を選ぶためのUIPicker
@property (weak, nonatomic) IBOutlet UIPickerView *moneypicker;
//アカウントのIDを格納するための変数
@property (nonatomic) NSString* accoutid;
//注文ボタンを押したら呼ばれるメソッド
- (IBAction)start:(id)sender;
//ログイン関係のボタンを押したら呼ばれるメソッド
- (IBAction)idsegue:(id)sender;
//ログイン関係のボタン
@property (weak, nonatomic) IBOutlet UIButton *logbutton;
- (IBAction)history:(id)sender;


@end
