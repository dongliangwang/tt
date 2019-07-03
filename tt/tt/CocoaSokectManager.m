//
//  CocoaSokectManager.m
//  tt
//
//  Created by Allin372 on 2019/5/31.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import "CocoaSokectManager.h"
#import "GCDAsyncSocket.h"

@interface CocoaSokectManager ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) NSData *allData;

@end


@implementation CocoaSokectManager

- (void)connectServerSuccess:(void(^)(NSString * str))sucess Failed:(void(^)(NSString * str))failure
{
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    [self.clientSocket connectToHost:@"127.0.0.1" onPort:12345 error:&error];
    if (error) {
        NSLog(@"error == %@",error);
    }
    [self.clientSocket acceptOnPort:12345 error:&error];
    [self.clientSocket readDataWithTimeout:-1 tag:2];
    
    self.sucess = sucess;
}

- (void)clickBtn{
    NSString *msg = @"发送数据: 你好\r\n";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
    
    
}

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"新的socket");
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"链接成功");
    NSLog(@"服务器IP: %@-------端口: %d",host,port);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"发送数据 tag = %zi",tag);
    // [sock readDataWithTimeout:-1 tag:tag];
   
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   // NSLog(@"读取数据 data = %@ tag = %zi",str,tag);
    // 读取到服务端数据值后,能再次读取
    [sock readDataWithTimeout:-1 tag:tag];
    // [sock readDataToLength:4 withTimeout:-1 tag:0];
    //     [self.clientSocket readDataToData:self.allData withTimeout:-1 tag:0];
    
    //    NSString *str1 = [[NSString alloc] initWithData:self.allData encoding:NSUTF8StringEncoding];
    //    NSLog(@"读取all数据 data = %@ tag = %zi",str1,tag);
    self.sucess(str);
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"断开连接");
    //    self.clientSocket.delegate = nil;
    //    self.clientSocket = nil;
    
    NSError *error = nil;
    [self.clientSocket connectToHost:@"127.0.0.1" onPort:12345 error:&error];
    if (error) {
        NSLog(@"error == %@",error);
    }
    [self.clientSocket readDataWithTimeout:-1 tag:2];
    
}

@end
