//
//  WebSocketManager.m
//  tt
//
//  Created by Allin372 on 2019/5/30.
//  Copyright © 2019 Allin372. All rights reserved.
//

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )//分别是方法地址，文件名，在文件的第几行，自定义输出内容

 #else

 #define DLog(...)

#endif

#import "WebSocketManager.h"

@interface WebSocketManager ()<SRWebSocketDelegate>
@property (nonatomic, strong) NSTimer *heartBeatTimer; //心跳定时器
@property (nonatomic, strong) NSTimer *netWorkTestingTimer; //没有网络的时候检测网络定时器
@property (nonatomic, assign) NSTimeInterval reConnectTime; //重连时间
@property (nonatomic, strong) NSMutableArray *sendDataArray; //存储要发送给服务端的数据
@property (nonatomic, assign) BOOL isActivelyClose;    //用于判断是否主动关闭长连接，如果是主动断开连接，连接失败的代理中，就不用执行 重新连接方法

@end

@implementation WebSocketManager

+(instancetype)shared{
    static WebSocketManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

-(instancetype)init{
    if (self = [super init]) {
        self.reConnectTime = 0;
        self.isActivelyClose = NO;
        self.sendDataArray = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)connectServer{
    self.isActivelyClose = NO;
    self.webSocket.delegate = nil;
    [self.webSocket close];
    _webSocket = nil;
    self.webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:@"ws://10.0.1.117:18888/websocket?uuid=12345"]];
   
    self.webSocket.delegate = self;
    [ self.webSocket open];
}

- (void)connectServerSuccess:(void(^)(id pongData))sucess Failed:(void(^)(id pongData))failure
{
    self.bloc = sucess;
}

- (void)sendPing:(id)sender{
    NSString *str = @"123";
    [self.webSocket sendPing:[str dataUsingEncoding:kCFStringEncodingUTF8]];
}

#pragma mark --------------------------------------------------
#pragma mark - socket delegate
///开始连接
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    NSLog(@"socket 开始连接");
    self.isConnect = YES;
    self.connectType = WebSocketConnect;
    
    [self initHeartBeat];///开始心跳
    
}

///连接失败
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"连接失败");
    self.isConnect = NO;
    self.connectType = WebSocketDisconnect;
    
    DLog(@"连接失败，这里可以实现掉线自动重连，要注意以下几点");
    DLog(@"1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连");
    DLog(@"3.连接次数限制，如果连接失败了，重试10次左右就可以了");
    
//    //判断网络环境
//    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable){ //没有网络
//
//        [self noNetWorkStartTestingTimer];//开启网络检测定时器
//    }else{ //有网络
//
//        [self reConnectServer];//连接失败就重连
//    }
}



///关闭连接
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    self.isConnect = NO;
    
    if(self.isActivelyClose){
        self.connectType = WebSocketDefault;
        return;
    }else{
        self.connectType = WebSocketDisconnect;
    }
    
    DLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    
    [self destoryHeartBeat]; //断开连接时销毁心跳
    
//    //判断网络环境
//    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable){ //没有网络
//        [self noNetWorkStartTestingTimer];//开启网络检测
//    }else{ //有网络
//        NSLog(@"关闭连接");
//        _webSocket = nil;
//        [self reConnectServer];//连接失败就重连
//    }
}

///ping
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongData{
    NSLog(@"接受pong数据--> %@",pongData);
    self.bloc(pongData);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"接收消息----  %@",message);
    if ([self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessageWithString:)]) {
        [self.delegate webSocketManagerDidReceiveMessageWithString:message];
    }
}



#pragma mark - NSTimer

