//
//  SucsessViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/08.
//  Copyright (c) 2014年 mycompany. All rights reserved.
// 成功画面を管理するクラス

#import "SucsessViewController.h"



@interface SucsessViewController ()


@end

@implementation SucsessViewController

- (void)viewDidLoad {
    //最初の吹き出し言葉を設定
    self.fukidashi.text = @"お〜お疲れ\n先に飲んじゃってごめん。";
    //imageviewのアスペクト比を維持
    self.imageview.contentMode = UIViewContentModeScaleAspectFit;
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//1回目の吹き出しの言葉を変えるメソッド
-(void)firstfukidashi{
    self.fukidashi.text = @"時間内についたから\nいいことを教えて上げる";
    //3秒後にメソッドsecondfukidashiを実行
    [self performSelector:@selector(secondfukidashi) withObject:nil afterDelay:3];

}

//2回目の吹き出しの言葉を変えるメソッド
-(void)secondfukidashi{
    //良い言葉を格納するための配列
    NSArray *array = [NSArray arrayWithObjects:@"外社から帰社した上司には\n「お疲れ様です」と言うんだぞ",@"名刺を受け取るとき、\n「ちょうだいいたします」\nと言うんだぞ", @"電話の呼び出し音がなったら\n3回以内に出るんだぞ",@"出産祝いは、\n出産の知らせを聞いてから\n贈れよ",@"手紙の宛先が会社のときは、\n様じゃなく御中を使えよ",@"握り寿司を食べるときは、\n箸でなくても手でも\n食べていいんだよ",@"中華料理店にある\nターンテーブルは、\n基本的に右に回すんだぞ",nil];
    //arrayの中からランダムに選ばれた言葉を表示
    self.fukidashi.text = [array objectAtIndex:arc4random()%[array count]];
    //3秒後にメソッドkanpaibeforeを実行
    [self performSelector:@selector(kanpaibefore) withObject:nil afterDelay:3];

}

//乾杯の言葉を表示する前に実行するメソッド
-(void)kanpaibefore{
    //fukidashiのフォントサイズを35に変更
    self.fukidashi.font = [UIFont systemFontOfSize:35];
    self.fukidashi.text = @"じゃ";
    //2秒後にメソッドkanpaiを実行
    [self performSelector:@selector(kanpai) withObject:nil afterDelay:2];
}

//乾杯の言葉を表示するメソッド
-(void)kanpai{
    self.fukidashi.text = @"乾杯〜";
    //アニメーションに使う画像を格納するための配列
    NSMutableArray *imagelist = [NSMutableArray array];
    //配列の要素を追加するための処理
    for (int i = 3; i <= 4; i++) {
        NSString *imagePath = [NSString stringWithFormat:@"joushibeel%d.png",i];
        UIImage *img = [UIImage imageNamed:imagePath];
        [imagelist addObject:img];
    }
    //アニメーションに使う画像の配列を設定
    self.imageview.animationImages = imagelist;
    //アニメーションの間隔を0.5秒に設定
    self.imageview.animationDuration = 0.5;
    //アニメーションのリピート回数を1回に設定
    self.imageview.animationRepeatCount = 1;
    //アニメーションを開始
    [self.imageview startAnimating];
    //音声ファイルの場所を示す文字列を格納
    NSString *path = [[NSBundle mainBundle]pathForResource:@"kanpai" ofType:@"mp3"];
    //音声ファイルの場所をURL形式に変換
    NSURL *url = [NSURL fileURLWithPath:path];
    //urlを元にインスタンスを生成
    self.voice = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
    //音声ファイルを再生
    [self.voice play];
     

    //3秒後にメソッドbackを実行
    [self performSelector:@selector(back) withObject:nil afterDelay:3];
}

//選択画面に戻るメソッド
-(void)back{
    
    //名前がsucsessbacksegueであるセグエを実行
    [self performSegueWithIdentifier:@"sucsessbacksegue" sender:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    //3秒後にメソッドfirstfukidashiを実行
    [self performSelector:@selector(firstfukidashi) withObject:nil afterDelay:3];
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
