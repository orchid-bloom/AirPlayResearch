//
//  ASWhitelabelViewController.h
//  
//
//  Created by Daniel Bowden on 20/02/2014.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ASEnvironment)
{
    ASEnvironmentQA,
    ASEnvironmentStaging,
    ASEnvironmentProduction
};

@protocol ASWhitelabelDelegate;

@interface ASWhitelabelViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) ASEnvironment environment;
@property (nonatomic, strong) NSString *appID;
@property (nonatomic, strong) NSString *appToken;
@property (nonatomic, strong) NSString *venueAlias;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSString *brandColor;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appStoreID;
@property (nonatomic, strong) NSString *appIdentifier;
@property (nonatomic, strong) NSArray *customParameters;
@property (nonatomic, assign) BOOL loggingEnabled;
@property (nonatomic, strong, readonly) UIWebView *webView;

- (id)initWithAppID:(NSString *)appID appToken:(NSString *)appToken delegate:(id<ASWhitelabelDelegate>)delegate;

@end

@protocol ASWhitelabelDelegate <NSObject>

@required
- (void)ASWhitelabelViewControllerDidRequestExit:(ASWhitelabelViewController *)viewController;

@end
