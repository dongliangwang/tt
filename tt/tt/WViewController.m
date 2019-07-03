//
//  WViewController.m
//  tt
//
//  Created by Allin372 on 2019/4/16.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import "WViewController.h"

@interface WViewController ()

@end

@implementation WViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"11" object:nil ];
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
