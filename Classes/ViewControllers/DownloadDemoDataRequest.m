//
//  DownloadDemoDataRequest.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/16/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "DownloadDemoDataRequest.h"
#import "ITTGobalPaths.h"
#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "CommonUtils.h"
#import "NSDate+ITTAdditions.h"

@implementation DownloadDemoDataRequest

- (NSString*)getRequestUrl
{
//    NSString *dateStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
//	return [NSString stringWithFormat:@"http://cn.wsj.com/ipad/plist/%@.zip",dateStr];
    return @"http://106.120.205.115:1080/sz_metro/zip/up.zip";
}

- (BOOL)useDumpyData
{
    return FALSE;
}

- (BOOL)processDownloadFile
{
    @autoreleasepool {
        BOOL success = YES;
        @try {
            ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:_filePath mode:ZipFileModeUnzip];
            NSArray *infos = [unzipFile listFileInZipInfos];
            [unzipFile goToFirstFileInZip];
            int index = 0;
            NSString *folderPath = ITTPathForCacheResource(@"unzip");
            do{
                ZipReadStream *read= [unzipFile readCurrentFileInZip];
                FileInZipInfo *info = infos[index];
                NSString *path = [folderPath stringByAppendingPathComponent:info.name];
                if (info.size == 0) {
                    //is folder
                    [CommonUtils createDirectorysAtPath:path];
                }else{
                    NSString *directorPath = [CommonUtils getDirectoryPathByFilePath:path];
                    [CommonUtils createDirectorysAtPath:directorPath];
                    NSMutableData *fileData= [NSMutableData data];
                    BOOL isEndofFile = NO;
                    while (!isEndofFile) {
                        NSMutableData *data= [[NSMutableData alloc] initWithLength:256];
                        int bytesRead= [read readDataWithBuffer:data];
                        if (bytesRead <= 0) {
                            isEndofFile = YES;
                        }else{
                            [fileData appendData:data];
                        }
                    }
                    [fileData writeToFile:path atomically:YES];
                    //ITTDINFO(@"write to file [%d]:%@", success,path);
                }
                
                [read finishedReading];
                index ++;
            }while ([unzipFile goToNextFileInZip]);
            [unzipFile close];
            ITTDINFO(@"zip file unzipped...............");
        } @catch (ZipException *ze) {
            ITTDERROR(@"ZipException caught: %d - %@", ze.error, [ze reason]);
            success = NO;
        } @catch (id e) {
            ITTDERROR(@"Exception caught: %@ - %@", [[e class] description], [e description]);
            success = NO;
        }
        return success;
    }
}

@end
