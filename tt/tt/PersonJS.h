//
//  PersonJS.h
//  tt
//
//  Created by Allin372 on 2019/5/16.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol jsExport <JSExport>

    -(void)nslog:(NSString *)str;

@end

@interface PersonJS : NSObject<jsExport>

@end

NS_ASSUME_NONNULL_END
