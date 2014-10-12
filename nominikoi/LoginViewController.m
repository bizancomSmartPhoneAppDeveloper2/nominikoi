//
//  LoginViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/09.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//　ログイン画面を管理するクラス

#import "LoginViewController.h"
#import "ChoiceViewController.h"
#import "Webreturn.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    //警告用のラベルを非表示
    self.warning.hidden = YES;
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

//画面をタップしたときに呼ばれるメソッド
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //キーボードを閉じる
    [self.IDtextfield resignFirstResponder];
    [self.Passtextfield resignFirstResponder];
}

//キーボードのリターンキーを押したときに呼ばれるメソッド
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //編集しているテキストフィールドがIDを入力するテキストフィールドであるか
    if (textField == self.IDtextfield) {
        [self.IDtextfield resignFirstResponder];
    }
    //編集しているテキストフィールドがパスワードを入力するテキストフィールドであるか
    else if (textField == self.Passtextfield){
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

//ログインボタンを押したときに呼ばれるメソッド
- (IBAction)login:(id)sender {
    self.warning.hidden = NO;
    //文字を入力されているか
    if (([self.Passtextfield.text length] == 0) || ([self.IDtextfield.text length] == 0)) {
        //警告をだし処理終了
        self.warning.text = @"テキストフィールドが空欄です";
        return;
    }
    //半角文字で入力されているか
    if (![self.IDtextfield.text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        //警告をだし処理終了
        self.warning.text = @"IDの入力欄は\n半角文字で入力してください";
        return;
    }
    //ログインプログラムのURLを設定
    NSString *urlstr = @"http://smartshinobu.miraiserver.com/nominikoi/login.php?id=(id)&pass=(pass)";
    //文字列(id)をIDtextfieldに入力された文字列に置換
    urlstr = [urlstr stringByReplacingOccurrencesOfString:@"(id)" withString:self.IDtextfield.text];
        //文字列(pass)をIDtextfieldに入力された文字列に置換
    urlstr = [urlstr stringByReplacingOccurrencesOfString:@"(pass)" withString:self.Passtextfield.text];
    //judgestrをNSData型の変数に変換
    NSData *data = [Webreturn ServerData:urlstr];
    NSError *err;
    //dataをNSDcitionary型の変数に変換
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    //dicの中身が空っぽか(IDとパスワードがあているかどうか)
    if (dic == nil) {
        self.warning.text = @"IDかパスワードが\n間違っています";
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
