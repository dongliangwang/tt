//
//  WebSocketManager.h
//  tt
//
//  Created by Allin372 on 2019/5/30.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"


NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,WebSocketConnectType){
    WebSocketDefault = 0, //初始状态,未连接
    WebSocketConnect,      //已连接
    WebSocketDisconnect    //连接后断开
};

@class WebSocketManager;
@protocol WebSocketManagerDelegate <NSObject>

- (void)webSocketManagerDidReceiveMessageWithString:(NSString *)string;

@end

@interface WebSocketManager : NSObject

@property (nonatomic, strong) SRWebSocket *webSocket;
@property(nonatomic,weak)  id<WebSocketManagerDelegate > delegate;
@property (nonatomic, assign)   BOOL isConnect;  //是否连接
@property (nonatomic, assign)   WebSocketConnectType connectType;
@property (nonatomic, copy)  void(^bloc)(id);

+(instancetype)shared;
- (void)connectServer;//建立长连接
- (void)connectServerSuccess:(void(^)(id pongData))sucess Failed:(void(^)(id pongData))failure;//建立长连接
- (void)reConnectServer;//重新连接
- (void)RMWebSocketClose;//关闭长连接
- (void)sendDataToServer:(NSString *)data;//发送数据给服务器

@end

NS_ASSUME_NONNULL_END
