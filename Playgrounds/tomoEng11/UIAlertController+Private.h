//
//  UIAlertController+Private.h
//  Playgrounds
//
//  Created by 井本　智博 on 2026/04/12.
//
//  UIAlertControllerのプライベートAPIを公開するヘッダー
//  ※ App Store申請には使用しないこと（リジェクトの可能性あり）
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// プライベートクラスの前方宣言
@class _UIAlertControllerTextFieldViewController;

@interface UIAlertController ()

// プライベートプロパティ
@property (nonatomic, readonly, nullable) _UIAlertControllerTextFieldViewController *_textFieldViewController;
@property (nonatomic, strong, nullable) NSAttributedString *_attributedTitle;
@property (nonatomic, strong, nullable) NSAttributedString *_attributedMessage;
@property (nonatomic, strong, nullable) NSAttributedString *_attributedDetailMessage;

// カスタムコンテンツビューコントローラ（画像等を表示する用）
@property (nonatomic, strong, nullable) UIViewController *contentViewController;

@end

@interface UIAlertAction ()

// アクションボタンのタイトル色を変更
@property (nonatomic, strong, nullable) UIColor *_titleTextColor;

@end

NS_ASSUME_NONNULL_END
