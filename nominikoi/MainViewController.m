//
//  MainViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/03.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//
//メイン画面(マップを表示してタイマー起動する)を管理するクラス


#import "MainViewController.h"
#import "Annotetion.h"
#import "NotfoundViewController.h"
#import "FailViewController.h"
#import "SucsessViewController.h"
#import "Webreturn.h"


@interface MainViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>{
    //GPSを管理するクラス
    CLLocationManager *manager;
    //制限時間の分の値を格納する変数
    int minute;
    //制限時間の秒の値を格納する変数
    int seconds;
    //ホットペッパーのAPIのURLの文字列を格納する変数
    NSString* apiurl;
    //アプリを起動したときの位置情報を格納する変数
    CLLocation *startlocation;
    //居酒屋の位置情報を格納する変数
    CLLocation *izakayalocation;
    //setupメソッドを1回しか呼ばないようにするための変数
    BOOL start;
    //居酒屋の情報を格納するための配列
    NSMutableArray *izakayaarray;
    //カウントダウンを行うために使われるタイマー変数
    NSTimer *timer;
    //履歴に追加するため居酒屋のIDを格納するための変数
    NSString *shopid;
    //履歴に追加するため居酒屋の名前を格納するための変数
    NSString *shopname;
    //NGの店のIDを格納するための配列
    NSArray *NGarray;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    //apiurlの初期化
    apiurl = @"http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=e6cb3dcef9a8c408&format=json&genre=G001&count=100";
    NSLog(@"%@",self.accoutid);
    //距離に関するパラメータを格納するための変数
    NSString* range = @"&range=";
    //shoplabelの初期化
    self.shoplabel.text = @"検索中";
    //fukidashiの初期化
    self.fukidashi.text = @"店探してるから\nちょっと待ってくれ";
    //charaimageのアスペクト比を維持する
    self.charaimage.contentMode = UIViewContentModeScaleAspectFit;
    //backviewの背景色を設定
    self.backview.backgroundColor = [UIColor colorWithRed: (0.0)/255.0 green: (0.0)/255.0 blue: (139.0)/255.0 alpha: 1.0];
    //前の画面で選択肢で選んだ項目を判定するために使われる2つの配列
    NSArray *timearray = [NSArray arrayWithObjects:@"5分", @"10分",@"15分",nil];
    //timearrayの要素の数の繰り返し処理開始
    for (int i = 0; i < [timearray count]; i++) {
        //timestrがtimearrayの要素にあっているか調べる
        if ([self.timestr isEqualToString:[timearray objectAtIndex:i]]) {
            //あっている場所の番号に1足した値と5をかけた値をminuteに格納
            minute = 5 * (1 + i);
            //居酒屋の検索を行う範囲のパラメータを指定
            //i=0のとき300m以内、i=1のとき500m以内、i=2のとき1000m以内
            range = [range stringByAppendingString:[NSString stringWithFormat:@"%d",(1 + i)]];
            //apiurlの末尾にrangeを追加
            apiurl = [apiurl stringByAppendingString:range];
            //ループを抜け出す
            break;
        }
    }
    //timelabelの初期化
    self.timelabel.text = [NSString stringWithFormat:@"%02d:%02d",minute,seconds];
    //mapのデリゲートを自分自身に設定
    self.map.delegate = self;
    NSArray *moneyarray = [NSArray arrayWithObjects:@"〜2000円",@"2000〜3000円",@"3000〜4000円",@"4000〜5000円",@"制限なし", nil];
    //secondの初期化
    seconds = 0;
    //startの初期化
    start = YES;
    //mapを隠す
    self.map.hidden = YES;
    //空のリストを生成
    izakayaarray = [NSMutableArray array];
    //予算に関するパラメータを格納するための変数
    NSString *moneyrange = @"&budget=B00";
    //moneyarrayの要素の数の繰り返し処理を開始
    for (int i = 0; i < [moneyarray count]; i++) {
        if ([self.moneystr isEqualToString:[moneyarray objectAtIndex:i]]) {
            //i=4(moneystrの値が文字列「4000〜5000円」)であるか
            if (i == 3) {
                //moneyrangeの値を文字列「&budget=B008」にする
                moneyrange = [moneyrange stringByAppendingString:[NSString stringWithFormat:@"%d",8]];
            }
            //i=5(moneystrの値が文字列「4000〜5000円」)であるか
            else if(i == 4){
                //moneyrangeの値をなしにする
                moneyrange = @"";
            }
            //それ以外場合の処理
            else{
                //moneyrangeの値を文字列「&budget=B00(i+1)」にする
                moneyrange = [moneyrange stringByAppendingString:[NSString stringWithFormat:@"%d",(i + 1)]];
            }
            //apiurlの末尾にmoneyrangeを追加
            apiurl = [apiurl stringByAppendingString:moneyrange];
            //ループを抜け出す
            break;
        }
    }
    //managerの初期化
    manager = [[CLLocationManager alloc]init];
    //managerのデリゲートを自分自身に指定
    manager.delegate = self;
    //managerがrequestWhenInUseAuthorizationというメソッドを持っているか
    if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //requestWhenInUseAuthorizationを実行
        //位置情報の使用をアプリ起動時のみ許可してもらうよう要求
        [manager requestWhenInUseAuthorization];
    }
    //GPSの測位の制度を指定
    //manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //GPSの位置情報取得間隔を設定
    //manager.distanceFilter = 10.0;
    [super viewDidLoad];
    //GPSを起動
    [manager startUpdatingLocation];
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

