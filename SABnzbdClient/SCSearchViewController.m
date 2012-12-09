//
//  SCSearchViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchViewController.h"
#import "SCNZBResult.h"
#import "SCAsynchronousSearchDisplayController.h"
#import "SCNZBMatrixAccountViewController.h"
#import "SCSearchAccount.h"
#import "SCSearchAccount+Additions.h"
#import "SCSearchFilterItem.h"
#import "SCSearchFilterItemEditorViewController.h"

static const CGFloat kSortBarHeight = 44.0f;

@interface SCSearchViewController () <SCCategoryPickerDataSourceDelegate>

- (void)showAccountSettings;

//@property (strong) BASlidingDrawerView *categoryDrawerView;
@property (strong) NSArray *searchOrderFilters;
@property (nonatomic, strong) NSOperation *downloadClientOperation;
@property (nonatomic, strong) SCSABnzbdClient *client;
@property (nonatomic, strong) SCNZBResult *selectedResult;

@end

@implementation SCSearchViewController

#pragma mark - SCBaseTableViewController

- (UIEdgeInsets)searchTableInsets
{
    return UIEdgeInsetsMake(kSortBarHeight, 0.0f, 0.0f, 0.0f);
}

- (void)setAccount:(SCSearchAccount *)account
{
    _account = account;
    self.title = account.name;
    self.searchOrderFilters = [account possibleOrderItems];
    
    if ([self isViewLoaded]) {
        [self updateSearchOrderFilters];
    }
}

- (void)setup
{
    [super setup];
    self.client = [SCSABnzbdClient clientWithServer:[SCServer activeServer]];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.account hasSettings]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ACCOUNT_KEY", nil)
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(showAccountSettings)];
    }

    self.categoriesDataSource.searchAccount = self.account;
    [self.categoriesDataSource loadData];

    self.dataSource.searchAccount = self.account;
    [self.dataSource loadData];
    [self updateSearchOrderFilters];
    
    self.searchDisplayController.searchBar.placeholder = NSLocalizedString(@"SEARCH_KEY", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Show NZBMatrix placeholder if account details invalid
    if ([self.account.key isEqualToString:kSearchAccountKeyNZBMatrix]) {
        if (![self.account isValid]) {
            [self showPlaceholderWithMessage:NSLocalizedString(@"CONFIGURE_NZB_MATRIX_KEY", nil)];
        } else {
            [self hidePlaceholder];
        }
    }
    
    // Reload, as we may have updated filter
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.asynchronousSearchDisplayController.searchResultsTableView deselectRowAtIndexPath:[self.asynchronousSearchDisplayController.searchResultsTableView indexPathForSelectedRow] animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (BASlidingDrawerView *)loadCategoryDrawer
//{
//    if (!self.categoryDrawerView) {
//        NSArray *otherPanTargets = [NSArray arrayWithObjects:self.searchDisplayController.searchBar, nil];
//        BASlidingDrawerView *drawerView = [[BASlidingDrawerView alloc] initWithFrame:self.view.bounds
//                                                            additionalPanTargetViews:otherPanTargets];
//        drawerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        drawerView.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
//        drawerView.titleView.text = @"Category";
//        
//        self.categoryDrawerView = drawerView;
//    }
//    
//    return self.categoryDrawerView;
//}

- (void)updateSearchOrderFilters
{
    NSMutableArray *scopeButtonTitles = [NSMutableArray arrayWithCapacity:4];
    
    for (NSNumber *itemNumber in self.searchOrderFilters) {
        SCSearchOrderingScopeBarItem item = (SCSearchOrderingScopeBarItem)[itemNumber integerValue];
        switch (item) {
            case SCSearchOrderingScopeBarItemDate:
                [scopeButtonTitles addObject:NSLocalizedString(@"DATE", nil)];
                break;
            case SCSearchOrderingScopeBarItemHits:
                [scopeButtonTitles addObject:NSLocalizedString(@"SEARCH_RESULT_HITS_KEY", nil)];
                break;
            case SCSearchOrderingScopeBarItemName:
                [scopeButtonTitles addObject:NSLocalizedString(@"SEARCH_RESULT_NAME_KEY", nil)];
                break;
            case SCSearchOrderingScopeBarItemSize:
                [scopeButtonTitles addObject:NSLocalizedString(@"SEARCH_RESULT_SIZE_KEY", nil)];
                break;
        }
    }
    
    self.searchDisplayController.searchBar.scopeButtonTitles = scopeButtonTitles;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.dataSource performSearch:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.dataSource.searchTerm = searchText;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 65.0f;
    
    // Provide space for sort bar
//    tableView.scrollIndicatorInsets = [self searchTableInsets];
//    tableView.contentInset = [self searchTableInsets];
    
    self.dataSource.tableView = tableView;
    
//    BASlidingDrawerView *drawerView = [self loadCategoryDrawer];
//    drawerView.frame = UIEdgeInsetsInsetRect(self.tableView.superview.bounds, UIEdgeInsetsMake(55, 0, 0, 0));
//    [tableView.superview addSubview:drawerView];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        for (UIView *v in controller.searchResultsTableView.subviews) {
            if ([v isKindOfClass:[UILabel class]]) {
                v.hidden = YES;
            }
        }
    });

    return NO;
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    self.dataSource.order = (SCSearchOrderingScopeBarItem)[[self.searchOrderFilters objectAtIndex:selectedScope] integerValue];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.dataSource clearResults];
}

- (void)searchViewControllerDataSourceDidStartLoading:(SCSearchViewControllerDataSource *)dataSource
{
    [self.asynchronousSearchDisplayController showActivityIndicator];
    [self.asynchronousSearchDisplayController hidePlaceholder];
}

