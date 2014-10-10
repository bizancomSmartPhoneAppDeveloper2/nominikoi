//
//  LoginViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/09.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//　ログイン画面を管理するクラス

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    //テキストフィールドのデリゲートを自分自身に指定
    self.IDtextfield.delegate = self;
    self.Passtextfield.delegate = self;
    
    
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

@end
