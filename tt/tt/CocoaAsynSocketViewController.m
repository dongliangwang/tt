//
//  CocoaAsynSocketViewController.m
//  tt
//
//  Created by Allin372 on 2019/5/29.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import "CocoaAsynSocketViewController.h"
#import "GCDAsyncSocket.h"
#import "CocoaSokectManager.h"

@interface CocoaAsynSocketViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) CocoaSokectManager *ma;
@property (nonatomic, strong) NSData *allData;

@end

@implementation CocoaAsynSocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 300, 60)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"发送数据" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _ma = [[CocoaSokectManager alloc]init];
    [_ma connectServerSuccess:^(NSString * _Nonnull str) {
        NSLog(@"收到block%@",str);
    } Failed:^(NSString * _Nonnull str) {
        
    }];
}

- (void)clickBtn{
   
    [_ma clickBtn];
    
}



@end
