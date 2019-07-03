//
//  HomeViewController.m
//  tt
//
//  Created by Allin372 on 2019/5/29.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"
#import "SocketViewController.h"
#import "CocoaAsynSocketViewController.h"
#import "RMWebSocketViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *bu1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bu1.backgroundColor = [UIColor redColor];
    [bu1 setTitle:@"jscore" forState:UIControlStateNormal];
    bu1.frame = CGRectMake(0, 100, 50, 35);
    [bu1 addTarget:self action:@selector(jscore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu1];
    
    UIButton *bu2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bu2.backgroundColor = [UIColor redColor];
    [bu2 setTitle:@"socket" forState:UIControlStateNormal];
    bu2.frame = CGRectMake(0, CGRectGetMaxY(bu1.frame) + 20, 50, 35);
    [bu2 addTarget:self action:@selector(socket) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu2];
    
    UIButton *bu3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bu3.backgroundColor = [UIColor redColor];
    [bu3 setTitle:@"cocosocket" forState:UIControlStateNormal];
    bu3.frame = CGRectMake(0, CGRectGetMaxY(bu2.frame) + 20, 50, 35);
    [bu3 addTarget:self action:@selector(cocosocket) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu3];
    
    UIButton *bu4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    bu4.backgroundColor = [UIColor redColor];
    [bu4 setTitle:@"cocosocket" forState:UIControlStateNormal];
    bu4.frame = CGRectMake(0, CGRectGetMaxY(bu3.frame) + 20, 50, 35);
    [bu4 addTarget:self action:@selector(srwebsocket) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu4];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(test) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)test
{
    NSArray *arr = @[@"1",@"2",@"3"];
    int index = arc4random()%[arr count];
    NSString * ip = [arr objectAtIndex:index];
    NSLog(@"*****%@",ip);
}

-(void)jscore
{
    ViewController *vc = [[ViewController alloc]init];
    //[self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)socket
{
    SocketViewController *vc = [[SocketViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)cocosocket
{
    CocoaAsynSocketViewController *vc = [[CocoaAsynSocketViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)srwebsocket
{
     RMWebSocketViewController*vc = [[RMWebSocketViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