//位置情報を取るたびによばれるメソッド
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *nowlocation = [locations lastObject];
    NSLog(@"GPS実行中");
    if (start) {
        //startをNOにする
        start = NO;
        NSLog(@"setupメソッド起動");
        //startlocationの初期化
        startlocation = [[CLLocation alloc]initWithLatitude:nowlocation.coordinate.latitude longitude:nowlocation.coordinate.longitude];
        //メインキューの初期化
        dispatch_queue_t mainqueue = dispatch_get_main_queue();
        //グローバルキューの初期化
        dispatch_queue_t globalqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //インジケーターのアニメーションを開始
        [self.activity startAnimating];
        dispatch_async(globalqueue, ^{
            //バックグラウンドの処理
            NSLog(@"バック処理");
            //setupメソッドを実行
            [self setup];
            dispatch_async(mainqueue, ^{
                //メイン処理
                
                if ([izakayaarray count] > 0) {
                    NSLog(@"検索成功");
                     //インジケーターのアニメーション停止
                    [self.activity stopAnimating];
                    //インジケーターを非表示
                    self.activity.hidden = YES;
                    [self izakayachoice];
                } else{
                    NSLog(@"検索失敗");
                    //検索失敗画面に移る
                    [self performSegueWithIdentifier:@"notfoundsegue" sender:self];
                }
            });
        });
    }
    //居酒屋の緯度と経度ともに0度でないのか
    if ((izakayalocation.coordinate.latitude != 0) && (izakayalocation.coordinate.longitude != 0)) {
        //最近の位置から居酒屋の位置の距離を格納(m単位)
        float dis = (float)[izakayalocation distanceFromLocation:nowlocation];
        NSLog(@"居酒屋までの距離 %f m",dis);
        //距離が5m以内か
        if (dis < 10) {
            //sucsessメソッドを実行
            [self sucsess];
        }
    }
}


