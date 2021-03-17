//
//  MSearchBar.m
//  ZSearchBar
//
//  Created by bigZZZ on 2021/3/14.
//

#import "ZSearchBar.h"
#import <Masonry/Masonry.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kPFRegularFontName @"PingFangSC-Regular"
#define kPFSemiboldFontName @"PingFangSC-Semibold"
#define kPFMediumFontName @"PingFangSC-Medium"
#define kDINBoldFontName @"DIN Alternate Bold"

static CGFloat const kTextFiledBgVDefaultWidth = 35.f;

@interface ZSearchBar () <UITextFieldDelegate>
{
    kTextAlignmentType origintTextAligment;
}

@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UIView *textFiledBgV;
@property (nonatomic, assign) BOOL didResetFrame;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) CGFloat cancelBtnWidth;

@end

@implementation ZSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        origintTextAligment = NSNotFound;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont fontWithName:kPFRegularFontName size:14.f];
    [_cancelBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    CGFloat width = [_cancelBtn.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)].width;
    [self addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.height.equalTo(self);
        make.width.mas_equalTo(0.f);
    }];
    _cancelBtnWidth = width + 10.f;
    
    _bgV = UIView.new;
    _bgV.backgroundColor = [UIColor whiteColor];
    _bgV.layer.cornerRadius = 5.f;
    [self addSubview:_bgV];
    [_bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.right.equalTo(self.cancelBtn.mas_left);
    }];

    _textFiledBgV = UIView.new;
    [self.bgV addSubview:_textFiledBgV];
    [_textFiledBgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.height.equalTo(self.bgV);
        make.width.mas_equalTo(0.f);
    }];
    
    UIImageView *searchImgV = UIImageView.new;
    searchImgV.image = [UIImage imageNamed:@"icon_search"];
    [_textFiledBgV addSubview:searchImgV];
    [searchImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textFiledBgV).offset(5.f);
        make.centerY.equalTo(self.textFiledBgV);
        make.size.mas_equalTo(CGSizeMake(25.f, 20.f));
    }];
    
    _inputTf = UITextField.new;
    _inputTf.delegate = self;
    _inputTf.textColor = [UIColor darkGrayColor];
    _inputTf.font = [UIFont fontWithName:kPFRegularFontName size:14.f];
    [_textFiledBgV addSubview:_inputTf];
    [_inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchImgV.mas_right);
        make.centerY.right.equalTo(self.textFiledBgV);
        make.height.mas_equalTo(20.f);
    }];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn addTarget:self action:@selector(beginSearch) forControlEvents:UIControlEventTouchUpInside];
    _searchBtn.hidden = YES;
    [self.bgV addSubview:_searchBtn];
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.equalTo(self.self.bgV);
        make.centerY.equalTo(self.bgV);
        make.width.equalTo(self.bgV.mas_height);
    }];
    searchImgV = UIImageView.new;
    searchImgV.image = [UIImage imageNamed:@"icon_search"];
    [_searchBtn addSubview:searchImgV];
    [searchImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.searchBtn);
        make.size.mas_equalTo(CGSizeMake(25.f, 20.f));
    }];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn addTarget:self action:@selector(beginEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.bgV addSubview:_editBtn];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - private methods
- (void)beginEdit {
    _editBtn.hidden = YES;
    _didResetFrame = YES;
    self.textAligment = kTextAlignmentTypeLeft;
    _searchBtn.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTf becomeFirstResponder];
    });
    [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.cancelBtnWidth);
    }];
}

- (void)cancelEdit {
    if (origintTextAligment == kTextAlignmentTypeCenter) {
        _didResetFrame = YES;
        self.textAligment = kTextAlignmentTypeCenter;
    }
    _editBtn.hidden = NO;
    _searchBtn.hidden = YES;
    _inputTf.text = @"";
    [_inputTf resignFirstResponder];
    [self.cancelBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
}

- (void)beginSearch {
    if (_inputTf.text.length == 0) {
        NSLog(@"=== 请输入关键字 ==");
        return;
    }
    [self.inputTf resignFirstResponder];
    if (self.searchBlock) {
        self.searchBlock(self.inputTf.text);
    }
}

- (void)resetFrame {
    _didResetFrame = !_didResetFrame;
    if (!_didResetFrame) {
        if (_textAligment == kTextAlignmentTypeCenter) {
            CGFloat width = [_inputTf sizeThatFits:CGSizeMake(SCREEN_WIDTH, 20.f)].width;
            [self.textFiledBgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.height.equalTo(self.bgV);
                make.width.mas_equalTo(width + kTextFiledBgVDefaultWidth);
            }];
        } else {
            [UIView animateWithDuration:0.1f
                             animations:^{
                [self.textFiledBgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.height.equalTo(self.bgV);
                    make.width.equalTo(self.bgV).offset(-6.f);
                }];
            }];
        }
    }
}

#pragma mark - setter
- (void)setTextAligment:(kTextAlignmentType)textAligment {
    _textAligment = textAligment;
    if (origintTextAligment == NSNotFound) {
        origintTextAligment = textAligment;
    }
    if (textAligment == kTextAlignmentTypeLeft) {
        self.editBtn.hidden = YES;
    }
    [self resetFrame];
}
- (void)setPlacehoderStr:(NSString *)placehoderStr {
    _placehoderStr = placehoderStr;
    _inputTf.placeholder = placehoderStr;
    [self resetFrame];
}

@end
