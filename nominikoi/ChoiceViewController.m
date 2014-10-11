//
//  ChoiceViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/03.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//
//選択画面を管理するクラス

#import "ChoiceViewController.h"
#import "MainViewController.h"
#import "Webreturn.h"

@interface ChoiceViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate>{
    //選択する時間の要素を格納する配列
    NSArray *timearray;
    //選択する予算の要素を格納する配列
    NSArray *moneyarray;
    //行った店の履歴の情報を格納する配列
    NSMutableArray *shoparray;
    //削除する店を確認するためのアラート
    UIAlertView *NGAlert;
    //削除を行う店の情報を格納するための辞書
    NSDictionary *NGdic;
}

@end

@implementation ChoiceViewController

- (void)viewDidLoad {
    NSLog(@"%@",self.accoutid);
    self.IDlabel.text = @"ID:";
    [self.logbutton setTitle:@"" forState:UIControlStateNormal];
    //文字列accoutidの長さが0より大きいか
    if ([self.accoutid length] > 0) {
        //ボタンの画像をログアウト用の画像にする
        [self.logbutton setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
        
        self.IDlabel.text = [self.IDlabel.text stringByAppendingString:self.accoutid];
    }else{
        //ボタンの画像をログイン用の画像にする
        [self.logbutton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
        //IDlabelを非表示
        self.IDlabel.hidden = YES;
    }
    //2つのpickerのデリゲートとデータソースを自分自身に設定
    self.timepicker.delegate = self;
    self.timepicker.dataSource = self;
    self.moneypicker.delegate = self;
    self.moneypicker.dataSource = self;
    //選択中の行に目印をつけるようにする
    self.timepicker.showsSelectionIndicator = YES;
    self.moneypicker.showsSelectionIndicator = NO;
    //配列の初期化
    timearray = [NSArray arrayWithObjects:@"5分", @"10分",@"15分",nil];
    moneyarray = [NSArray arrayWithObjects:@"〜2000円",@"2000〜3000円",@"3000〜4000円",@"4000〜5000円",@"制限なし", nil];
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

//UIPickerの列数を決めるメソッド
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//UIPickerの行数を決めるメソッド
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //pickerViewがtimepickerと同じであるか
    if (pickerView == self.timepicker) {
        //行数をtimearrayの要素の数とする
            return [timearray count];
    } else{
         //行数をmoneyarrayの要素の数とする
        return [moneyarray count];
    }
    
}

//ピッカーに表示する内容を設定するためのメソッド
//引数rowに行番号、componentに列番号が渡されている
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //pickerViewがtimepickerと同じであるか
    if (pickerView == self.timepicker) {
        //timearrayの要素を返す
        return [timearray objectAtIndex:row];
    }else{
        //moneyarrayの要素を返す
    return [moneyarray objectAtIndex:row];
    }
}

//注文ボタンを押したらよばれるメソッド
- (IBAction)start:(id)sender {
    //名前がsecondsegueであるセグエを実行
     [self performSegueWithIdentifier:@"secondsegue" sender:self];
}

//ログインボタンを押したらよばれるメソッド
- (IBAction)idsegue:(id)sender {
    if ([self.accoutid length] > 0) {
        //accoutidを空にする
        self.accoutid = nil;
        //ボタンの画像をログイン用の画像にする
        [self.logbutton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
        //IDlabelを非表示
        self.IDlabel.hidden = YES;
    }else{
    //名前がsecondsegueであるセグエを実行
    [self performSegueWithIdentifier:@"loginsegue" sender:self];
    }
}



//画面遷移が行われる前に呼ばれるメソッド
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //セグエの名前がsecondsegueであるか
    if ([[segue identifier] isEqualToString:@"secondsegue"]) {
        MainViewController *maincon = segue.destinationViewController;
        //mapcon.timestrにtimepickerで選んだ要素を格納
        maincon.timestr = [timearray objectAtIndex:[self.timepicker selectedRowInComponent:0]];
        //mapcon.moneyにmoneypickerで選んだ要素を格納
        maincon.moneystr = [moneyarray objectAtIndex:[self.moneypicker selectedRowInComponent:0]];
        //文字列accouidの長さが0より大きいか
        if ([self.accoutid length] > 0) {
            //次の画面もログイン状態を維持
            maincon.accoutid = self.accoutid;
        }
    }
}

//履歴ボタンを押したら呼ばれるメソッド
- (IBAction)history:(id)sender {
    shoparray = [NSMutableArray array];
    //文字列accoutidの長さが0より大きいか(ログイン状態であるか)
    if ([self.accoutid length] > 0) {
        //Webreturn型の変数を格納
        Webreturn *web = [[Webreturn alloc]init];
        //履歴のデータをとってくるURLを格納
        NSString *urlstr = @"http://smartshinobu.miraiserver.com/shophistory.php?id=";
        //urlstrの末尾にアカウントIDを追加
        urlstr = [urlstr stringByAppendingString:self.accoutid];
        //urlstr先のデータを格納
        NSData *data = [web ServerData:urlstr];
        NSError *err;
        //jsonデータを格納
        shoparray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        NSLog(@"%@",shoparray);
        //shoparrayに情報が格納されているかどうか
        if ((shoparray != nil) && ([shoparray count] > 0)){
            //UIActionSheet型の変数を生成
            UIActionSheet *as = [[UIActionSheet alloc]init];
            //アクションシートのタイトルを設定
            as.title = @"2度といきたくない店を選択してください";
            as.delegate = self;
            //shoparrayの要素分、アクションシートのボタンを追加する
            for (int i = 0; i < [shoparray count]; i++) {
                NSDictionary *shopdic = [shoparray objectAtIndex:i];
                //ボタンのタイトルを店の名前にする
                [as addButtonWithTitle:[shopdic objectForKey:@"shopname"]];
            }
            //最後にキャンセルボタンを生成
            [as addButtonWithTitle:@"キャンセル"];
            as.cancelButtonIndex = [shoparray count] + 1;
            //アクションシートを表示
            [as showInView:self.view];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"履歴がありません" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            //警告画面表示
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"ログインしないと履歴が見れません" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        //警告画面表示
        [alert show];
    }
}

//アクションシートのボタンを押したときに呼ばれるメソッド
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NGdicとNGAlertをいったん値なしにする
    NGdic = nil;
    NGAlert = nil;
    //キャンセルボタンが押されたかどうか
    if (buttonIndex < [shoparray count]) {
        //2度といきたくない店の情報を格納
        NGdic = [shoparray objectAtIndex:buttonIndex];
        //アラートのメッセージの文字列を格納するための変数
        NSString *shopname = @"店名:";
        //shopnameの末尾に2度といきたくない店の名前を追加
        shopname = [shopname stringByAppendingString:[NGdic objectForKey:@"shopname"]];
        //NGAlertの値を生成
        NGAlert = [[UIAlertView alloc]initWithTitle:@"この店に二度と行けないリストに登録しますか" message:shopname delegate:nil cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
        //NGAlertのデリゲートを自分自身に生成
        NGAlert.delegate = self;
        //NGAlertを表示
        [NGAlert show];
    }
}

//アラートのボタンを押したときに呼ばれるメソッド
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //ボタンを押したアラートがNGAlertであるか
    if (alertView == NGAlert) {
        NSLog(@"NGalertのボタンを押した");
        //キャンセルボタンは0番目、OKボタンは1番目
        //OKボタンを押されたか
        if (buttonIndex == 1) {
            //居酒屋のIDを格納
            NSString *shopid = [NGdic objectForKey:@"shopid"];
            //二度と行きたくない店を登録するためプログラムのURLの文字列を格納
            NSString *NGurl = @"http://smartshinobu.miraiserver.com/NGshopadd.php?id=(id)&shopid=(shopid)";
            //NGurlの中に文字列(id)をログインしているIDの文字列に変更
            NGurl = [NGurl stringByReplacingOccurrencesOfString:@"(id)" withString:self.accoutid];
            //NGurlの中に文字列(shopid)を居酒屋のIDの文字列に変更
            NGurl = [NGurl stringByReplacingOccurrencesOfString:@"(shopid)" withString:shopid];
            //Webreturnの変数を生成
            Webreturn *web = [[Webreturn alloc]init];
            //サーバーのデータを格納
            NSData *webdata = [web ServerData:NGurl];
            //NSErrorの変数を生成
            NSError *err;
            //WebdataをもとにJSONオブジェクトを生成
            NSDictionary *resdic = [NSJSONSerialization JSONObjectWithData:webdata options:NSJSONReadingMutableContainers error:&err];
            //UIAlertViewの変数宣言
            UIAlertView *alert;
            //resdicのキー「result」の値が文字列1であるかどうか
            //二度行けないリストに登録されたどうか
            if ([[resdic objectForKey:@"result"] isEqualToString:@"1"]) {
                //登録したというアラートを生成
                alert = [[UIAlertView alloc]initWithTitle:@"確認" message:@"選択した店を二度行けないリストに登録しました" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            }else{
                //登録できなかったというアラートを生成
                alert = [[UIAlertView alloc]initWithTitle:@"確認" message:@"選択した店を二度行けないリストに登録できませんでした" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            }
            //アラートを表示
            [alert show];
        }

    }
}


@end
