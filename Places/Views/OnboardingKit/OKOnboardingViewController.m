//
//  OKOnboardingViewController.m
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "OKOnboardingViewController.h"
#import "OKOnboardingPage.h"

@interface OKOnboardingViewController ()
- (instancetype)initWithPages:(NSArray<OKOnboardingPage *> *)pages;
@end

@implementation OKOnboardingViewController

+ (OKOnboardingViewController *)initializeWithPages:(NSArray<OKOnboardingPage *> *)pages {
    return [[OKOnboardingViewController alloc] initWithPages:pages];;
}

- (instancetype)initWithPages:(NSArray<OKOnboardingPage *> *)pages {
    self = [super initWithNode:pages[1]];
    if (self) {
        //self.node.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
