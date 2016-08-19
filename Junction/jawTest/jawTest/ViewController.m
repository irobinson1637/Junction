//
//  ViewController.m
//  jawTest
//
//  Created by Isaac Robinson on 8/17/16.
//  Copyright © 2016 Isaac Robinson. All rights reserved.
//

#import "ViewController.h"
#import <UPPlatformSDK/UPPlatformSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testButton:(UIButton *)sender {
    [[UPPlatform sharedPlatform] startSessionWithClientID:@"km6mBn31ggo"clientSecret:@"3610fdf5a11f578e4f1ea365fe96753b020e413e"
                                                authScope:(UPPlatformAuthScopeExtendedRead | UPPlatformAuthScopeMoveRead)
                                               completion:^(UPSession *session, NSError *error) {
                                                   if (session != nil) {
                                                       // Your code to start making API requests goes here.
                                                       UPCardiacEvent *cardiacEvent = [UPCardiacEvent eventWithTitle:@"Run"
                                                                                                           heartRate:@120
                                                                                                    systolicPressure:@120
                                                                                                   diastolicPressure:@80
                                                                                                                note:@"Good weather."
                                                                                                               image:nil];

                                                   }
                                                   [UPCardiacEventAPI getCardiacEventsWithCompletion:^(NSArray *results, UPURLResponse *response, NSError *error) {
                                                       printf("hello");
                                                       
                                                   }];
                                               }];
    
    

}

@end
