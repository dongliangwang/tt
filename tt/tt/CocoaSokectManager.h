//
//  CocoaSokectManager.h
//  tt
//
//  Created by Allin372 on 2019/5/31.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CocoaSokectManager : NSObject

@property (nonatomic, copy)  void(^sucess)(NSString * str);
@property (nonatomic, copy)  void(^failure)(NSString * str);
- (void)connectServerSuccess:(void(^)(NSString * str))sucess Failed:(void(^)(NSString * str))failure;
- (void)clickBtn;
@end

NS_ASSUME_NONNULL_END
