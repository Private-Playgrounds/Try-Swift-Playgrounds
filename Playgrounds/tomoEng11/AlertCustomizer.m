//
//  AlertCustomizer.m
//  Playgrounds
//
//  Created by 井本　智博 on 2026/04/12.
//

#import "AlertCustomizer.h"
#import "UIAlertController+Private.h"

@implementation AlertCustomizer

+ (void)setAttributedTitle:(NSAttributedString *)attributedTitle
          forAlertController:(UIAlertController *)alertController {
    [alertController setValue:attributedTitle forKey:@"_attributedTitle"];
}

+ (void)setAttributedMessage:(NSAttributedString *)attributedMessage
            forAlertController:(UIAlertController *)alertController {
    [alertController setValue:attributedMessage forKey:@"_attributedMessage"];
}

+ (void)setTitleColor:(UIColor *)color
            forAction:(UIAlertAction *)action {
    [action setValue:color forKey:@"_titleTextColor"];
}

+ (void)customizeTitleLabel:(void (^)(UILabel *titleLabel))customization
           forAlertController:(UIAlertController *)alertController {
    [self findLabelWithText:alertController.title
                     inView:alertController.view
                 completion:customization];
}

+ (void)customizeMessageLabel:(void (^)(UILabel *messageLabel))customization
             forAlertController:(UIAlertController *)alertController {
    [self findLabelWithText:alertController.message
                     inView:alertController.view
                 completion:customization];
}

+ (void)setContentImage:(UIImage *)image
                   size:(CGSize)size
       forAlertController:(UIAlertController *)alertController {
    UIViewController *imageVC = [self makeImageViewControllerWithImage:image size:size];
    [self setContentViewController:imageVC forAlertController:alertController];
}

+ (void)setContentViewController:(UIViewController *)viewController
                forAlertController:(UIAlertController *)alertController {
    [alertController setValue:viewController forKey:@"contentViewController"];
}

#pragma mark - Private

+ (UIViewController *)makeImageViewControllerWithImage:(UIImage *)image size:(CGSize)size {
    UIViewController *imageVC = [[UIViewController alloc] init];
    imageVC.view.backgroundColor = [UIColor clearColor];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    [imageVC.view addSubview:imageView];
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerXAnchor constraintEqualToAnchor:imageVC.view.centerXAnchor],
        [imageView.centerYAnchor constraintEqualToAnchor:imageVC.view.centerYAnchor],
        [imageView.widthAnchor constraintEqualToConstant:size.width],
        [imageView.heightAnchor constraintEqualToConstant:size.height],
    ]];

    imageVC.preferredContentSize = size;
    return imageVC;
}

+ (void)findLabelWithText:(NSString *)text
                   inView:(UIView *)view
               completion:(void (^)(UILabel *label))completion {
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        if ([label.text isEqualToString:text]) {
            if (completion) {
                completion(label);
            }
            return;
        }
    }

    for (UIView *subview in view.subviews) {
        [self findLabelWithText:text inView:subview completion:completion];
    }
}

@end
