//
//  OpenMemberVC.m
//  OpenMemberDemo
//
//  Created by 李少锋 on 2019/1/11.
//  Copyright © 2019年 李少锋. All rights reserved.
//

#import "OpenMemberVC.h"
#import "UIView+NTES.h"
#import <Masonry.h>

static NSString *cellName=@"Cellname";

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#ifndef IS_IPHONE_X
#define IS_IPHONE_X ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812)
#endif

#ifndef SAFE_AREA
#define SAFE_AREA ({ \
UIEdgeInsets insets = UIEdgeInsetsMake(20, 0, 0, 0);\
if (@available(iOS 11.0, *)) {\
if (IS_IPHONE_X) {\
insets = [UIApplication              sharedApplication].keyWindow.safeAreaInsets;\
if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {\
insets = UIEdgeInsetsMake(44, 0, 34, 0);\
}\
}\
}\
insets;\
})
#endif
#ifndef TOP_SAFE_AREA
#define TOP_SAFE_AREA (SAFE_AREA.top)
#endif

#ifndef BOTTOM_SAFE_AREA
#define BOTTOM_SAFE_AREA (SAFE_AREA.bottom)
#endif

static const CGFloat cellHeaderViewHeight=60;

static const CGFloat oneSectionHeaderViewHeight=110;

static const CGFloat SectionFooterViewHeight=20;

#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define SXColorA(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define BuyViewHeight 60

@interface OpenMemberVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,copy)NSMutableArray *dataArray;

@property(nonatomic,strong)UIView *buyView;

@property(nonatomic,copy)NSString *textStr;

@end

@implementation OpenMemberVC

//计算文本的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withLineHeight:(CGFloat)lineHeight{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineHeight;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"开通VIP会员";
    _textStr=@"1.免费赠送专家文字咨询1次\n2.免费开通付费专栏1个\n3.有效期内免费畅读电子书\n4.免费赠送500个平台积分\n5.免费赠送付费类音视频课程1个\n6.有效期内免费观看付费直播\n7.免费加入1个付费圈子";
    _dataArray=[[NSMutableArray alloc]init];
    for(NSInteger i=0;i<3;i++){
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        if(i==0){
            [dic setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",i]];
        }
        else{
            [dic setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%ld",i]];
        }
        [_dataArray addObject:dic];
    }
    [self initTableView];
    [self.view addSubview:self.buyView];
}

//初始化tabView
-(void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, TOP_SAFE_AREA + 44 + 5, SCREEN_WIDTH , SCREEN_HEIGHT - TOP_SAFE_AREA - 44 - BOTTOM_SAFE_AREA - 49 - 5)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
}

