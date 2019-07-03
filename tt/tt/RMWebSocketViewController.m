//
//  RMWebSocketViewController.m
//  tt
//
//  Created by Allin372 on 2019/5/30.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import "RMWebSocketViewController.h"
#import "WebSocketManager.h"

@interface RMWebSocketViewController ()

@end

@implementation RMWebSocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WebSocketManager *man = [WebSocketManager shared];
    [man connectServer];
   
   // [man sendDataToServer:@"helllllll"];
    [man connectServerSuccess:^(id ss) {
        
    } Failed:^(id ee) {
        
    }];
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
