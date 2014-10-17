//
//  MainViewController.h
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/03.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MainViewController : UIViewController
//徒歩時間の選択肢の中から選ばれた項目を格納する変数
@property(nonatomic) NSString* timestr;
//予算の選択肢の中から選ばれた項目を格納する変数
@property(nonatomic) NSString* moneystr;
//制限時間を表示するためのラベル
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
//インジケーターを表す変数
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
//マップを表す変数
@property (weak, nonatomic) IBOutlet MKMapView *map;
//店の名前を表示するラベル
@property (weak, nonatomic) IBOutlet UILabel *shoplabel;
//キャラの画像を表示するためのimageview
@property (weak, nonatomic) IBOutlet UIImageView *charaimage;
//背景につかうためUIView
@property (weak, nonatomic) IBOutlet UIView *backview;
//吹き出しに言葉を表示するためのラベル
@property (weak, nonatomic) IBOutlet UILabel *fukidashi;

@end
