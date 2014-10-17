//
//  NewidcheckViewController.h
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/11.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewidcheckViewController : UIViewController
//選択画面に戻るボタンを押したら呼ばれるメソッド
- (IBAction)choiceback:(id)sender;
//新規取得したIDを表示するためのラベル
@property (weak, nonatomic) IBOutlet UILabel *IDlabel;
@end