#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self tableHeaderViewInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSDictionary *dic=[_dataArray objectAtIndex:section];
    NSNumber *state=[dic objectForKey:[NSString stringWithFormat:@"%ld",section]];
    CGFloat textHeight=[self getSpaceLabelHeight:_textStr withFont:[UIFont systemFontOfSize:14.0f] withWidth:SCREEN_WIDTH-50 withLineHeight:2];
    if(section==0){
        if([state boolValue])
        {
            return oneSectionHeaderViewHeight+textHeight+40;
        }
        else{
            return oneSectionHeaderViewHeight;
        }
    }
    else{
        if([state boolValue])
        {
            return cellHeaderViewHeight+textHeight+40;
        }
        else{
            return cellHeaderViewHeight;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return SectionFooterViewHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    return cell;
}

//tableView的HeaderView
-(UIView *)tableHeaderViewInSection:(NSInteger)section{
    UIView *headerView=[[UIView alloc]init];
    headerView.userInteractionEnabled=YES;
    headerView.backgroundColor=[UIColor whiteColor];
    
    UILabel *headerTitleLabel;
    if(section==0){
        headerTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 30)];
        headerTitleLabel.text=@"VIP会员套餐";
        headerTitleLabel.font=[UIFont systemFontOfSize:15.0f];
        headerTitleLabel.textAlignment=NSTextAlignmentLeft;
        headerTitleLabel.textColor=[UIColor blackColor];
        [headerView addSubview:headerTitleLabel];
    }
    
    UIView *views=[[UIView alloc]init];
    views.userInteractionEnabled=YES;
    views.layer.masksToBounds=YES;
    views.layer.borderWidth=1;
    views.layer.cornerRadius=8;
    [headerView addSubview:views];
    if(headerTitleLabel){
        views.frame=CGRectMake(15, headerTitleLabel.top+headerTitleLabel.height+10, SCREEN_WIDTH-30, cellHeaderViewHeight);
    }
    else{
        views.frame=CGRectMake(15, 0, SCREEN_WIDTH-30, cellHeaderViewHeight);
    }
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 10, 10)];
    imageView.image=[UIImage imageNamed:@"close_openMember"];
    [views addSubview:imageView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageView.right+10, 20, 100, 20)];
    titleLabel.text=@"7天体验套餐";
    titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=[UIColor blackColor];
    [views addSubview:titleLabel];
    
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(titleLabel.right+10, 20, views.width-(titleLabel.right+30), 20)];
    priceLabel.text=@"￥9.9元";
    priceLabel.font=[UIFont systemFontOfSize:15.0f];
    priceLabel.textAlignment=NSTextAlignmentRight;
    priceLabel.textColor=rgb(55, 178, 144);
    [views addSubview:priceLabel];
    
    NSMutableDictionary *dic=[_dataArray objectAtIndex:section];
    NSNumber *state=[dic objectForKey:[NSString stringWithFormat:@"%ld",section]];
    if([state boolValue]){//展开状态
        CGFloat textHeight=[self getSpaceLabelHeight:_textStr withFont:[UIFont systemFontOfSize:14.0f] withWidth:SCREEN_WIDTH-50 withLineHeight:2];
        if(headerTitleLabel){
            views.frame=CGRectMake(15, headerTitleLabel.top+headerTitleLabel.height+10, SCREEN_WIDTH-30, cellHeaderViewHeight+textHeight+40);
        }
        else{
            views.frame=CGRectMake(15, 0, SCREEN_WIDTH-30, cellHeaderViewHeight+textHeight+40);
        }
        views.backgroundColor=rgb(236, 252, 247);
        views.layer.borderColor=rgb(55, 178, 144).CGColor;
        
        imageView.image=[UIImage imageNamed:@"open_openMember"];
        
        //添加显示文本
        UILabel *lineLabel=[[UILabel alloc]init];
        lineLabel.backgroundColor=rgb(55, 178, 144);
        [views addSubview:lineLabel];
        lineLabel.frame=CGRectMake(10, titleLabel.top+titleLabel.height+10, CGRectGetWidth(views.frame)-20, 0.5);
        
        UILabel *memberInfoLabel=[[UILabel alloc]init];
        memberInfoLabel.frame=CGRectMake(0, lineLabel.top+lineLabel.height+10, 60, 20);
        memberInfoLabel.text=@"会员特权";
        [memberInfoLabel setCenterX:(SCREEN_WIDTH-30)/2];
        memberInfoLabel.textAlignment=NSTextAlignmentCenter;
        memberInfoLabel.font=[UIFont systemFontOfSize:14.0f];
        memberInfoLabel.textColor=rgb(242, 156, 79);
        [views addSubview:memberInfoLabel];
        
        UIImageView *leftImageView=[[UIImageView alloc]init];
        leftImageView.image=[UIImage imageNamed:@"left_openMember"];
        leftImageView.frame=CGRectMake(memberInfoLabel.left-30, 0, 20, 10);
        [leftImageView setCenterY:memberInfoLabel.centerY];
        [views addSubview:leftImageView];
        
        UIImageView *rightImageView=[[UIImageView alloc]init];
        rightImageView.image=[UIImage imageNamed:@"right_openMember"];
        rightImageView.frame=CGRectMake(memberInfoLabel.right+10, 0, 20, 10);
        [rightImageView setCenterY:memberInfoLabel.centerY];
        [views addSubview:rightImageView];
        
        UITextView *textView=[[UITextView alloc]init];
        textView.frame=CGRectMake(10, memberInfoLabel.top+memberInfoLabel.height, CGRectGetWidth(views.frame)-20, textHeight);
        textView.text=_textStr;
        textView.userInteractionEnabled=NO;
        textView.backgroundColor=[UIColor clearColor];
        textView.font=[UIFont systemFontOfSize:14.0f];
        textView.textColor=rgb(68, 67, 67);
        [views addSubview:textView];
    }
    else{//关闭状态
        if(headerTitleLabel){
            views.frame=CGRectMake(15, headerTitleLabel.top+headerTitleLabel.height+10, SCREEN_WIDTH-30, cellHeaderViewHeight);
        }
        else{
            views.frame=CGRectMake(15, 0, SCREEN_WIDTH-30, cellHeaderViewHeight);
        }
        views.backgroundColor=[UIColor whiteColor];
        views.layer.borderColor=rgb(208, 208, 208).CGColor;
        
        imageView.image=[UIImage imageNamed:@"close_openMember"];
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [views addGestureRecognizer:tap];
    UIView *singleTapView=[tap view];
    singleTapView.tag=section;
    
    return headerView;
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *dict=(NSMutableDictionary *)obj;
            if([tap view].tag==idx){
                NSMutableDictionary *dic=[self.dataArray objectAtIndex:[tap view].tag];
                NSNumber *state=[dic objectForKey:[NSString stringWithFormat:@"%ld",[tap view].tag]];
                if([state boolValue])
                {
                    [dic setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%ld",[tap view].tag]];
                }
                else
                {
                    [dic setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",[tap view].tag]];
                }
            }
            else{
                [dict setObject:[NSNumber numberWithBool:NO] forKey:[NSString stringWithFormat:@"%ld",idx]];
            }
        }
    }];
    [_tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = oneSectionHeaderViewHeight;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//立即购买view
-(UIView *)buyView{
    if(!_buyView){
        _buyView=[[UIView alloc]init];
        [self.view addSubview:_buyView];
    }
    [_buyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).offset(-BuyViewHeight);
        make.height.equalTo(@BuyViewHeight);
    }];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:@"支付" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.layer.cornerRadius=20;
    buyBtn.layer.shadowColor = SXColorA(0, 0, 0, 0.5).CGColor;
    buyBtn.layer.shadowOffset=CGSizeMake(0, 2);
    buyBtn.layer.shadowOpacity=0.5;
    buyBtn.layer.shadowRadius=5;
    
    [buyBtn setBackgroundColor:rgb(45, 179, 143)];
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_buyView).offset(30);
        make.right.equalTo(self->_buyView).offset(-30);
        make.top.equalTo(self->_buyView).offset(10);
        make.height.mas_equalTo(40);
    }];
    return _buyView;
}

-(void)buyBtnClick:(UIButton *)button{
    NSLog(@"支付");
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
