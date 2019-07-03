//
//  NSObject+jstext.m
//  tt
//
//  Created by Allin372 on 2019/5/16.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import "NSObject+jstext.h"

@implementation NSObject (jstext)
- (void)webView:(id)unuse didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)frame {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCreateContextNotification" object:ctx];
}
@end
