//
//  SCImageViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCImageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SCImageViewController ()

- (void)layout;

@end

@implementation SCImageViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize imageURL = _imageURL;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.imageURL];
    [self showActivityIndicator];

    __weak SCImageViewController *s = self;
    [self.imageView setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
         [s layout];
         [s hideActivityIndicator];
     } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
         [SCPopupMessageView showWithMessage:[error localizedDescription] overView:self.view];
         [s hideActivityIndicator];
     }];
}

- (void)layout
{
    if (self.imageView.image.size.width) {
        float ratio = self.view.bounds.size.width / self.imageView.image.size.width;
        CGFloat height = ratio * self.imageView.image.size.height;
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, height);
        self.imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layout];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

@end