//
//  KeyboardTextView.m
//  iTotemFramework
//
//  Created by Grant on 14-4-28.
//  Copyright (c) 2014年 iTotemStudio. All rights reserved.
//

#import "KeyboardTextView.h"

@interface KeyboardTextView ()
<UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) UITextView *fackTextView;
@property (nonatomic, copy) void(^sendBlock)(KeyboardTextView *keyboardTextView, NSString *text);

@end


@implementation KeyboardTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (KeyboardTextView*)instanceFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"KeyboardTextView"];
}

- (void)awakeFromNib
{
    self.fackTextView = [[UITextView alloc] init];
    [_textView.layer setCornerRadius:6];
    [_textView.layer setMasksToBounds:YES];
    _textView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    CGSize size = textView.contentSize;
    size.height -= 2;
    if ( size.height >= 68 ) {
        
        size.height = 68;
    }
    else if ( size.height <= 32 ) {
        
        size.height = 32;
    }
    
    if ( size.height != textView.frame.size.height ) {
        
        CGFloat span = size.height - textView.frame.size.height;
        
        CGRect frame = self.frame;
        frame.size.height += span;
        self.frame = frame;
        
        CGFloat centerY = frame.size.height / 2;
        
        frame = textView.frame;
        frame.size = size;
        textView.frame = frame;
        
        CGPoint center = textView.center;
        center.y = centerY;
        textView.center = center;
        
        center = _sendButton.center;
        center.y = centerY;
        _sendButton.center = center;
    }
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:_fackTextView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [_fackTextView becomeFirstResponder];
    _textView.inputAccessoryView = self;
    [_textView becomeFirstResponder];
}

- (void)hide
{
    [_fackTextView resignFirstResponder];
    [_textView resignFirstResponder];
}

- (void)clear
{
    _textView.text = @"";
}
- (IBAction)sendBtnDidClicked:(id)sender {
    self.sendBlock(self,_textView.text);
}

- (void)sendBtnDidClickedBlock:(void (^)(KeyboardTextView *keyboardTextView, NSString *text))block
{
    self.sendBlock = block;
}

- (void)destroy
{

    [self removeFromSuperview];
    [_fackTextView removeFromSuperview];
    _textView.inputAccessoryView = nil;
}
@end
