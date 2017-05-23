//
//  PoppingBaseView.h  
//
//  Created by Yan Guanyu on 5/29/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"

@protocol ITTAlertViewDelegate;

@interface ITTAlertView : ITTXibView

@property (weak, nonatomic) id<ITTAlertViewDelegate>delegate;

@property (copy, nonatomic) void (^onCancelBlock)(void);
@property (copy, nonatomic) void (^onConfirmBlock)(void);

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
                inView:(UIView *)view
          withDelegate:(id<ITTAlertViewDelegate>)delegate;

+ (void)alertWithMessage:(NSString *)message
                  inView:(UIView *)view
            withDelegate:(id<ITTAlertViewDelegate>)delegate;

+ (void)alertWithMessage:(NSString *)message
                  inView:(UIView *)view
                onCancel:(void (^)(void))onCancelBlock
               onConfirm:(void (^)(void))onConfirmBlock;

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
                inView:(UIView *)view
              onCancel:(void (^)(void))onCancelBlock
             onConfirm:(void (^)(void))onConfirmBlock;

- (void)showInView:(UIView *)supView
      withDelegate:(id<ITTAlertViewDelegate>)delegate;

- (void)showInView:(UIView *)supView
           message:(NSString*)message
      withDelegate:(id<ITTAlertViewDelegate>)delegate;

- (void)showInView:(UIView *)supView
          onCancel:(void (^)(void))onCancelBlock
         onConfirm:(void (^)(void))onConfirmBlock;

- (IBAction)onCancelBtnClicked:(id)sender;
- (IBAction)onConfirmBtnClicked:(id)sender;

@end

@protocol ITTAlertViewDelegate <NSObject>
- (void)confirmBtnClicked:(ITTAlertView *)alertView;
@end