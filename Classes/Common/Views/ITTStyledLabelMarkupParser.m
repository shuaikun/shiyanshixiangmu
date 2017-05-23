#import "ITTStyledLabelMarkupParser.h"

/* Callbacks */
static void deallocCallback( void* ref ){
//    [(__bridge id)ref release];
    CFRelease(ref);
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)((__bridge NSDictionary*)ref)[@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)((__bridge NSDictionary*)ref)[@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)((__bridge NSDictionary*)ref)[@"width"] floatValue];
}

@implementation ITTStyledLabelMarkupParser


-(id)init
{
    self = [super init];
    if (self) {
        _fontName =  @"STHeitiSC-Medium" ;
        _color = [UIColor blackColor];
        _fontSize = 17;
        
        _alignment = kCTLeftTextAlignment;
        _lineSpace = ITTStyledLabel_Default_LineSpace;
        _paragraphSpace = ITTStyledLabel_Default_ParagraphSpace;
        _charSpace = ITTStyledLabel_Default_CharSpace;
        _hasLink = 0;
        _href = nil;
    }
    return self;
}

- (id)initWithFont:(UIFont*)font 
             color:(UIColor*)color
{
    self = [self init];
    if (self) {
        [self setFont:font color:color];
    }
    return self;
}

- (void)setFont:(UIFont*)font color:(UIColor*)color
{
    self.fontName = [font fontName];
    _fontSize = font.pointSize;
    self.color = color;
}

-(void)setMarkupText:(NSString*)markup
{
    // init setting
    _currentFontName = _fontName ;
    _currentTextColor = _color ;
    
    _attributedString = [[NSMutableAttributedString alloc] initWithString:@""]; 
    _images = [[NSMutableArray alloc] init];
    //parse data
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:markup 
                                     options:0
                                       range:NSMakeRange(0, [markup length])];
    
    for (NSTextCheckingResult* b in chunks) {
        NSArray* parts = [[markup substringWithRange:b.range] componentsSeparatedByString:@"<"];
        
        //ITTDINFO(@"parts:%@",parts);
        //设置字体
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)_currentFontName, _fontSize, NULL);
        //设置字间距
        CFNumberRef charSpaceRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &_charSpace);
        
        //设置文本对齐方式
        
        CTParagraphStyleSetting alignmentStyle;
        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        alignmentStyle.valueSize = sizeof(_alignment);
        alignmentStyle.value = &_alignment;
        
        //设置文本行间距
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        lineSpaceStyle.valueSize = sizeof(_lineSpace);
        lineSpaceStyle.value = &_lineSpace;
        
        //设置文本段间距
        CTParagraphStyleSetting paragraphSpaceStyle;
        paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
        paragraphSpaceStyle.valueSize = sizeof(_paragraphSpace);
        paragraphSpaceStyle.value = &_paragraphSpace;
        
        //创建设置数组
        CTParagraphStyleSetting settings[] = {alignmentStyle, lineSpaceStyle, paragraphSpaceStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 3);
        
        
        //apply the current text style //2
        NSDictionary* attrs;
        if (_hasLink) {
            attrs = @{(id)kCTForegroundColorAttributeName: (id)_currentTextColor.CGColor,
            (id)kCTFontAttributeName: (__bridge id)fontRef,
            (id)kCTKernAttributeName: (__bridge id)charSpaceRef,
            (id)kCTParagraphStyleAttributeName: (__bridge id)style,
            @"hasLink": (id)@(_hasLink),
            @"href": (id)_href};
        }else{
            attrs = @{(id)kCTForegroundColorAttributeName: (id)_currentTextColor.CGColor,
            (id)kCTFontAttributeName: (__bridge id)fontRef,
            (id)kCTKernAttributeName: (__bridge id)charSpaceRef,
            (id)kCTParagraphStyleAttributeName: (__bridge id)style,
            @"hasLink": (id)@(_hasLink)};
            
        }
        [_attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:parts[0] attributes:attrs]];
        CFRelease(charSpaceRef);
        CFRelease(fontRef);
        CFRelease(style);
        //handle new formatting tag //3
        if ([parts count]>1) {
            NSString* tag = (NSString*)parts[1];
            if ([tag hasPrefix:@"/font>"]) {
                //restore to default style
                _currentTextColor = _color ;
                
                _currentFontName = [_fontName copy];
            }
            if ([tag hasPrefix:@"font"]) {
                //rgb color
                NSRegularExpression* rgbColorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")[^\"]+" options:0 error:NULL];
                [rgbColorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    NSString *rgbColorStr = [tag substringWithRange:match.range];
                    //ITTDINFO(@"color:%@",rgbColorStr);
                    NSArray *colorValues = [rgbColorStr componentsSeparatedByString:@","];
                    //ITTDINFO(@"rgbColors:%@",colorValues);
                    if (colorValues && [colorValues count] == 3) {
                        float redValue = [colorValues[0] floatValue];
                        float greenValue = [colorValues[1] floatValue];
                        float blueValue = [colorValues[2] floatValue];
                        _currentTextColor = [UIColor colorWithRed:redValue/255.0f green:greenValue/255.0f blue:blueValue/255.0f alpha:1];
                    }
                }];
                
                
                //fontName
                NSRegularExpression* fontNameRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=fontName=\")[^\"]+" options:0 error:NULL];
                [fontNameRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    _currentFontName = [[tag substringWithRange:match.range] copy];
                }];
            } //end of font parsing
            
            
            if ([tag hasPrefix:@"/a>"]) {
                _hasLink = 0;
                
                _href = nil;
            }
            if ([tag hasPrefix:@"a"]) {
                _hasLink = 1;
                //href
                NSRegularExpression* fontNameRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=href=\")[^\"]+" options:0 error:NULL];
                [fontNameRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    _href = [[tag substringWithRange:match.range] copy];
                }];
            }
            
            
            if ([tag hasPrefix:@"img"]) {
                
                __block NSNumber* width = @0;
                __block NSNumber* height = @0;
                __block NSString* fileName = @"";
                
                //width
                NSRegularExpression* widthRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+" options:0 error:NULL];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){ 
                    width = @([[tag substringWithRange: match.range] intValue]);
                }];
                
                //height
                NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")[^\"]+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    height = @([[tag substringWithRange:match.range] intValue]);
                }];
                
                //image
                NSRegularExpression* srcRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                }];
                
                //add the image for drawing
                [self.images addObject:
                 @{@"width": width,
                  @"height": height,
                  @"fileName": fileName,
                  @"location": [NSNumber numberWithInt: [_attributedString length]]}
                 ];
                
                //render empty space for drawing the image in the text //1
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                callbacks.dealloc = deallocCallback;
                
                NSDictionary* imgAttr = @{@"width": width,
                                          @"height": height};
                
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr)); //3
                NSDictionary *attrDictionaryDelegate = @{(NSString*)kCTRunDelegateAttributeName: (__bridge id)delegate};
                
                //add a space to the text so that it can call the delegate
                [_attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate] ];
            }
        }
    }
}
@end