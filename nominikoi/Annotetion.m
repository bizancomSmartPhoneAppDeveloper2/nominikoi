//
//  Annotetion.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//　アノテーションのクラス

#import "Annotetion.h"

@implementation Annotetion

//アクセサメソッドを自動生成
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize address;
//初期化用のメソッド
-(id)initWithCoordinate:(CLLocationCoordinate2D)co{
    coordinate = co;
    return self;
}
@end
