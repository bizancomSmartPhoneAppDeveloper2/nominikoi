//
//  Webreturn.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/10.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "Webreturn.h"

@implementation Webreturn


//JSONのデータをarray型で返すメソッド
-(NSArray*)JSONArrayData:(NSString*)url{
    //NSErrorの初期化
    NSError *err = nil;
    //requestによって返ってきたデータを生成
    NSData *data = [self webdata:url];
    //dataを元にJSONオブジェクトを生成
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    //値を返す
    return array;
}

//url先にあるデータを返すメソッド
-(NSData*)webdata:(NSString*)url{
    //URLを生成
    NSURL *dataurl = [NSURL URLWithString:url];
    //リクエスト生成
    NSURLRequest *request = [NSURLRequest requestWithURL:dataurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //レスポンスを生成
    NSHTTPURLResponse *response;
    //NSErrorの初期化
    NSError *err = nil;
    //requestによって返ってきたデータを生成
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    return data;
}

//JSONのデータをNSDictionary型で返すメソッド
-(NSDictionary*)JSONDictinaryData:(NSString*)url{
    //NSErrorの初期化
    NSError *err = nil;
    //requestによって返ってきたデータを生成
    NSData *data = [self webdata:url];
    //dataを元にJSONオブジェクトを生成
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    //値を返す
    return dic;
}

//自分のサーバーのデータを返すメソッド
-(NSData*)ServerData:(NSString*)url{
    NSData *data = [self webdata:url];
    //データを元に文字列を生成
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //余計な文字列を削除
    str = [str stringByReplacingOccurrencesOfString:@"<!--/* Miraiserver \"NO ADD\" http://www.miraiserver.com */-->" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<script type=\"text/javascript\" src=\"http://17787372.ranking.fc2.com/analyze.js\" charset=\"utf-8\"></script>" withString:@""];
    //strをNSData型の変数に変換
    NSData *trimdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    return trimdata;
}
@end
