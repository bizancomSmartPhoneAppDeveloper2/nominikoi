//
//  NewidcheckViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/11.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "NewidcheckViewController.h"
#import "ChoiceViewController.h"
#import "AppDelegate.h"

@interface NewidcheckViewController ()

@end

@implementation NewidcheckViewController

- (void)viewDidLoad {
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    //新規登録したID名をラベルで表示
    self.IDlabel.text = delegate.accoutid;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//選択画面に戻るボタンを押したらメソッド
- (IBAction)choiceback:(id)sender {
    //Newidbacksegueという名前のセグエを実行
    [self performSegueWithIdentifier:@"Newidbacksegue" sender:self];
}

@end
