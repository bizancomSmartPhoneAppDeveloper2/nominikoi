//
//  NewidcheckViewController.m
//  nominikoi
//
//  Created by ビザンコムマック０７ on 2014/10/11.
//  Copyright (c) 2014年 mycompany. All rights reserved.
//

#import "NewidcheckViewController.h"
#import "ChoiceViewController.h"

@interface NewidcheckViewController ()

@end

@implementation NewidcheckViewController

- (void)viewDidLoad {
    self.IDlabel.text = self.accoutid;
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

//選択画面に戻る
- (IBAction)choiceback:(id)sender {
    [self performSegueWithIdentifier:@"Newidbacksegue" sender:self];
}

//画面遷移が行われる前に呼ばれるメソッド
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ChoiceViewController *cvc = segue.destinationViewController;
    //cvcのaccountidに自分のaccountidを格納
    //これでログイン状態維持
    cvc.accoutid = self.accoutid;
}
@end
