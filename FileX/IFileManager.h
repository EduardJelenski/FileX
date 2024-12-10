//
//  IFileManager.h
//  FileX
//
//  Created by eelenskiy on 08.12.2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IFileManager <NSObject>

@required
- (void) createFileWithName:(NSString*)name;
- (nullable NSString*) readFileNamed:(NSString*)name;
- (void) deleteFileNamed:(NSString*)name;

- (NSURL *)getFileURLWithFileName:(NSString *)fileName;
- (void)getFileSizeWithName:(NSString *)fileName;
- (BOOL)fileExistsWithName:(NSString *)fileName;
- (NSString *)formatFileSize:(unsigned long long)size;

@end

@implementation NSObject (IFileManager)

- (NSURL *)getFileURLWithFileName:(NSString *)fileName {
    NSString *directoryPath = @"/Users/nastasya/Developer/SimpleFileManager/Files";
    NSURL *directoryURL = [NSURL fileURLWithPath:directoryPath];
    return [directoryURL URLByAppendingPathComponent:fileName];
}

- (void)getFileSizeWithName:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithFileName:fileName];

    @try {
        NSDictionary<NSFileAttributeKey, id> *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURL.path error:nil];
        if (attributes) {
            NSNumber *fileSize = attributes[NSFileSize];
            if (fileSize) {
                NSLog(@"Размер файла %@: %@", fileName, [self formatFileSize:fileSize.unsignedLongLongValue]);
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Ошибка при получении размера файла: %@", exception.reason);
    }
}

- (BOOL)fileExistsWithName:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithFileName:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:fileURL.path];
}

#pragma mark - Private Methods

- (NSString *)formatFileSize:(uint64_t)size {
    NSByteCountFormatter *byteCountFormatter = [[NSByteCountFormatter alloc] init];
    byteCountFormatter.allowedUnits = NSByteCountFormatterUseBytes | NSByteCountFormatterUseKB | NSByteCountFormatterUseMB | NSByteCountFormatterUseGB;
    byteCountFormatter.countStyle = NSByteCountFormatterCountStyleFile;
    return [byteCountFormatter stringFromByteCount:size];
}

@end

NS_ASSUME_NONNULL_END
