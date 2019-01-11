//
//  ViewController.m
//  OpenMemberDemo
//
//  Created by 李少锋 on 2019/1/11.
//  Copyright © 2019年 李少锋. All rights reserved.
//

#import "ViewController.h"
#import "OpenMemberVC.h"
#import "UIView+NTES.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button=[[UIButton alloc]init];
    [button setTitle:@"开通会员" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor redColor];
    button.frame=CGRectMake(0, 200, 100, 50);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button setCenterX:CGRectGetWidth(self.view.frame)/2];
}

-(void)buttonClick:(UIButton *)button{
    OpenMemberVC *openMemberVC=[[OpenMemberVC alloc]init];
    [self.navigationController pushViewController:openMemberVC animated:YES];
}


@end
