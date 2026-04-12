//
//  AlertCustomizer.h
//  Playgrounds
//
//  Created by 井本　智博 on 2026/04/12.
//
//  UIAlertControllerをカスタマイズするヘルパークラス
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertCustomizer : NSObject

/// タイトルをAttributedStringで設定（色、フォント等をカスタマイズ可能）
+ (void)setAttributedTitle:(NSAttributedString *)attributedTitle
          forAlertController:(UIAlertController *)alertController;

/// メッセージをAttributedStringで設定
+ (void)setAttributedMessage:(NSAttributedString *)attributedMessage
            forAlertController:(UIAlertController *)alertController;

/// アクションボタンのタイトル色を変更
+ (void)setTitleColor:(UIColor *)color
            forAction:(UIAlertAction *)action;

/// アラート表示後にラベルの色を直接変更（ビュー階層から検索）
+ (void)customizeTitleLabel:(void (^)(UILabel *titleLabel))customization
           forAlertController:(UIAlertController *)alertController;

+ (void)customizeMessageLabel:(void (^)(UILabel *messageLabel))customization
             forAlertController:(UIAlertController *)alertController;

/// 画像を表示するコンテンツビューコントローラを設定
+ (void)setContentImage:(UIImage *)image
                   size:(CGSize)size
       forAlertController:(UIAlertController *)alertController;

/// カスタムビューコントローラを設定
+ (void)setContentViewController:(UIViewController *)viewController
                forAlertController:(UIAlertController *)alertController;

@end

NS_ASSUME_NONNULL_END
