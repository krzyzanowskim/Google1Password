//
//  ViewController.m
//  Google1Password
//
//  Created by Marcin Krzyzanowski on 22/02/15.
//  Copyright (c) 2015 Marcin Krzyżanowski. All rights reserved.
//

#import "ViewController.h"
#import <GTMOAuth2ViewControllerTouch.h>
#import <OnePasswordExtension.h>

static NSString * const kClientId = nil;  // Find it at https://code.google.com/apis/console under 'API Access'
static NSString * const kSecretId = nil; // Find it at https://code.google.com/apis/console under 'API Access'

@interface ViewController () <UIWebViewDelegate>
@property (weak) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signInPressed:(UIButton *)button
{
    GTMOAuth2ViewControllerTouch *googleAuthViewController = [[GTMOAuth2ViewControllerTouch alloc]
                           initWithScope:@"https://www.googleapis.com/auth/userinfo#email"
                           clientID:kClientId
                           clientSecret:kSecretId
                           keychainItemName:@"GooglePlus_Sample_App"
                           delegate:self
                           finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    UIView *view = googleAuthViewController.view; // trick to load load view and connect outlets
    self.webView = googleAuthViewController.webView;
    
    // add 1Password button
    if ([[OnePasswordExtension sharedExtension] isAppExtensionAvailable]) {
        UIButton *onePasswordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [onePasswordButton addTarget:self action:@selector(onePasswordAction:) forControlEvents:UIControlEventTouchUpInside];
        [onePasswordButton setFrame:CGRectMake(0, 64, 150, 44)];
        [onePasswordButton setTitle:@"1Password" forState:UIControlStateNormal];
        [onePasswordButton setImage:[UIImage imageNamed:@"onepassword-button"] forState:UIControlStateNormal];
        [view addSubview:onePasswordButton];
    }
    
    [self.navigationController pushViewController:googleAuthViewController animated:YES];
}

#pragma mark - Action

- (IBAction) onePasswordAction:(UIButton *)sender
{
    [[OnePasswordExtension sharedExtension] fillLoginIntoWebView:self.webView forViewController:self sender:sender completion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Failed to fill login in webview: <%@>", error);
        }
    }];
}

#pragma mark - Authentiocation

- (void) viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error != nil) {
        // Authentication failed
    } else {
        // Authentication succeeded
    }
}

@end
