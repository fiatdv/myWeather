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
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html" inDirectory:@"help"];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [_helpView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
}

- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
