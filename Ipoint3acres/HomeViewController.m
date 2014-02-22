//
//  HomeViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/01/30.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "DataManager.h"

@interface HomeViewController ()
@property (nonatomic, strong) NSArray *boardControllers;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.boardControllers = [self getBoardControllers];
	
    self.flickTabView = [[FlickTabView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, TAB_HEIGHT)];
    self.flickTabView.delegate = self;
	self.flickTabView.dataSource = self;
    
    [self.view addSubview:self.flickTabView];
    [self.flickTabView presentTabs];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self.pageViewController setViewControllers:@[self.boardControllers[0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    CGFloat offsetY = 0.0f + TAB_HEIGHT;
    self.pageViewController.view.frame = CGRectMake(0, offsetY, self.view.bounds.size.width, self.view.bounds.size.height-offsetY);
    
    [self.pageViewController.view.subviews[0] setDelegate:self];
    
    NSLog(@"DocumentsDirectory: %@", DocumentsDirectory);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getBoardControllers {
    NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Board" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
//    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"firstName == 'George'"]];
    NSArray *fetchedBoards = [context executeFetchRequest:fetchRequest error:nil];
    if (!fetchedBoards || fetchedBoards.count == 0) {
        NSLog(@"Board data is null, insert default boards");
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DefaultBoards" ofType:@"plist"];
        NSArray *defaultBoards = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        for (NSDictionary *item in defaultBoards) {
            Board *board = [NSEntityDescription insertNewObjectForEntityForName:@"Board" inManagedObjectContext:context];
            [board safeSetValuesForKeysWithDictionary:item];
        }
        [[DataManager sharedInstance] save];
        fetchedBoards = [context executeFetchRequest:fetchRequest error:nil];
    }
    
    NSMutableArray *boardControllers = [NSMutableArray array];
    for (Board *board in fetchedBoards) {
        BoardViewController *boardController = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardViewController"];
        boardController.board = board;
        [boardControllers addObject:boardController];
    }
    
    return boardControllers;
}

- (IBAction)showUserProfile:(id)sender {
    ServiceClient *client = [[ServiceClient alloc] init];
//    if (client.loginedUserId) {//profileController
        ProfileViewController *profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileController"];
        profileController.userID = client.loginedUserId;
        profileController.viewSelf = YES;
        [self.navigationController pushViewController:profileController animated:YES];
//    } else {
//        static NSString *userLoginNotification = @"UserLoginNotification";
//        LoginViewController *loginController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginController"];
//        loginController.notificationName = userLoginNotification;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserProfile:) name:userLoginNotification object:nil];
//        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:loginController];
//        [self presentViewController:controller animated:YES completion:nil];
//    }
}

#pragma mark -
#pragma mark FlickTabView Delegate & Data Source

- (void)scrollTabView:(FlickTabView*)scrollTabView didSelectedTabAtIndex:(NSInteger)index {
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    if (index < scrollTabView.selectedTabIndex) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
	[self.pageViewController setViewControllers:@[self.boardControllers[index]]
                                      direction:direction
                                       animated:NO
                                     completion:nil];
}

- (NSInteger)numberOfTabsInScrollTabView:(FlickTabView*)scrollTabView {
	return [self.boardControllers count];
}

- (NSString*)scrollTabView:(FlickTabView*)scrollTabView titleForTabAtIndex:(NSInteger)index {
    BoardViewController *controller = [self.boardControllers objectAtIndex:index];
	return controller.board.name;
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.boardControllers indexOfObject:viewController];
    if (index <= 0) {
        return nil;
    }
    return self.boardControllers[index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.boardControllers indexOfObject:viewController];
    if (index >= self.boardControllers.count - 1) {
        return nil;
    }
    return self.boardControllers[index+1];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)pageView {
    CGFloat offsetX = pageView.contentOffset.x;
    //CGFloat ratio = (offsetX - 320) / 320.0f;
    if (offsetX == 320.0f) {
        UIViewController *viewController = self.pageViewController.viewControllers[0];
        NSInteger index = [self.boardControllers indexOfObject:viewController];
        [self.flickTabView selectTabAtIndex:index animated:YES];
    } else if (offsetX > 320) { // going to next page
        
    } else if (offsetX < 320) { // going to prev page
        
    }
}

@end