//指定条件にあった居酒屋の情報を取得するためのメソッド
-(void)setup{
    //文字列accountidの長さが0より大きいか(ログイン状態であるか)
    if ([self.accoutid length] > 0) {
        //NGの店のIDを取り出す先のURLを格納
        NSString *serverurl = @"http://smartshinobu.miraiserver.com/nominikoi/NGshoplist.php?id=";
        //serverurlの末尾にログインしているIDを追加
        serverurl = [serverurl stringByAppendingString:self.accoutid];
        //サーバーのデータを生成
        NSData *data = [Webreturn ServerData:serverurl];
        NSError *err;
        //NGリストの店のIDが格納されている配列を生成
        NGarray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    }
    //緯度に関するパラメータを格納するための変数
    NSString *latstr = [NSString stringWithFormat:@"&lat=%f",startlocation.coordinate.latitude];
    //経度に関するパラメータを格納するための変数
    NSString *lngstr = [NSString stringWithFormat:@"&lng=%f",startlocation.coordinate.longitude];
    //apiurlの末尾にlatstrを追加
    apiurl = [apiurl stringByAppendingString:latstr];
    //apiurlの末尾にlatstrを追加
    apiurl = [apiurl stringByAppendingString:lngstr];
    NSLog(@"%@",apiurl);
    //apiurlの示すURLのapiから取得したデータを格納
    NSDictionary *izakayadic = [Webreturn JSONDictinaryData:apiurl];
    //izakayadicのキー「results」の値(今回の場合の値の型はNSDictionary)を格納
    NSDictionary *resultdic = [izakayadic objectForKey:@"results"];
    //検索結果に該当する数を格納
    int resultcount = [[resultdic objectForKey:@"results_available"] intValue];
    //izakayadicのキー「results_available」の値が0でないか
    if (resultcount != 0) {
        NSLog(@"ヒット数:%d",resultcount);
        //居酒屋の数を100で割った数を格納
        int loop = resultcount / 100;
        //居酒屋の数は100で割り切れないか
        if (resultcount % 100 != 0) {
            loop++;
        }
        for (int i = 0; i < loop; i++) {
            //検索結果を何件目から出力するか決める変数
            int startpage = (100 * i) + 1;
            NSLog(@"%d件目から検索",startpage);
            //検索結果を何件目から出力するか決めるためのパラメータを格納するための変数
            NSString *startstr = [NSString stringWithFormat:@"&start=%d",startpage];
            //apiurlの末尾にstartstrを追加した文字列の変数
            NSString *newurl = [apiurl stringByAppendingString:startstr];
            //newurlが示すapiから取得するデータを格納
            NSDictionary *newdic = [Webreturn JSONDictinaryData:newurl];
            //newdicのキー「results」の値(今回の場合の値の型はNSDictionary)を格納
            NSDictionary *newresdic = [newdic objectForKey:@"results"];
            //newresdicのキー「shop」の値(今回の場合の値は居酒屋の情報を格納されている配列)を格納
            NSArray *shoparray = [newresdic objectForKey:@"shop"];
            //shoparrayの要素分のループ処理実行(最大100)
            for (int n = 0; n < [shoparray count]; n++) {
                //shoparrayのn番目の要素(今回はNSDictionary型)を格納
                NSDictionary *adddic = [shoparray objectAtIndex:n];
                //追加しようとしている居酒屋のIDがNGの店のIDとかぶっていないか
                if (![NGarray containsObject:[adddic objectForKey:@"id"]]) {
                    NSLog(@"追加");
                    //izakayaarrayの末尾にadddicを格納
                    [izakayaarray addObject:adddic];
                }else{
                    NSLog(@"IDがかぶっている");
                }
            }
        }
        }else{
        NSLog(@"ヒットなし");
    }
}

//条件にあった居酒屋の中から1つ選びマップにアノテーションを追加するメソッド
-(void)izakayachoice{
    //マップを表示
    self.map.hidden = NO;
    //マップに現在地の印(青い丸)を表示
    self.map.showsUserLocation = YES;
    //izakayaarrayの中からランダムに1つの要素を格納
    NSDictionary *choice = [izakayaarray objectAtIndex:arc4random() % [izakayaarray count]];
    //shoplabelに店の名前を表示するように設定
    self.shoplabel.text = [choice objectForKey:@"name"];
    //居酒屋の緯度を表す変数
    double izakayalat = [[choice objectForKey:@"lat"] doubleValue];
    //居酒屋の経度を表す変数
    double izakayalng = [[choice objectForKey:@"lng"] doubleValue];
    //izakayalocationの初期化
    izakayalocation = [[CLLocation alloc]initWithLatitude:izakayalat longitude:izakayalng];
    //現在地と居酒屋の距離を格納
    //distanceFromLocationはメートル単位でとる
    float dis = (float)([izakayalocation distanceFromLocation:startlocation] / 1000);
    //アイコンの緯度経度を設定
    CLLocationCoordinate2D tolocation;
    tolocation.latitude = izakayalocation.coordinate.latitude;
    tolocation.longitude = izakayalocation.coordinate.longitude;
    //MKCooredinateRegionの変数の初期化
    MKCoordinateRegion region = self.map.region;
    //マップが表示された時の中心の緯度設定
    region.center.latitude = (startlocation.coordinate.latitude + izakayalocation.coordinate.latitude) / 2;
    //マップが表示された時の中心の経度設定
    region.center.longitude = (startlocation.coordinate.longitude + izakayalocation.coordinate.longitude) / 2;
    //現在地から店の距離によってマップの縮尺度を設定(店とアプリを起動した位置の距離+150mの幅を設定)
    region.span.latitudeDelta = (dis + 0.15) / 111.2;
    region.span.longitudeDelta = (dis + 0.15) / 111.2;
    [self.map setRegion:region];
    //居酒屋のアノテーションを生成
    Annotetion *izakayaano = [[Annotetion alloc]initWithCoordinate:tolocation];
    //アノテーションのタイトルを店の名前にする
    izakayaano.title = [choice objectForKey:@"name"];
    //住所の情報を格納
    izakayaano.address = [choice objectForKey:@"address"];
    //居酒屋のIDを格納
    shopid = [choice objectForKey:@"id"];
    //居酒屋の名前を格納
    shopname = izakayaano.title;
    //アノテーションを追加
    [self.map addAnnotation:izakayaano];
    //ラベルfukidashiに表示する文字列を変更
    self.fukidashi.text = @"ここで待ってるからな";
    //1秒ごとにメソッドcountdownを実行
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    
}


