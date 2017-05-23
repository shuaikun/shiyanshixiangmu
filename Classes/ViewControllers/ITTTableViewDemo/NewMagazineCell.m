//
//  BigBookView.m
//  NationalGeography
//
//  Created by xiaoyu on 12-10-9.
//
//

#import "NewMagazineCell.h"
#import "ITTImageView.h"

@interface NewMagazineCell()<ITTImageViewDelegate>
{
}

@property (strong, nonatomic) IBOutlet ITTImageView *cellImageView;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation NewMagazineCell

+(id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] objectAtIndex:0];
}

- (void)dealloc
{
//    [_cellImageView cancelCurrentImageRequest];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _cellImageView.delegate = self;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    _progressLabel.hidden = TRUE;    
    [_cellImageView cancelCurrentImageRequest]; //it is fatal here, otherwise app will crash
    [_cellImageView loadImage:_url placeHolder:[UIImage imageNamed:@"placeholder.png"]];
}

#pragma mark - ITTImageViewDelegate
- (void)imageViewDidChangeProgress:(ITTImageView *)imageView progress:(CGFloat)progress
{
    ITTDINFO(@"progress %f", progress);    
    _progressLabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
    if (progress >= 1.0) {
        _progressLabel.hidden = TRUE;
    }
    else {
        _progressLabel.hidden = FALSE;
    }
}

@end
