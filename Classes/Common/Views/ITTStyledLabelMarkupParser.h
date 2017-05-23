#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#define ITTStyledLabel_Default_CharSpace 0.5
#define ITTStyledLabel_Default_LineSpace 2.0
#define ITTStyledLabel_Default_ParagraphSpace 5.0 

@interface ITTStyledLabelMarkupParser : NSObject{
    NSString *_href;
    NSString *_currentFontName;         //当前部分的字体名称
    UIColor *_currentTextColor;         //当前的字体颜色
    int _hasLink;
}

//默认字体名称
@property (strong, nonatomic) NSString* fontName;
//字号大小
@property (assign, readwrite) float fontSize;
//默认字体颜色
@property (strong, nonatomic) UIColor* color;
//字符间距
@property (assign, readonly) float charSpace;
//对齐方式
@property (assign, nonatomic) CTTextAlignment alignment;
//行间距
@property (assign, readonly) float lineSpace;
//段间距
@property (assign, readonly) float paragraphSpace;
//图片信息
@property (strong, nonatomic) NSMutableArray* images;
//解析结果
@property (strong, nonatomic) NSMutableAttributedString* attributedString;

- (id)initWithFont:(UIFont*)font 
             color:(UIColor*)color;
- (void)setFont:(UIFont*)font color:(UIColor*)color;
- (void)setMarkupText:(NSString*)markup;
@end