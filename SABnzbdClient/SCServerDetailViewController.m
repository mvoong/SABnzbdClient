//
//  SCServerDetailViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServerDetailViewController.h"
#import "SCServerDetailViewControllerDataSource.h"

@interface SCServerDetailViewController ()

- (void)duplicate;

@end

@implementation SCServerDetailViewController

- (SCServerDetailViewControllerDataSource *)serverDetailDataSource
{
    return (SCServerDetailViewControllerDataSource *)self.dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.server.name;
    [self.server addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];

    if (!self.duplicated) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DUPLICATE_KEY", nil)
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(duplicate)];
    }

    [[self serverDetailDataSource] setServer:self.server];
    [self.dataSource loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ([self.server.hostname length] > 0 || [SCServer countOfEntities] < 2) {
        [[NSManagedObjectContext defaultContext] save];
    } else {
        [self.server deleteEntity];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.server && [keyPath isEqualToString:@"name"])
        self.title = self.server.name;
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)duplicate
{
    SCServer *newServer = [SCServer createEntity];
    newServer.active = [NSNumber numberWithBool:NO];
    newServer.name = [NSString stringWithFormat:NSLocalizedString(@"DUPLICATE_OF_KEY", nil), self.server.name];
    newServer.hostname = [self.server.hostname copy];
    newServer.apiKey = [self.server.apiKey copy];
    newServer.port = [self.server.port copy];

    SCServerDetailViewController *viewController = [[SCServerDetailViewController alloc] initWithNibName:@"SCServerDetailViewController" bundle:nil];
    viewController.server = newServer;
    viewController.duplicated = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)dealloc
{
    [self.server removeObserver:self forKeyPath:@"name"];
}

@end