//
//  ChineseToPinyin.h
//  LianPu
//
//  Created by shawnlee on 10-12-16.
//  Edited  by guohua on 11-10-25
//  Copyright 2010 lianpu. All rights reserved.
//

#import <UIKit/UIKit.h>

char pinyinFirstLetter(unsigned short hanzi);
BOOL isCapitalLetter(char letter);
BOOL isLowercaseLetter(char letter);
BOOL isLetter(char letter);
void capitalLetter(char *letter);
NSString* FindLetter(int nCode);

@interface ChineseToPinyin : NSObject {

}

+ (NSString *) pinyinFromChineseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 
@end
