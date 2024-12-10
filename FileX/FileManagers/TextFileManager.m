//
//  TextFileManager.m
//  FileX
//
//  Created by eelenskiy on 08.12.2024.
//

#import "TextFileManager.h"

@implementation TextFileManager

- (void)createFileWithName:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithFileName:fileName];
    NSLog(@"Введите содержимое файла:");
    
    char buffer[1024];
    fgets(buffer, sizeof(buffer), stdin);
    NSString *content = [[NSString alloc] initWithUTF8String:buffer];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSError *error = nil;
    if ([content writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"Текстовый файл %@ успешно создан.", fileName);
    } else {
        NSLog(@"Ошибка при создании текстового файла: %@", error.localizedDescription);
    }
}

- (nullable NSString *)readFileNamed:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithFileName:fileName];
    NSError *error = nil;
    NSString *content = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    
    if (content) {
        return content;
    } else {
        NSLog(@"Ошибка при чтении текстового файла: %@", error.localizedDescription);
        return nil;
    }
}

- (void)deleteFileNamed:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithFileName:fileName];
    NSError *error = nil;
    if ([[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error]) {
        NSLog(@"Текстовый файл %@ успешно удален.", fileName);
    } else {
        NSLog(@"Ошибка при удалении текстового файла: %@", error.localizedDescription);
    }
}

- (NSURL *)getFileURLWithFileName:(NSString *)fileName {
    NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    return [documentsDirectory URLByAppendingPathComponent:fileName];
}

@end
