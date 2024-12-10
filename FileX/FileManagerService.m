//
//  FileManagerService.m
//  FileX
//
//  Created by eelenskiy on 10.12.2024.
//

#import <Foundation/Foundation.h>
#import "IFileManager.h"
#import "TextFileManager.h"
#import "JSONFileManager.h"
#import "ZipFileManager.h"
#import "XMLFileManager.h"
#import "FileTypeHelper.h"
#import "FileManagerService.h"

@implementation FileManagerService

- (instancetype)init {
    self = [super init];
    if (self) {
        _fileManagers = [NSMutableDictionary new];
        _fileManagers[@(FileTypeTXT)] = [TextFileManager new];
        _fileManagers[@(FileTypeJSON)] = [JSONFileManager new];
        _fileManagers[@(FileTypeZIP)] = [ZipFileManager new];
        _fileManagers[@(FileTypeXML)] = [XMLFileManager new];
    }
    return self;
}

- (void)createFileOfType:(FileType)type fileName:(NSString *)fileName {
    id<IFileManager> fileManager = self.fileManagers[@(type)];
    [fileManager createFileWithName:fileName];
}

- (void)deleteFileOfType:(FileType)type fileName:(NSString *)fileName {
    id<IFileManager> fileManager = self.fileManagers[@(type)];
    [fileManager deleteFileNamed:fileName];
}

- (NSString *)readFileOfType:(FileType)type fileName:(NSString *)fileName {
    id<IFileManager> fileManager = self.fileManagers[@(type)];
    return [fileManager readFileNamed:fileName] ?: @"";
}

- (void)getFileSizeOfType:(FileType)type fileName:(NSString *)fileName {
    id<IFileManager> fileManager = self.fileManagers[@(type)];
    [fileManager getFileSizeWithName:fileName];
}

- (void)unzipFileWithFileName:(NSString *)fileName {
    ZipFileManager *zipFileManager = (ZipFileManager *)self.fileManagers[@(FileTypeZIP)];
    [zipFileManager unzipFileWithName:fileName];
}

- (void)showLogicalDrives {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSURL *> *drives = [fileManager mountedVolumeURLsIncludingResourceValuesForKeys:nil options:0];

    for (NSURL *drive in drives) {
        NSError *error;
        NSDictionary<NSURLResourceKey, id> *values = [drive resourceValuesForKeys:@[
            NSURLVolumeIdentifierKey,
            NSURLVolumeURLKey,
            NSURLVolumeNameKey,
            NSURLVolumeTotalCapacityKey,
            NSURLVolumeAvailableCapacityKey,
            NSURLVolumeIsRemovableKey,
            NSURLVolumeIsRootFileSystemKey
        ] error:&error];

        if (values) {
            NSLog(@"Имя диска: %@", values[NSURLVolumeNameKey] ?: @"Неизвестно");
            NSLog(@"Метка тома: %@", values[NSURLVolumeIdentifierKey] ?: @"Неизвестно");
            NSLog(@"Общий размер: %@ байт", values[NSURLVolumeTotalCapacityKey] ?: @(0));
            NSLog(@"Доступно свободного места: %@ байт", values[NSURLVolumeAvailableCapacityKey] ?: @(0));
            NSLog(@"Тип диска: %@", [values[NSURLVolumeIsRemovableKey] boolValue] ? @"Съемный" : @"Несъемный");
            NSLog(@"Готов ли диск: %@", [values[NSURLVolumeIsRootFileSystemKey] boolValue] ? @"Да" : @"Нет");
            NSLog(@"---");
        } else {
            NSLog(@"Не удалось получить информацию о диске: %@", drive.absoluteString);
        }
    }
}

- (BOOL)fileExistsOfType:(FileType)type named:(NSString *)fileName {
    id<IFileManager> fileManager = self.fileManagers[@(type)];
    return [fileManager fileExistsWithName:fileName];
}

@end
