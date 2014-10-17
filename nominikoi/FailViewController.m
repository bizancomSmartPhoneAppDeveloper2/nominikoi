//
//  FailViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/08.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//　失敗画面を管理するクラス

#import "FailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ChoiceViewController.h"

@interface FailViewController ()
//音源用のプロパティ
@property AVAudioPlayer *voice;
@property AVAudioPlayer *sound;

@end


@implementation FailViewController

- (void)viewDidLoad {
    //背景色を夜の色に設定
    self.backview.backgroundColor = [UIColor colorWithRed: (0.0)/255.0 green: (0.0)/255.0 blue: (139.0)/255.0 alpha: 1.0];
    
    [super viewDidLoad];
    //音声ファイルの場所を示す文字列を格納
    NSString *path = [[NSBundle mainBundle]pathForResource:@"gekido" ofType:@"mp3"];
    //音声ファイルの場所をURL形式に変換
    NSURL *url = [NSURL fileURLWithPath:path];
    //urlを元にインスタンスを生成
    self.voice = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
    //音声ファイルの場所を示す文字列を格納
    path = [[NSBundle mainBundle]pathForResource:@"bad" ofType:@"mp3"];
    //音声ファイルの場所をURL形式に変換
    url = [NSURL fileURLWithPath:path];
    //urlを元にインスタンスを生成
    self.sound = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];

    //音声ファイルを再生
    [self.sound play];
    //3秒後にメソッドfukidashichangeを実行
    [self performSelector:@selector(firstvoice) withObject:nil afterDelay:1];
    //3秒後にメソッドfukidashichangeを実行
    [self performSelector:@selector(firstselifu) withObject:nil afterDelay:3];
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

-(void)firstvoice{
    //音声ファイルを再生
    [self.voice play];
}

//吹き出しの言葉を変えるメソッド
-(void)firstselifu{
    //fukidashiのフォントサイズを16に変更
    self.fukidashi.font = [UIFont systemFontOfSize:16];
    //fukidashiの言葉を変更
    self.fukidashi.text = @"何、遅刻してんだー\nお前に処分を下す!!";
    //3秒後にメソッドfukidashichangeを実行
    [self performSelector:@selector(secondselifu) withObject:nil afterDelay:3];
}

//吹き出しの言葉を変えるメソッド(2回目)
-(void)secondselifu{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"fail" ofType:@"plist"];
    //処分用の言葉を格納するための配列
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    //NSArray *array = [NSArray arrayWithObjects:@"明日からしばらく\nサービス残業だ!!!",@"今月からしばらく\n給料10%カットだ!!!", @"今年の\n有給休暇なしだ!!!",@"今年のボーナス\nなしだ!!!", @"明日からしばらく\n休日出勤だ!!!",@"今のプロジェクトから\nお前をはずす!!!",@"明日からしばらく\n出勤停止だ",@"今のお前の職位から\n降格だ",@"明日から早期出勤だ!!!",nil];
    //arrayの中からランダムに選ばれた言葉を表示
    self.fukidashi.text = [array objectAtIndex:arc4random()%[array count]];
    //3秒後にメソッドbackを実行
    [self performSelector:@selector(back) withObject:nil afterDelay:3.0];
    
}


//選択画面に戻るメソッド
-(void)back{
    //名前がfailbacksegueであるセグエを実行
    [self performSegueWithIdentifier:@"failbacksegue" sender:self];
    
}

@end
