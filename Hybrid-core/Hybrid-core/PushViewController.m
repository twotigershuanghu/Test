//
//  PushViewController.m
//  Hybrid-core
//
//  Created by 双虎 on 16/5/31.
//  Copyright © 2016年 Cmptech. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 去掉导航栏返回按钮上的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    // 当 self.isTopBar = YES ,则显示topbar
    self.navigationItem.hidesBackButton = (self.isTopBar == YES)? NO : YES;
    // 配置WebView
    [self configWebView];
    // 绑定JavascriptBridge与WebView
    [self webViewJavascriptBridge_Binding:_webView];
    // 绑定会导致webview的代理失效，加上这句即可解决
    [self.bridge setWebViewDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configWebView{
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    _webView = [[UIWebView alloc]initWithFrame:bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;   // 自动对页面进行缩放以适应屏幕
    _webView.scrollView.bounces = NO; // 边缘禁止滑动 默认YES
    [self.view addSubview:_webView];
    
    // 加载网页
    [self startLoading:self.address];
}

-(void)startLoading:(NSString *)address{
    NSURL* url = [NSURL URLWithString:address];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{   //控制WebView能否加载 （返回yes可以 no则不可以）
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    NSLog(@"2 - Load the success");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"2 - Load the fail");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.jsCallback) {
        self.jsCallback(@"ok -> Push start");
        NSLog(@"回调");
    }
}
@end
