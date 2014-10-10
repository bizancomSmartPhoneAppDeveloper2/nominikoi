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

@interface ChoiceViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>{
    //選択する時間の要素を格納する配列
    NSArray *timearray;
    //選択する予算の要素を格納する配列
    NSArray *moneyarray;
    //行った店の履歴の情報を格納する配列
    NSMutableArray *shoparray;
}

@end

@implementation ChoiceViewController

- (void)viewDidLoad {
    NSLog(@"%@",self.accoutid);
    //文字列accoutidの長さが0より大きいか
    if ([self.accoutid length] > 0) {
        //ボタンを文字の名前をlogoutにする
        [self.logbutton setTitle:@"logout" forState:UIControlStateNormal];
    }else{
        //そうでない場合はloginにする
        [self.logbutton setTitle:@"login" forState:UIControlStateNormal];
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
    if ([[self.logbutton currentTitle
         ] isEqualToString:@"logout"]) {
        //accoutidを空にする
        self.accoutid = nil;
        //ボタンの名前をloginにする
        [self.logbutton setTitle:@"login" forState:UIControlStateNormal];
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
@end
