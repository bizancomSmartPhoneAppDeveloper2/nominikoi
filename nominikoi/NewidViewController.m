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
    //半角記号を格納している配列
    NSArray *markarray = [[NSArray alloc]initWithObjects:@"-",@"+",@"^",@"!",@"*",@"[",@"]",@"#",@"\"",
        @"'",@"%%",@"=",@"(",@")",@"{",@"}",@"_",@"|",@":",@";",@"<",@">",@"/",@" ",@"`",@",",@".",@"@",@"$",@"~",@"¥",@"?",nil];
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
        self.warning.text = @"IDの入力欄は\n半角英数文字で入力してください";
        return;
    }
    
    //IDの入力欄に半角記号が入力されていないかをチェック
    for (NSInteger i = 0; i < [self.IDtext.text length]; i++) {
        //1文字を取り出しチェックする
        NSString *IDchar = [NSString stringWithFormat:@"%C",[self.IDtext.text characterAtIndex:i]];
        if ([markarray containsObject:IDchar]) {
            //半角記号が入力されていた場合は警告をだし処理終了
            self.warning.text = @"IDの入力欄に\n半角記号を入力しないでください";
            return;
        }
    }
    
    //パスワードの入力欄に半角記号が入力されていないかをチェック
    for (NSInteger n = 0;n < [self.Passtext.text length]; n++) {
        //1文字を取り出しチェックする
        NSString *Passchar = [NSString stringWithFormat:@"%C",[self.Passtext.text characterAtIndex:n]];
        if ([markarray containsObject:Passchar]) {
            //半角記号が入力されていた場合は警告をだし処理終了
            self.warning.text = @"パスワードの入力欄に\n半角記号を入力しないでください";
            return;
        }
    }
    
    //IDの文字数をチェック(6文字未満、12文字より大きいか)
    if (([self.IDtext.text length] < 6) || ([self.IDtext.text length] > 12)) {
        self.warning.text = @"IDは\n6文字以上12文字以下にしてください";
        return;
    }
    
    //パスワードの文字数をチェック(4文字未満、10文字より大きいか)
    if (([self.Passtext.text length] < 4) || ([self.Passtext.text length] > 10)) {
        self.warning.text = @"パスワードは\n4文字以上10文字以下にしてください";
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
