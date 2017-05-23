//
//  AFNDownloadDataRequest.m
//  iTotemFramework
//
//  Created by Sword Zhou on 8/7/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "AFNDownloadDataRequest.h"
#import "ITTGobalPaths.h"
#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "CommonUtils.h"
#import "NSDate+ITTAdditions.h"

@implementation AFNDownloadDataRequest

- (NSString*)getRequestUrl
{
    NSString *dateStr = [[NSDate date] stringWithFormat:@"yyyy-MM-dd"];
	return [NSString stringWithFormat:@"http://cn.wsj.com/ipad/plist/%@.zip",dateStr];
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
