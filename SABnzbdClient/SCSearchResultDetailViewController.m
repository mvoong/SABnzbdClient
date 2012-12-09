//
//  SCSearchResultDetailViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchResultDetailViewController.h"
#import "SCSearchResultDetailViewControllerDataSource.h"
#import "SCNZBMatrixSearchClient.h"
#import "SCImageViewController.h"
#import "SCWebViewController.h"

@interface SCSearchResultDetailViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SCSABnzbdClient *client;
@property (nonatomic, strong) NSOperation *downloadClientOperation;

@end

@implementation SCSearchResultDetailViewController

static NSString *const kIMDBSchemaURL = @"imdb:///title/%@/";
static NSString *const kIMDBWebsiteURL = @"http://www.imdb.com/title/%@/";

- (void)setSearchResult:(id<SCNZBItem>)searchResult
{
    _searchResult = searchResult;
    self.dataSource.result = searchResult;
    [self.dataSource loadData];
}

- (void)setup
{
    [super setup];

    self.title = NSLocalizedString(@"DETAILS_KEY", nil);
    
    SCServer *server = [SCServer findFirstByAttribute:@"active" withValue:[NSNumber numberWithBool:YES]];
    self.client = [SCSABnzbdClient clientWithServer:server];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataSource.result = self.searchResult;
    [self.dataSource loadData];

    [self.downloadButton setTitle:NSLocalizedString(@"ADD_TO_QUEUE_KEY", nil) forState:UIControlStateNormal];
    self.titleLabel.text = self.searchResult.name;
}

- (void)startDownload
{
    SCServer *server = [SCServer activeServer];

    if (server) {
        if ([server.categories count]) {
            SCCategoryPickerDataSource *dataSource = [[SCCategoryPickerDataSource alloc] initWithDelegate:self server:server];
            [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"SEARCH_RESULT_CATEGORY_KEY", nil)];
        } else {
            [self startDownloadWithCategory:nil];
        }
    } else {
        [SCPopupMessageView showWithMessage:NSLocalizedString(@"NO_ACTIVE_SERVER_KEY", nil) overView:self.view];
    }
}

- (void)categoryPickerDataSource:(SCCategoryPickerDataSource *)dataSource didPickCategory:(SCCategory *)category
{
    [self startDownloadWithCategory:category];
}

- (void)startDownloadWithCategory:(SCCategory *)category
{
    [self showActivityIndicator];

    [self.downloadClientOperation cancel];
    self.downloadClientOperation = [self.client startDownloadRequestWithURL:[self.searchResult downloadURL]
                                                                       name:self.searchResult.name
                                                                   category:category
                                                                    success:^(NSString *apiError) {
                                                                        [self hideActivityIndicator];
                                                                        
                                                                        if (apiError) {
                                                                            [SCPopupMessageView showWithMessage:apiError overView:self.view];
                                                                        } else {
                                                                            [self.delegate searchResultDetailViewControllerDidAddDownload:self];
                                                                        }
                                                                    } failure:^(NSError *error) {
                                                                        [self hideActivityIndicator];
                                                                        [SCPopupMessageView showWithMessage:[error localizedDescription]
                                                                                                   overView:self.view
                                                                                                  iconImage:[UIImage imageNamed:@"Icon-Wifi.png"]];
                                                                    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.dataSource.imageView.image)
        return 100;

    return self.tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && self.dataSource.imageView.image) {
        SCImageViewController *imageViewController = [[SCImageViewController alloc] initWithNibName:@"SCImageViewController" bundle:nil];
        imageViewController.imageURL = [NSURL URLWithString:self.searchResult.imageURL];
        imageViewController.title = self.searchResult.name;
        [self.navigationController pushViewController:imageViewController animated:YES];
    } else {
        NSInteger attributeRow = indexPath.row;
        
        // Offset index path if have image
        if (self.dataSource.imageView.image)
            attributeRow--;
        
        if ([[[self.dataSource attributes] objectAtIndex:attributeRow] isEqualToString:@"SEARCH_RESULT_LAUNCH_IMDB_KEY"]) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kIMDBSchemaURL, [self.searchResult imdbTitleID]]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            } else {
                url = [NSURL URLWithString:[NSString stringWithFormat:kIMDBWebsiteURL, [self.searchResult imdbTitleID]]];
                [[UIApplication sharedApplication] openURL:url];
            }
            
            // Deselect row, as we'll be leaving app and viewWillAppear won't fire when we come back
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        }
        //    else if ([[[self.dataSource attributes] objectAtIndex:indexPath.row] isEqualToString:@"SEARCH_RESULT_NFO_KEY"]) {
        //        if ([[self.searchResult hasNFO] boolValue]) {
        //            SCWebViewController *viewController = [[SCWebViewController alloc] init];
        //            viewController.directLoadMode = YES;
        //            viewController.urlRequest = [NSURLRequest requestWithURL:[SCNZBMatrixSearchClient nfoURLForNZBId:[self.searchResult nzbId]]];
        //            [self.navigationController pushViewController:viewController animated:YES];
        //        }
        //    }
    }
}

- (void)viewDidUnload
{
    self.dataSource = nil;
    self.downloadButton = nil;
    self.titleLabel = nil;
    [super viewDidUnload];
}

@end