//
//  HomePageVC.m
//  TestTemplateProject
//
//  Created by Ben on 2017/5/22.
//  Copyright (c) 2017年 Ben. All rights reserved.
//

#import "HomePageVC.h"
#import "ColdHotSignalVC.h"
#import "UsageVC.h"
#import "SingleOperationsVC.h"
#import "GroupOperationsVC.h"
#import "TwoWayBindingVC.h"
#import "LifeCycleAndMemoryVC.h"
#import "PlaygroundVC.h"
#import "RACMLKVC.h"

static const CGFloat kTableViewCellHeight = 60.0f;

@interface HomePageCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) Block didSelectCellHandleBlock;

+ (instancetype)modelWithTitle:(NSString *)title
                      subTitle:(NSString *)subTitle
                       vcClass:(Class)vcClass
                  navigationVC:(UINavigationController *)navigationVC;

+ (instancetype)modelWithTitle:(NSString *)title
                      subTitle:(NSString *)subTitle
      didSelectCellHandleBlock:(Block)didSelectCellHandleBlock;

@end

@implementation HomePageCellModel

+ (instancetype)modelWithTitle:(NSString *)title
                      subTitle:(NSString *)subTitle
                       vcClass:(Class)vcClass
                  navigationVC:(UINavigationController *)navigationVC {
    
    return [HomePageCellModel modelWithTitle:title
                                    subTitle:subTitle
                    didSelectCellHandleBlock:^{
                        UIViewController *vc = [[vcClass alloc] init];
                        [navigationVC pushViewController:vc animated:YES];
                    }];
}


+ (instancetype)modelWithTitle:(NSString *)title
                      subTitle:(NSString *)subTitle
      didSelectCellHandleBlock:(Block)didSelectCellHandleBlock {
    HomePageCellModel *model = [HomePageCellModel new];
    model.title = title;
    model.subTitle = subTitle;
    model.didSelectCellHandleBlock = didSelectCellHandleBlock;
    
    return model;
}

@end

@interface HomePageVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray <HomePageCellModel *> *dataSourceArray;

@end

@implementation HomePageVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    HomePageCellModel *model1 = [HomePageCellModel modelWithTitle:@"基本使用"
                                                         subTitle:@"一些常见的使用语法"
                                                          vcClass:[UsageVC class]
                                                     navigationVC:self.navigationController];
    
    HomePageCellModel *model2 = [HomePageCellModel modelWithTitle:@"生命周期与内存管理"
                                                         subTitle:@"冷/热信号订阅和取消订阅"
                                                          vcClass:[LifeCycleAndMemoryVC class]
                                                     navigationVC:self.navigationController];
    
    HomePageCellModel *model3 = [HomePageCellModel modelWithTitle:@"冷/热信号"
                                                         subTitle:@"基本的类图结构"
                                                          vcClass:[ColdHotSignalVC class]
                                                     navigationVC:self.navigationController];
    
    HomePageCellModel *model4 = [HomePageCellModel modelWithTitle:@"单个信号基本操作"
                                                         subTitle:@"一些常见的单信号基本操作"
                                                          vcClass:[SingleOperationsVC class]
                                                     navigationVC:self.navigationController];
    
    HomePageCellModel *model5 = [HomePageCellModel modelWithTitle:@"多个信号组合操作"
                                                         subTitle:@"一些常见的多信号组合操作"
                                                          vcClass:[GroupOperationsVC class]
                                                     navigationVC:self.navigationController];
    
    HomePageCellModel *model6 = [HomePageCellModel modelWithTitle:@"双向绑定"
                                                         subTitle:@"一些常见的双向绑定案例"
                                                          vcClass:[TwoWayBindingVC class]
                                                     navigationVC:self.navigationController];
    
    HomePageCellModel *model7 = [HomePageCellModel modelWithTitle:@"内存泄漏"
                                                         subTitle:@"一些经典的内存泄漏案例"
                                                          vcClass:[RACMLKVC class]
                                                     navigationVC:self.navigationController];

    HomePageCellModel *model8 = [HomePageCellModel modelWithTitle:@"操场"
                                                         subTitle:@"Do whatever you want here"
                                                          vcClass:[PlaygroundVC class]
                                                     navigationVC:self.navigationController];
    
    self.dataSourceArray = [NSArray arrayWithObjects:model1, model2, model3, model4, model5, model6, model7, model8, nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"RAC总结归纳";
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellReuseIdentifier = @"HomePageCellReuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellReuseIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.textLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row].title;
    cell.detailTextLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row].subTitle;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Block clickHandleBlock = [self.dataSourceArray objectAtIndex:indexPath.row].didSelectCellHandleBlock;
    if (clickHandleBlock) {
        clickHandleBlock();
    }
}

@end