//アノテーションを追加してアノテーション(ピン)が表示されるときに呼ばれるメソッド
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    NSLog(@"mapview実行");
    //現在地の情報でないか
    if (annotation != self.map.userLocation) {
        NSLog(@"現在地でない");
        NSString *pin = @"pinadd";
        //pinで示すリサイクル可能なアノテーションビューかnilが返ってくる
        MKAnnotationView *av = (MKAnnotationView*)[self.map dequeueReusableAnnotationViewWithIdentifier:pin];
        if (av == nil) {
            NSLog(@"nilだった");
            //anotetionとpinを用いて値を代入
            av = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pin];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
            //アノテーションの右側にボタンをつける
            av.rightCalloutAccessoryView = btn;
            //表示する画像を設定
            av.image = [UIImage imageNamed:@"smallbeel2.png"];
            //ピンをクリックしたときに情報を表示するようにする
            av.canShowCallout = YES;
        } else{
            NSLog(@"nilでなかった");
        }
        return av;
    }else{
        NSLog(@"現在地である");
        return nil;
    }

}

//カウントダウン用のメソッド
-(void)countdown{
    //秒の数が0であるか
    if (seconds == 0) {
        //分の数をデクリメント
        minute--;
        //秒の数を59にする
        seconds = 59;
    } else {
        //秒の数をデクリメント
        seconds--;
    }
    //2分を切ったか
    if (minute == 1) {
        //キャラクターの画像を変更する(たばこをすっている画像)
        self.charaimage.image = [UIImage imageNamed:@"joushitabako1.png"];
        self.fukidashi.text = @"まだなのか\n2分切ったぞ";
    }
    //1分を切ったか
    if (minute == 0) {
        //キャラクターの画像を変更する(たばこを灰皿にすてる画像)
        self.charaimage.image = [UIImage imageNamed:@"joushitabako2.png"];
        self.fukidashi.text = @"はよ来い\n時間ないぞ!!!";
    }
    //分の数と秒の数がともに0であるか
    if ((minute == 0) && (seconds == 0)) {
        //タイマーを止める
        [timer invalidate];
        timer = nil;
        //時間切れの画面に移る
        [self performSegueWithIdentifier:@"failsegue" sender:self];
    }
    self.timelabel.text = [NSString stringWithFormat:@"%02d:%02d",minute,seconds];
}

//ピンにあるボタンを押すと呼ばれるメソッド
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    //アノテーションの変数を生成
    Annotetion *annotetion = (Annotetion*)view.annotation;
    //店名と住所の名前が書いてある文字列を生成
    NSString *info = [NSString stringWithFormat:@"店名:%@\n住所:%@",annotetion.title,annotetion.address];
    //店名と住所を表示するアラートを生成
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"居酒屋情報" message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //アラートを表示
    [alert show];
}

//成功画面に移るため野メソッド
-(void)sucsess{
    //タイマーを止める
    [timer invalidate];
    timer = nil;
    //成功の画面に移る
    [self performSegueWithIdentifier:@"sucsesssegue" sender:self];
}

//画面遷移する前に呼ばれるメソッド
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //GPSを止める
    [manager stopUpdatingLocation];
    //accountidの長さ0であるか
    if ([self.accoutid length] > 0) {
        //セグエの名前がnotfoundsegueであるか
        if ([[segue identifier] isEqualToString:@"notfoundsegue"]) {
            //検索失敗画面先にidを継承
            NotfoundViewController *nvc = segue.destinationViewController;
            nvc.accoutid = self.accoutid;
        }else if([[segue identifier] isEqualToString:@"failsegue"]){
            //失敗画面先にidを継承
            FailViewController *fvc = segue.destinationViewController;
            fvc.accoutid = self.accoutid;
        }else if([[segue identifier] isEqualToString:@"sucsesssegue"]){
            //成功画面先にidを継承
            SucsessViewController *svc = segue.destinationViewController;
            svc.accoutid = self.accoutid;
            //居酒屋のidと名前を成功画面のクラスのプロパティに格納
            svc.shopid = shopid;
            svc.shopname = shopname;
        }
        
    }
}
@end
