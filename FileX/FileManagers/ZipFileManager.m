//
//  ZipFileManager.m
//  FileX
//
//  Created by eelenskiy on 08.12.2024.
//

#import <ZipArchive.h>
#import <Foundation/Foundation.h>
#import "ZipFileManager.h"

@implementation ZipFileManager

- (void)createFileWithName:(NSString *)fileName {
    NSURL *zipFileURL = [self getFileURLWithFileName:fileName];
    NSLog(@"Введите название файла для архивации:");
    
    char buffer[1024];
    fgets(buffer, sizeof(buffer), stdin);
    NSString *content = [[NSString alloc] initWithUTF8String:buffer];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if ([self fileExistsWithName:content]) {
        NSURL *fileToZipURL = [self getFileURLWithFileName:content];
        
        NSError *error = nil;

        if ([SSZipArchive createZipFileAtPath:fileToZipURL.path withContentsOfDirectory:zipFileURL.path]) {
            NSLog(@"Файл %@ успешно добавлен в ZIP архив %@", content, fileName);
        } else {
            NSLog(@"Ошибка при создании ZIP архива: %@", error.localizedDescription);
        }
    } else {
        NSLog(@"Ошибка: файла %@ не существует", content);
    }
}

- (nullable NSString *)readFileNamed:(NSString *)fileName {
    NSLog(@"Чтение содержимого ZIP файла не поддерживается в текстовом формате.");
    return nil;
}

- (void)deleteFileNamed:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithFileName:fileName];
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error]) {
        NSLog(@"ZIP файл %@ успешно удален.", fileName);
    } else {
        NSLog(@"Ошибка при удалении ZIP файла: %@", error.localizedDescription);
    }
}

- (void)unzipFileWithName:(NSString *)fileName {
    NSURL *zipFileURL = [self getFileURLWithFileName:fileName];
    NSURL *destinationURL = [self getFileURLWithFileName:[fileName stringByAppendingString:@"-unzipped"]];

    NSError *error = nil;
    if ([SSZipArchive unzipFileAtPath:zipFileURL.path toDestination:destinationURL.path]) {
        NSLog(@"Архив %@ успешно разархивирован.", fileName);
        
        NSArray<NSString *> *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:destinationURL.path error:&error];
        if (contents) {
            for (NSString *file in contents) {
                NSLog(@"Разархивированный файл: %@", file);
            }
        } else {
            NSLog(@"Ошибка при получении содержимого каталога: %@", error.localizedDescription);
        }
    } else {
        NSLog(@"Ошибка при разархивировании: %@", error.localizedDescription);
    }
}

// Helper method to check if a file exists
- (BOOL)fileExistsWithName:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithFileName:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:fileURL.path];
}

// Helper method to get file URL
- (NSURL *)getFileURLWithFileName:(NSString *)fileName {
    NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    return [documentsDirectory URLByAppendingPathComponent:fileName];
}

@end
