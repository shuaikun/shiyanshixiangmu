//
//  SHKTencentForm.m
//  AsiaScene
//
//  Created by Rainbow on 5/4/11.
//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import "ITTShareFormViewController.h"
#import "SHK.h"
#import "SHKTencent.h"
@interface ITTShareFormViewController()
- (void)updateCounter;
@end
@implementation ITTShareFormViewController

#pragma mark - lifecycle methods
- (void)dealloc {
    _delegate = nil;
	[_textView release];
	[_counter release];
    [_imageView release];
    [_initText release];
    [_initImage release];
    [super dealloc];
}

- (id)initShareName:(NSString*)shareName text:(NSString*)text image:(UIImage*)image{
    if ((self = [super initWithNibName:@"ITTShareFormViewController" bundle:nil])) {
        _shareName = [shareName copy];
        if (text) {
            _initText = [text copy];
        }
        if (image) {
            _initImage = [image retain];
        }
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self
                                                                                           action:@selector(cancel)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"发送到%@",_shareName]
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(save)] autorelease];
    _textView.text = _initText;
    _imageView.image = _initImage;
    [self updateCounter];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];	
	
	[self.textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];	
	
	// Remove observers
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name: UIKeyboardWillShowNotification object:nil];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - private methods
- (void)updateCounter{
	
	int count = 140 - _textView.text.length;
	_counter.text = [NSString stringWithFormat:@"%i" , count];
	_counter.textColor = count >= 0 ? [UIColor blackColor] : [UIColor redColor];
}


#pragma mark -UITextViewDelegate methods

- (void)textViewDidBeginEditing:(UITextView *)textView{
	[self updateCounter];
}

- (void)textViewDidChange:(UITextView *)textView{
	[self updateCounter];	
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	[self updateCounter];
}

#pragma mark -

- (void)cancel{	
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}

- (void)save{	
	if (_textView.text.length > 140){
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"内容太长")
									 message:[NSString stringWithFormat:@"%@最长只能发140字",_shareName]
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"关闭")
						   otherButtonTitles:nil] autorelease] show];
		return;
	}else if (_textView.text.length == 0){
		[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"内容为空")
									 message:SHKLocalizedString(@"内容不能为空。")
									delegate:nil
						   cancelButtonTitle:SHKLocalizedString(@"关闭")
						   otherButtonTitles:nil] autorelease] show];
		return;
	}
	
    if (_delegate && [_delegate respondsToSelector:@selector(onFormSendBtnClicked:)]) {
        [_delegate onFormSendBtnClicked:self];
    }
	
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
}
@end
