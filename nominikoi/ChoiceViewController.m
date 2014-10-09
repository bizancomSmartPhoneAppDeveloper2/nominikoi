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

@interface ChoiceViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    //選択する時間の要素を格納する配列
    NSArray *timearray;
    //選択する予算の要素を格納する配列
    NSArray *moneyarray;
}

@end

@implementation ChoiceViewController

- (void)viewDidLoad {
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



//画面遷移が行われる前に呼ばれるメソッド
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    MainViewController *maincon = segue.destinationViewController;
    //mapcon.timestrにtimepickerで選んだ要素を格納
    maincon.timestr = [timearray objectAtIndex:[self.timepicker selectedRowInComponent:0]];
    //mapcon.moneyにmoneypickerで選んだ要素を格納
    maincon.moneystr = [moneyarray objectAtIndex:[self.moneypicker selectedRowInComponent:0]];
     
}
@end
