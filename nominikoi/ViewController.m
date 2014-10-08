//
//  ViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/03.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//
//起動画面を管理するクラス
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    //アニメーションに使う画像を格納するための配列
    NSMutableArray *imagelist = [NSMutableArray array];
    for (int i = 1; i <= 2; i++) {
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
    [super viewDidLoad];
    [self performSelector:@selector(firstsegue) withObject:nil afterDelay:3.0];
    [self.imageview startAnimating];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)firstsegue{
    [self performSegueWithIdentifier:@"firstsegue" sender:self];
}

@end
