//
//  UIContextMenuInteraction+Private.h
//  Playgrounds
//
//  Created by Kengo Tate on 2026/04/12.
//

#import <UIKit/UIKit.h>

@interface _UIContextMenuPresentation : NSObject

- (BOOL)addDismissalCompletion:(dispatch_block_t _Nonnull)completion;

@end

@interface UIContextMenuInteraction (HumePrivate)

@property (readonly, nonatomic) BOOL _hasVisibleMenu;
@property (readonly, nonatomic, nullable) _UIContextMenuPresentation *outgoingPresentation;
- (void)dismissMenu;

@end
