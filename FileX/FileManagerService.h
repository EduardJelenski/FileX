//
//  FileManagerService.h
//  FileX
//
//  Created by eelenskiy on 10.12.2024.
//

#import <Foundation/Foundation.h>
#import "IFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileManagerService : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<IFileManager>> *fileManagers;

- (instancetype)init;
- (void)createFileOfType:(FileType)type fileName:(NSString *)fileName;
- (void)deleteFileOfType:(FileType)type fileName:(NSString *)fileName;
- (NSString * _Nullable)readFileOfType:(FileType)type fileName:(NSString *)fileName;
- (void)getFileSizeOfType:(FileType)type fileName:(NSString *)fileName;
- (void)unzipFileWithFileName:(NSString *)fileName;
- (void)showLogicalDrives;
- (BOOL)fileExistsOfType:(FileType)type named:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
