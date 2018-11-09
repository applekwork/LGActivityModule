
//
//  LGDetailViewController.m
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import "LGDetailViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <Masonry/Masonry.h>
@interface LGDetailViewController ()<UIWebViewDelegate, NSURLConnectionDelegate>{
    BOOL _authenticated;//是否ATS认证
    NSURLRequest *_originRequest;
}
@property(nonatomic, strong) UIWebView* webView;
@property (nonatomic) UIBarButtonItem* customBackBarItem;
@property(nonatomic, strong)NSString* urlStr;//跳转url
@property(nonatomic, strong)NSString* tStr;//标题
@end

@implementation LGDetailViewController
- (void)dealloc {
    self.goBlock = nil;
}
- (instancetype)initWithUrl:(NSString* )urlStr
{
    if(self = [super init]){
        _urlStr = urlStr;
        _tStr = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_tStr){
        self.title = _tStr;
    }
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    NSString* encodedString =  [_urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark----------webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    _originRequest = request;
    return YES;;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateNavigationItems];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(self.title.length == 0){
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    [self cancelLoad];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        SecTrustResultType result;
        OSStatus err = SecTrustEvaluate(trust, &result);
        if(err == errSecSuccess && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)){
            NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
            [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
        }else{//ATS认证失败
            NSString *fpath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
            NSData * cerData = [NSData dataWithContentsOfFile:fpath];
            SecCertificateRef certificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(cerData));
            SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)@[CFBridgingRelease(certificate)]);
            err = SecTrustEvaluate(trust, &result);
            if(err == errSecSuccess && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)){
                NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
                [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
            }else{
                [challenge.sender cancelAuthenticationChallenge:challenge];
            }
        }
    }else{
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)pResponse
{
    _authenticated = YES;
    [connection cancel];
    [self.webView loadRequest:_originRequest];
}

-(void)customBackItemClicked{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        if (self.goBlock) self.goBlock();
    }
}

-(void)closeItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateNavigationItems
{
    if (self.webView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem] animated:NO];
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
    }
}

- (UIWebView *)webView
{
    if(!_webView){
        _webView = [[UIWebView alloc]init];
        [self.view addSubview:_webView];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

-(UIBarButtonItem*)customBackBarItem
{
    if (!_customBackBarItem) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *bundleURL = [bundle URLForResource:@"OperationalActivity" withExtension:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithURL: bundleURL];
        UIImage *backItemImage = [UIImage imageNamed:@"nav_back" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton sizeToFit];
        [backButton setAdjustsImageWhenHighlighted:NO];
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}

@end
