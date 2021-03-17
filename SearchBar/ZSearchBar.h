//
//  MSearchBar.h
//  ModooOrderMerchant
//
//  Created by bigZZZ on 2021/3/14.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kTextAlignmentType) {
    kTextAlignmentTypeLeft = 0,
    kTextAlignmentTypeCenter,
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^searchBlock) (NSString *searchedKey);
typedef void (^beginBlock) (void);

@interface ZSearchBar : UIView

@property (nonatomic, strong) UITextField *inputTf;
@property (nonatomic, assign) kTextAlignmentType textAligment;
@property (nonatomic, copy) NSString *placehoderStr;
@property (nonatomic, copy) beginBlock beginBlock;
@property (nonatomic, copy) searchBlock searchBlock;

@end

NS_ASSUME_NONNULL_END
