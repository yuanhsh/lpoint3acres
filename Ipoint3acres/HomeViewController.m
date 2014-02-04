//
//  HomeViewController.m
//  Ipoint3acres
//
//  Created by 苑　海勝 on 2014/01/30.
//  Copyright (c) 2014年 Kickmogu. All rights reserved.
//

#import "HomeViewController.h"
#import "DataManager.h"

@interface HomeViewController ()
@property (nonatomic, strong) NSMutableArray *boardControllers;
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.boardControllers = [NSMutableArray arrayWithArray:@[@"头条", @"科技", @"娱乐", @"财经", @"原创", @"社会", @"汽车"]];
	
    self.flickTabView = [[FlickTabView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, self.view.frame.size.width, TAB_HEIGHT)];
    self.flickTabView.delegate = self;
	self.flickTabView.dataSource = self;
    
    [self.view addSubview:self.flickTabView];
    [self.flickTabView presentTabs];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    BoardViewController *boardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardViewController"];
    [self.pageViewController setViewControllers:@[boardViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    CGFloat offsetY = 64.0 + TAB_HEIGHT;
    self.pageViewController.view.frame = CGRectMake(0, offsetY, self.view.bounds.size.width, self.view.bounds.size.height-offsetY);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initBoardData {
    NSManagedObjectContext *context = [DataManager sharedInstance].mainObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Board" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contentsId" ascending:YES];
//    [fetchRequest setSortDescriptors:@[sortDescriptor]];
//    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"firstName == 'George'"]];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    if (!fetchedObjects || fetchedObjects.count == 0) {
        
        Board *board = [NSEntityDescription insertNewObjectForEntityForName:@"Board" inManagedObjectContext:context];
    }
}

#pragma mark -
#pragma mark FlickTabView Delegate & Data Source

- (void)scrollTabView:(FlickTabView*)scrollTabView didSelectedTabAtIndex:(NSInteger)index {
	NSLog(@"tab index %d selected!", index);
}

- (NSInteger)numberOfTabsInScrollTabView:(FlickTabView*)scrollTabView {
	return [self.boardControllers count];
}

- (NSString*)scrollTabView:(FlickTabView*)scrollTabView titleForTabAtIndex:(NSInteger)index {
	return [self.boardControllers objectAtIndex:index];
}

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    BoardViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardViewController"];
    return contentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    BoardViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardViewController"];
    return contentViewController;
}


@end