//初始化心跳
- (void)initHeartBeat{
    //心跳没有被关闭
    if(self.heartBeatTimer) {
        return;
    }
    [self destoryHeartBeat];
    dispatch_main_async_safe(^{
        self.heartBeatTimer  = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(senderheartBeat) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop]addTimer:self.heartBeatTimer forMode:NSRunLoopCommonModes];
    });
    
}
//重新连接
- (void)reConnectServer{
    if(self.webSocket.readyState == SR_OPEN){
        return;
    }
    
    if(self.reConnectTime > 1024){  //重连10次 2^10 = 1024
        self.reConnectTime = 0;
        return;
    }
    
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectTime *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(weakSelf.webSocket.readyState == SR_OPEN && weakSelf.webSocket.readyState == SR_CONNECTING) {
            return;
        }
        
        [weakSelf connectServer];
        //        CTHLog(@"正在重连......");
        
        if(weakSelf.reConnectTime == 0){  //重连时间2的指数级增长
            weakSelf.reConnectTime = 2;
        }else{
            weakSelf.reConnectTime *= 2;
        }
    });
    
}

//发送心跳
- (void)senderheartBeat{
    //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
    WS(weakSelf);
    dispatch_main_async_safe(^{
        if(weakSelf.webSocket.readyState == SR_OPEN){
            [weakSelf sendPing:nil];
        }
    });
}

//没有网络的时候开始定时 -- 用于网络检测
- (void)noNetWorkStartTestingTimer{
    WS(weakSelf);
    dispatch_main_async_safe(^{
        weakSelf.netWorkTestingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(noNetWorkStartTesting) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:weakSelf.netWorkTestingTimer forMode:NSDefaultRunLoopMode];
    });
}
//定时检测网络
- (void)noNetWorkStartTesting{
    //有网络
//    if(AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable)
//    {
//        //关闭网络检测定时器
//        [self destoryNetWorkStartTesting];
//        //开始重连
//        [self reConnectServer];
//    }
}

//取消网络检测
- (void)destoryNetWorkStartTesting{
    WS(weakSelf);
    dispatch_main_async_safe(^{
        if(weakSelf.netWorkTestingTimer)
        {
            [weakSelf.netWorkTestingTimer invalidate];
            weakSelf.netWorkTestingTimer = nil;
        }
    });
}


//取消心跳
- (void)destoryHeartBeat{
    WS(weakSelf);
    dispatch_main_async_safe(^{
        if(weakSelf.heartBeatTimer)
        {
            [weakSelf.heartBeatTimer invalidate];
            weakSelf.heartBeatTimer = nil;
        }
    });
}


//关闭长连接
- (void)RMWebSocketClose{
    self.isActivelyClose = YES;
    self.isConnect = NO;
    self.connectType = WebSocketDefault;
    if(self.webSocket)
    {
        [self.webSocket close];
        _webSocket = nil;
    }
    
    //关闭心跳定时器
    [self destoryHeartBeat];
    
    //关闭网络检测定时器
    [self destoryNetWorkStartTesting];
}


//发送数据给服务器
- (void)sendDataToServer:(NSString *)data{
    [self.sendDataArray addObject:data];
    
    //[_webSocket sendString:data error:NULL];
    
    //没有网络
//    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
//    {
//        //开启网络检测定时器
//        [self noNetWorkStartTestingTimer];
//    }
//    else //有网络
//    {
        if(self.webSocket != nil)
        {
            // 只有长连接OPEN开启状态才能调 send 方法，不然会Crash
            if(self.webSocket.readyState == SR_OPEN)
            {
                //                if (self.sendDataArray.count > 0)
                //                {
                //                    NSString *data = self.sendDataArray[0];
                [_webSocket send:data]; //发送数据
                //                    [self.sendDataArray removeObjectAtIndex:0];
                //
                //                }
            }
            else if (self.webSocket.readyState == SR_CONNECTING) //正在连接
            {
                DLog(@"正在连接中，重连后会去自动同步数据");
            }
            else if (self.webSocket.readyState == SR_CLOSING || self.webSocket.readyState == SR_CLOSED) //断开连接
            {
                //调用 reConnectServer 方法重连,连接成功后 继续发送数据
                [self reConnectServer];
            }
        }
        else
        {
            [self connectServer]; //连接服务器
        }
//    }
}

@end