- (void)searchViewControllerDataSource:(SCSearchViewControllerDataSource *)dataSource didFailWithError:(NSString *)error
{
    [self.asynchronousSearchDisplayController hideActivityIndicator];
    [SCPopupMessageView showWithMessage:error overView:self.asynchronousSearchDisplayController.searchResultsTableView];
}

- (void)searchViewControllerDataSourceDidFinishLoading:(SCSearchViewControllerDataSource *)dataSource
{
    [self.asynchronousSearchDisplayController hideActivityIndicator];
    [self.asynchronousSearchDisplayController hidePlaceholder];

    self.searchDisplayController.searchResultsTableView.dataSource = self.dataSource;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    [self.asynchronousSearchDisplayController hideActivityIndicator];
    [self.asynchronousSearchDisplayController hidePlaceholder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        SCSearchFilterItemEditorViewController *viewController = [[SCSearchFilterItemEditorViewController alloc] initWithNibName:@"SCSearchFilterItemEditorViewController" bundle:nil];
        viewController.searchAccount = self.account;
        viewController.filterCategory = [self.categoriesDataSource.fetchedResultsController objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        SCNZBResult *result = self.dataSource.results[indexPath.row];
        SCSearchResultDetailViewController *detailViewController = [[SCSearchResultDetailViewController alloc] initWithNibName:@"SCSearchResultDetailViewController" bundle:nil];
        detailViewController.searchResult = result;
        detailViewController.delegate = self;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (void)searchResultDetailViewControllerDidAddDownload:(SCSearchResultDetailViewController *)viewController
{
    [self.navigationController popToViewController:self animated:YES];
    [SCPopupMessageView showWithMessage:NSLocalizedString(@"DOWNLOAD_ADDED_KEY", nil) overView:self.view];
}

- (void)showAccountSettings
{
    UIViewController *settingsViewController = [self.account settingsViewController];
    [self showModalViewController:settingsViewController withDoneSystemItem:UIBarButtonSystemItemDone];
}

#pragma mark - Keyboard

//- (void)keyboardWillShow:(NSNotification *)notification {
//    
//	[self keyboardWillShow:YES withNotification:notification];
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    
//	[self keyboardWillShow:NO withNotification:notification];
//}
//
//- (void)keyboardWillShow:(BOOL)show withNotification:(NSNotification *)notification
//{
//	NSDictionary *userInfo = [notification userInfo];
//	
//	// Calculate the keyboard height
//    CGRect keyboardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    // Conversion required, to take into account rotation
//    CGFloat keyboardHeight = [self.view.window convertRect:keyboardEndFrame toView:self.searchDisplayController.searchResultsTableView].size.height;
//    
//	// Get animation curve and duration (see http://stackoverflow.com/questions/3332364/uikeyboardframebeginuserinfokey-uikeyboardframeenduserinfokey)
//	UIViewAnimationCurve curve;
//	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
//    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//	
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:curve];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    
//	if (show) {
//        self.categoryDrawerView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
//	} else {
//        self.categoryDrawerView.contentInset = UIEdgeInsetsZero;
//	}
//    
//    [UIView commitAnimations];
//}

#pragma mark - Long press download

- (void)searchViewControllerDataSourceShouldDownloadWithResult:(SCNZBResult *)result
{
    SCServer *server = [SCServer activeServer];
    
    if (server) {
        if ([server.categories count]) {
            self.selectedResult = result;
            SCCategoryPickerDataSource *dataSource = [[SCCategoryPickerDataSource alloc] initWithDelegate:self server:server];
            [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"SEARCH_RESULT_CATEGORY_KEY", nil)];
        } else {
            [self startDownloadWithCategory:nil result:result];
        }
    } else {
        [SCPopupMessageView showWithMessage:NSLocalizedString(@"NO_ACTIVE_SERVER_KEY", nil) overView:self.view];
    }
}

- (void)categoryPickerDataSource:(SCCategoryPickerDataSource *)dataSource didPickCategory:(SCCategory *)category
{
    [self startDownloadWithCategory:category result:self.selectedResult];
    self.selectedResult = nil;
}

- (void)startDownloadWithCategory:(SCCategory *)category result:(SCNZBResult *)result
{
    if (!result)
        return;
    
    [self.asynchronousSearchDisplayController showActivityIndicator];
    [self.downloadClientOperation cancel];
    self.downloadClientOperation = [self.client startDownloadRequestWithURL:[result downloadURL]
                                                                       name:result.name
                                                                   category:category
                                                                    success:^(NSString *apiError) {
                                                                        if (apiError) {
                                                                            [SCPopupMessageView showWithMessage:apiError
                                                                                                       overView:self.searchDisplayController.searchResultsTableView.superview];
                                                                            [self.asynchronousSearchDisplayController hideActivityIndicator];
                                                                            
                                                                        } else {
                                                                            [SCPopupMessageView showWithMessage:NSLocalizedString(@"DOWNLOAD_ADDED_KEY", nil)
                                                                                                       overView:self.searchDisplayController.searchResultsTableView.superview
                                                                                                      iconImage:[UIImage imageNamed:@"Icon-Tick.png"]];
                                                                            
                                                                            [self.asynchronousSearchDisplayController hideActivityIndicator];
                                                                        }
                                                                    } failure:^(NSError *error) {
                                                                        [SCPopupMessageView showWithMessage:[error localizedDescription]
                                                                                                   overView:self.searchDisplayController.searchResultsTableView.superview];
                                                                        [self.asynchronousSearchDisplayController hideActivityIndicator];
                                                                    }];

}

@end