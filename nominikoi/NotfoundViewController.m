//
//  NotfoundViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//
//検索失敗画面を管理するクラス

#import "NotfoundViewController.h"
#import "ChoiceViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface NotfoundViewController ()
//音源用のプロパティ
@property AVAudioPlayer *sound;

@end

@implementation NotfoundViewController

- (void)viewDidLoad {
    //背景色を夜の色に設定
    self.backview.backgroundColor = [UIColor colorWithRed: (0.0)/255.0 green: (0.0)/255.0 blue: (139.0)/255.0 alpha: 1.0];
    //最初の吹き出しの言葉を設定
    self.fukidashi.text = @"お前が行きたい\n居酒屋がねえよ〜";
    [super viewDidLoad];
    //音声ファイルの場所を示す文字列を格納
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sad" ofType:@"mp3"];
    //音声ファイルの場所をURL形式に変換
    NSURL *url = [NSURL fileURLWithPath:path];
    //urlを元にインスタンスを生成
    self.sound = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
    //音声ファイルを再生
    [self.sound play];

    //3秒後にメソッドfukidashichangeを実行
    [self performSelector:@selector(fukidashichange) withObject:nil afterDelay:3];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//吹き出しの言葉を変えるメソッド
-(void)fukidashichange{
    //2つめの吹き出しの言葉を設定
    self.fukidashi.text = @"別の場所にしてくれ〜\n贅沢するんじゃねよ〜";
    //3秒後にメソッドbackを実行
    [self performSelector:@selector(back) withObject:nil afterDelay:3];
}

-(void)back{
    //名前がnotbacksegueであるセグエを実行
    [self performSegueWithIdentifier:@"notbacksegue" sender:self];
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
