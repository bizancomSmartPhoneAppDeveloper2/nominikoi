//
//  NewidViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/11.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//新規登録画面を管理するクラス

#import "NewidViewController.h"
#import "Webreturn.h"
#import "NewidcheckViewController.h"

@interface NewidViewController ()<UITextFieldDelegate>

@end

@implementation NewidViewController

- (void)viewDidLoad {
    //warningを非表示
    self.warning.hidden = YES;
    //テキストフィールドのデリゲートを自分自身に指定
    self.IDtext.delegate = self;
    self.Passtext.delegate = self;
    //パスワードを入力するテキストフィールドに入力される文字を隠す
    self.Passtext.secureTextEntry = YES;
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

//画面をタップしたときに呼ばれるメソッド
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //キーボードを閉じる
    [self.IDtext resignFirstResponder];
    [self.Passtext resignFirstResponder];
}

//キーボードのリターンキーを押したときに呼ばれるメソッド
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //編集しているテキストフィールドがIDを入力するテキストフィールドであるか
    if (textField == self.IDtext) {
        [self.IDtext resignFirstResponder];
    }
    //編集しているテキストフィールドがパスワードを入力するテキストフィールドであるか
    else if (textField == self.Passtext){
        [self.Passtext resignFirstResponder];
    }
    return YES;
}

- (IBAction)IDadd:(id)sender {
    //warningを表示
    self.warning.hidden = NO;
    //文字を入力されているか
    if (([self.Passtext.text length] == 0) || ([self.IDtext.text length] == 0)) {
        //警告をだし処理終了
        self.warning.text = @"テキストフィールドが空欄です";
        return;
    }
    //半角文字で入力されているか
    if (![self.IDtext.text canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        //警告をだし処理終了
        self.warning.text = @"IDの入力欄は\n半角文字で入力してください";
        return;
    }
    
    if ([self.Passtext.text length] < 4) {
        self.warning.text = @"パスワードは\n4文字以上にしてください";
        return;
    }
    //新規登録プログラムのURLを設定
    NSString *serverurl = @"http://smartshinobu.miraiserver.com/nominikoi/IDadd.php?id=(id)&pass=(pass)";
    //文字列(id)をIDtextに入力された文字列に置換
    serverurl = [serverurl stringByReplacingOccurrencesOfString:@"(id)" withString:self.IDtext.text];
    //文字列(pass)をPasstextに入力された文字列に置換
    serverurl = [serverurl stringByReplacingOccurrencesOfString:@"(pass)" withString:self.Passtext.text];
    //serverurl先のデータを格納
    NSData *data = [Webreturn ServerData:serverurl];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    //dicの中身が空でないか
    if (dic != nil) {
        //dicのキー「result」の値が1であるか
        //新規登録するアカウントが使われていないか
        if ([[dic objectForKey:@"result"] isEqualToString:@"1"]) {
            //登録確認画面に移る
            [self performSegueWithIdentifier:@"IDaddsegue" sender:self];
        }
        else{
            //警告を出し処理終了
            self.warning.text = @"入力したアカウントは\n使われています。";
            return;
        }
    }else{
        //警告を出し処理終了
        self.warning.text = @"サーバーに\n不具合があります";
        return;
    }
    
}

//画面遷移が行われる前に呼ばれるメソッド
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //セグエの名前がIDaddsegueであるか
    if ([[segue identifier] isEqualToString:@"IDaddsegue"]) {
        NewidcheckViewController *nic = segue.destinationViewController;
        //cvcのaccountidにID入力用のテキストフィールドに入力した文字列を格納
        nic.accoutid = self.IDtext.text;
    }
}
@end
