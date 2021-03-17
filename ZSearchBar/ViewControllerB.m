//
//  ViewControllerB.m
//  ZSearchBar
//
//  Created by bigZZZ on 2021/3/18.
//

#import "ViewControllerB.h"

@interface ViewControllerB ()

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = UIColor.lightGrayColor;
    ZSearchBar *searchBar = ZSearchBar.new;
    searchBar.placehoderStr = @"搜索";
    searchBar.textAligment = kTextAlignmentTypeCenter;
    searchBar.beginBlock = ^{
        
    };
    [self.view addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100.f);
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.mas_equalTo(45.f);
    }];
}

@end
