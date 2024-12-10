//
//  JSONFileManager.m
//  FileX
//
//  Created by eelenskiy on 07.12.2024.
//

#import <Foundation/Foundation.h>
#import "JSONFileManager.h"
#import "User.h"

@implementation JSONFileManager

- (NSURL *)getFileURLWithName:(NSString *)fileName {
    NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    return [documentsDirectory URLByAppendingPathComponent:fileName];
}

- (void)createFileWithName:(NSString *)fileName {
    NSLog(@"Введите имя пользователя:");
    char nameBuffer[256];
    fgets(nameBuffer, 256, stdin);
    NSString *name = [[NSString stringWithUTF8String:nameBuffer] stringByTrimmingCharactersInSet:([NSCharacterSet newlineCharacterSet])];
    if (name.length == 0) {
        NSLog(@"Имя не может быть пустым.");
        return;
    }

    NSLog(@"Введите возраст пользователя:");
    char ageBuffer[256];
    fgets(ageBuffer, 256, stdin);
    NSString *ageString = [[NSString stringWithUTF8String:ageBuffer] stringByTrimmingCharactersInSet:([NSCharacterSet newlineCharacterSet])];
    NSInteger age = [ageString integerValue];

    if (age == 0 && ![ageString isEqualToString:@"0"]) {
        NSLog(@"Возраст должен быть числом.");
        return;
    }

    User *user = [[User alloc] initWithName:name age:age];

    @try {
        NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:nil];
        NSURL *fileURL = [self getFileURLWithName:fileName];
        [jsonData writeToURL:fileURL atomically:YES];
        NSLog(@"JSON файл %@ успешно создан.", fileName);
    } @catch (NSException *exception) {
        NSLog(@"Ошибка при создании JSON файла: %@", exception.reason);
    }
}

- (nullable NSString *)readFileNamed:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithName:fileName];
    @try {
        NSData *jsonData = [NSData dataWithContentsOfURL:fileURL];
        User *user = [NSKeyedUnarchiver unarchivedObjectOfClass:[User class] fromData:jsonData error:nil];
        return user.description;
    } @catch (NSException *exception) {
        NSLog(@"Ошибка при чтении JSON файла: %@", exception.reason);
        return nil;
    }
}

- (void)deleteFileNamed:(NSString *)fileName {
    NSURL *fileURL = [self getFileURLWithName:fileName];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    if (error) {
        NSLog(@"Ошибка при удалении JSON файла: %@", error.localizedDescription);
    } else {
        NSLog(@"JSON файл %@ успешно удален.", fileName);
    }
}

@end
