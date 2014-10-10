//
//  LoginViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/09.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//　ログイン画面を管理するクラス

#import "LoginViewController.h"
#import "ChoiceViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    //テキストフィールドのデリゲートを自分自身に指定
    self.IDtextfield.delegate = self;
    self.Passtextfield.delegate = self;
    //テキストフィールドに入力される文字を隠す
    self.Passtextfield.secureTextEntry = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.IDtextfield resignFirstResponder];
    [self.Passtextfield resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.IDtextfield) {
        [self.IDtextfield resignFirstResponder];
    } else if (textField == self.Passtextfield){
        [self.Passtextfield resignFirstResponder];
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    //文字を入力されているか
    if (([self.Passtextfield.text length] == 0) || ([self.IDtextfield.text length] == 0)) {
        self.warning.text = @"文字を入力してください";
        return;
    }
    //半角文字で入力されているか
    if (![self.IDtextfield.text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        self.warning.text = @"IDの入力欄は半角文字で入力してください";
        return;
    }
    //ログイン先のURLを設定
    NSString *urlstr = @"http://smartshinobu.miraiserver.com/login.php?id=(id)&pass=(pass)";
    //文字列(id)をIDtextfieldに入力された文字列に置換
    urlstr = [urlstr stringByReplacingOccurrencesOfString:@"(id)" withString:self.IDtextfield.text];
        //文字列(pass)をIDtextfieldに入力された文字列に置換
    urlstr = [urlstr stringByReplacingOccurrencesOfString:@"(pass)" withString:self.Passtextfield.text];
    //urlstr先のデータを格納
    NSData *data = [self WebData:urlstr];
    //データを元に文字列を生成
    NSString *judgestr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //余計な文字列を削除
    judgestr = [judgestr stringByReplacingOccurrencesOfString:@"<!--/* Miraiserver \"NO ADD\" http://www.miraiserver.com */-->" withString:@""];
    judgestr = [judgestr stringByReplacingOccurrencesOfString:@"<script type=\"text/javascript\" src=\"http://17787372.ranking.fc2.com/analyze.js\" charset=\"utf-8\"></script>" withString:@""];
    //judgestrをNSData型の変数に変換
    NSData *trimdata = [judgestr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    //trimdataをNSDcitionary型の変数に変換
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:trimdata options:NSJSONReadingMutableContainers error:&err];
    //dicの中身が空っぽか
    if (dic == nil) {
        self.warning.text = @"認証失敗";
        return;
    }else{
        [self performSegueWithIdentifier:@"accountsegue" sender:self];
    }
}

//url先のWebのデータを取得するメソッド
//引数urlは、URLを表す文字列
-(NSData*)WebData:(NSString*)url{
    //URLを生成
    NSURL *dataurl = [NSURL URLWithString:url];
    //リクエスト生成
    NSURLRequest *request = [NSURLRequest requestWithURL:dataurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //レスポンスを生成
    NSHTTPURLResponse *response;
    //NSErrorの初期化
    NSError *err = nil;
    //requestによって返ってきたデータを生成
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    //値を返す
    return data;
}
//backボタンを押したら呼ばれるメソッド
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

//画面遷移が行われる前に呼ばれるメソッド
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //セグエの名前がsecondsegueであるか
    if ([[segue identifier] isEqualToString:@"accountsegue"]) {
        ChoiceViewController *cvc = segue.destinationViewController;
        cvc.accoutid = self.IDtextfield.text;
    }
}

@end
