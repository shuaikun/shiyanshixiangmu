//
//  SHKTencentForm.h
//  AsiaScene
//
//  Created by Rainbow on 5/4/11.
//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITTShareFormViewControllerDelegate;

@interface ITTShareFormViewController : UIViewController <UITextViewDelegate> {
    NSString *_initText;
    UIImage *_initImage;
    NSString *_shareName;
}

@property (nonatomic, assign) id<ITTShareFormViewControllerDelegate> delegate;     
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *counter;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

- (id)initShareName:(NSString*)shareName text:(NSString*)text image:(UIImage*)image;

@end
@protocol ITTShareFormViewControllerDelegate <NSObject>
- (void)onFormSendBtnClicked:(ITTShareFormViewController*)formVC;
@end