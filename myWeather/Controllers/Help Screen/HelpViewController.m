//
//  HelpViewController.m
//  myWeather
//
//  Created by Felipe on 1/11/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *helpView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL* url = [NSURL URLWithString:@"https://docs.google.com/document/d/e/2PACX-1vSUQ0TJBp9AkfluVKOCW3Lm2QpQyg2omdgVTMGBR4M9G0SJhZy0kqQA_tjQqUsgYfIs7jYCYdo5Dj71/pub"];

    [_helpView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
