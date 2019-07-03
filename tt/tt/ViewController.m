//
//  ViewController.m
//  tt
//
//  Created by Allin372 on 2019/4/15.
//  Copyright © 2019 Allin372. All rights reserved.
//

#import "ViewController.h"
#import "WViewController.h"

@interface ViewController()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//[GCDAsyncSocket alloc]
    // Do any additional setup after loading the view, typically from a nib.
//   [ [NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notice) name:@"111" object:nil ];
//    WViewController *av = [[WViewController alloc]init];
//    [self presentViewController:av animated:YES completion:^{
//
//    }];
//    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.frame];
//    web.delegate = self;
//    NSString *str = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"html"];
//    NSURL * url = [NSURL URLWithString:str];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [web loadRequest:request];
//    [self.view addSubview:web];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jdcreat:) name:@"DidCreateContextNotification" object:nil];
//    NSString *str1 =@"12...345";
//    str1 = [str1 substringToIndex:4];
//    NSLog(@"&&&&&&%@",str1);
}
-(void)jdcreat:(NSNotification *)noti
{
    JSContext *context = noti.object;
    PersonJS *per = [PersonJS new];
    context[@"ttf"] = per;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 页面加载完成
    NSLog(@"%@",@"页面加载完成");
    // 拿到了 WebView 的 JS 执行环境。
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"%@",exception);
    };
    
    JSValue *objectValue = [JSValue valueWithObject:@{@"name" : @"zhangsan",@"age" : @22} inContext:context];
    NSLog(@"%@",objectValue.toDictionary);
    
    context[@"varA"] = @"这是 OC 往 JS 环境中注入的 JS 变量";
    // 往 JS 环境中注入对象
    context[@"varObj"] = @{
                            @"name" : @"zhangsan",
                            @"age" : @22,
                            @"address" : @"hubeiwuhan"
                            };
    [webView stringByEvaluatingJavaScriptFromString:@"alert(varObj.name + '--' + varObj.age+ '--' + varObj.address)"];
    
    // 往 JS 环境中注入JS函数
    context[@"jsFuncqq"] = ^(NSString *name) {
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.alert('%@')",name]];
    };
   
    // [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jsFuncqq('%@')",context[@"varA"] ]];
    
//    JSValue *func = context[@"showAlert"];
//    [func callWithArguments:@[@"heheda"]];
//    JSValue *func = context[@"test"];
//    [func callWithArguments:@[@"heheda"]];
    NSString *strValue = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('label').innerText"];
    NSLog(@"HTML 元素信息  %@",strValue);
    
    JSValue *value = context[@"name"];
    NSLog(@"JS 变量 %@",value.toString);
    
    // 获取 JS 方法
    JSValue *func = context[@"showAlert"];
    [func callWithArguments:@[@"heheda"]];
}
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx
{
        
}
-(void)block
{
    NSLog(@"block---------------");
}
-(void)notice
{
    NSLog(@"notice");
}
@end
