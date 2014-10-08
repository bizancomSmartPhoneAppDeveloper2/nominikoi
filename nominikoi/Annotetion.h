//
//  Annotetion.h
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/04.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotetion : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSString *address;
}
//緯度、経度の情報を格納するための変数
@property(nonatomic)CLLocationCoordinate2D coordinate;
//タイトルを持つ変数
@property(nonatomic,copy)NSString *title;
//サブタイトルを持つ変数
@property(nonatomic,copy)NSString *subtitle;
//店の住所をを持つ変数
@property(nonatomic,copy)NSString *address;
-(id)initWithCoordinate:(CLLocationCoordinate2D)co;


@end
