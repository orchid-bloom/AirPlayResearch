//
//  ASWhitelabelViewController.m
//
//
//  Created by Daniel Bowden on 20/02/2014.
//
//

#import "ASWhitelabelViewController.h"

NS_ENUM(NSInteger, ASAlertViewType)
{
    ASAlertViewTypeError
};

@interface ASWhitelabelViewController ()

@property (nonatomic, strong, readwrite) UIWebView *webView;
@property (nonatomic, weak) id<ASWhitelabelDelegate> delegate;

- (void)loadWhitelabel;
- (void)exitWhiteLabel;
- (NSString *)environmentURLString;
- (NSURL *)urlWithString:(NSString *)str path:(NSString *)path queryParams:(NSDictionary *)params;

@end

NSString static *const kASWhitelabelUrlQA = @"https://qa.whitelabel.airservice.com";
NSString static *const kASWhitelabelUrlStaging = @"https://staging.whitelabel.airservice.com";
NSString static *const kASWhitelabelUrl = @"https://whitelabel.airservice.com";


@implementation ASWhitelabelViewController

- (id)initWithAppID:(NSString *)aID appToken:(NSString *)aToken delegate:(id<ASWhitelabelDelegate>)dlg
{
    self = [super init];
    
    if (self)
    {
        _appID = aID;
        _appToken = aToken;
        _delegate = dlg;
        _environment = ASEnvironmentProduction;
        _loggingEnabled = NO;
    }
    
    return self;
}

- (void)loadView
{
    self.view = self.webView;
    [self loadWhitelabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.webView stopLoading];
    self.webView.delegate = nil;
}

#pragma mark - Private Methods

- (void)loadWhitelabel
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.appID)
    {
        params[@"app_id"] = self.appID;
    }
    
    if (self.appToken)
    {
        params[@"app_token"] = self.appToken;
    }

    if (self.filter && self.filter.length)
    {
        params[@"collection"] = self.filter;
    }
    
    if (self.brandColor && self.brandColor.length)
    {
        params[@"default_color"] = self.brandColor;
    }
    
    if (self.venueAlias && self.venueAlias.length)
    {
        params[@"app_type"] = @"venue";
    }

    if (self.appName && self.appName.length)
    {
        params[@"name"] = self.appName;
    }
    
    if (self.appIdentifier && self.appIdentifier.length)
    {
        params[@"app_identifier"] = self.appIdentifier;
    }
    
    if (self.appStoreID && self.appStoreID.length)
    {
        params[@"app_store_id"] = self.appStoreID;
    }
    
    for (NSDictionary *extraParameter in self.customParameters)
    {
        NSString *key = extraParameter[@"key"];
        id value = extraParameter[@"value"];
        
        if (key && value)
        {
            params[key] = value;
        }
    }
    
    params[@"platform"] = @"ios";
    
    NSURL *url = [self urlWithString:[self environmentURLString] path:self.venueAlias queryParams:params];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:25.0];
    [self.webView loadRequest:request];
}

- (void)exitWhiteLabel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ASWhitelabelViewControllerDidRequestExit:)])
    {
        [self.delegate ASWhitelabelViewControllerDidRequestExit:self];
    }
}

- (NSString *)environmentURLString
{
    switch (self.environment)
    {
        case ASEnvironmentProduction:
            return kASWhitelabelUrl;
            break;
        case ASEnvironmentStaging:
            return kASWhitelabelUrlStaging;
            break;
        case ASEnvironmentQA:
            return kASWhitelabelUrlQA;
            break;
            
        default:
            return kASWhitelabelUrl;
            break;
    }
}

- (NSURL *)urlWithString:(NSString *)urlString path:(NSString *)path queryParams:(NSDictionary *)params
{
    NSMutableString *finalUrlString = [[NSMutableString alloc] initWithString:urlString];
    
    if (path)
    {
        [finalUrlString appendFormat:@"/%@", path];
    }

    if (params)
    {
        for (NSString *key in params)
        {
            NSString *value = params[key];
            
            if (value)
            {
                // Do we need to add ?k=v or &k=v ?
                if ([finalUrlString rangeOfString:@"?"].location==NSNotFound)
                {
                    [finalUrlString appendFormat:@"?%@=%@", key, [self urlEscape:value]];
                }
                else
                {
                    [finalUrlString appendFormat:@"&%@=%@", key, [self urlEscape:value]];
                }
            }
        }
    }
    
    return [NSURL URLWithString:finalUrlString];
}

- (NSString *)urlEscape:(NSString *)rawString
{
    return [rawString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

- (UIWebView *)webView
{
    if(!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    return _webView;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (self.loggingEnabled)
    {
        NSLog(@"ASWhitelabel - shouldStartLoadWithRequest: %@", [[request URL] absoluteString]);
    }
    
    if ([[[request URL] absoluteString] isEqualToString:@"AS://exit"])
    {
        [self exitWhiteLabel];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.loggingEnabled)
    {
        NSLog(@"ASWhitelabel - didFinishLoad");
    }
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.loggingEnabled)
    {
        NSLog(@"ASWhitelabel - didFailLoadWithError: %@", [error localizedDescription]);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"There was a problem loading AirService" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Retry", nil];
    alert.tag = ASAlertViewTypeError;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ASAlertViewTypeError)
    {
        if (buttonIndex == 0)
        {
            [self exitWhiteLabel];
        }
        else
        {
            [self loadWhitelabel];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

@implementation UINavigationController (StatusBarStyle)

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
