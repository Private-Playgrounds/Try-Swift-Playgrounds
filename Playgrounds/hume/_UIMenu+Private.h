//
//  _UIMenu+Private.h
//  Playgrounds
//
//  Created by Kengo Tate on 2026/04/12.
//

#import <UIKit/UIKit.h>

typedef UIView * _Nonnull (^UIMenuHeaderViewProvider)(void);

@interface UIMenu (HumePrivate)

@property (copy, nonatomic, nullable) UIMenuHeaderViewProvider headerViewProvider;

@end
