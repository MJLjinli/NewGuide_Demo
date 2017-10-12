//
//  DemoViewController.m
//  NewGuide_Demo
//
//  Created by 马金丽 on 17/10/10.
//  Copyright © 2017年 majinli. All rights reserved.
//

#import "DemoViewController.h"
#import "MJLGuideMaskView.h"
@interface DemoViewController ()<MJLGuideMaskViewDataSouce,MJLGuideMaskViewLayout>
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *viewCollections;
@property (weak, nonatomic) IBOutlet UIButton *btnView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnView.layer.cornerRadius = 30;
    self.btnView.layer.masksToBounds = YES;
    
}
- (IBAction)showClick:(id)sender {
    
    MJLGuideMaskView *maskView = [[MJLGuideMaskView alloc]initWithDataSource:self];
    maskView.layout = self;
    [maskView show];
    
}

- (NSInteger)numberOfItemsInGuideMaskView:(MJLGuideMaskView *)guideMaskView
{
    return self.viewCollections.count;
}

- (UIView *)guideMaskView:(MJLGuideMaskView *)guideMaskView viewForItemAtIndex:(NSInteger)index
{
    return self.viewCollections[index];
}


- (NSString *)guideMaskView:(MJLGuideMaskView *)guideMaskView descriptionForItemAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"这是第%ld个视图",(long)index];
}

- (CGFloat)guideMaskView:(MJLGuideMaskView *)guideMaskView cornerRadiusForViewAtIndex:(NSInteger)index
{
    if (index == self.viewCollections.count - 1) {
        return 30;
    }
    return 5;
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
