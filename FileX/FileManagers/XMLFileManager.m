//
//  XMLFileManager.m
//  FileX
//
//  Created by eelenskiy on 10.12.2024.
//

#import "XMLFileManager.h"

@implementation XMLFileManager

// MARK: - Public Methods

- (void)createFileWithName:(NSString *)fileName {
    NSLog(@"Введите имя пользователя:");
    char nameBuffer[256];
    fgets(nameBuffer, sizeof(nameBuffer), stdin);
//    NSString *name = [NSString stringWithUTF8String:nameBuffer].stringByTrimmingCharactersInSet([NSCharacterSet newlineCharacterSet]);
    NSString *name = [[NSString stringWithUTF8String:nameBuffer] stringByTrimmingCharactersInSet:([NSCharacterSet newlineCharacterSet])];

    if (name.length == 0) {
        NSLog(@"Имя не может быть пустым.");
        return;
    }
    
    NSLog(@"Введите возраст пользователя:");
    char ageBuffer[256];
    fgets(ageBuffer, sizeof(ageBuffer), stdin);
    NSString *ageString = [[NSString stringWithUTF8String:ageBuffer] stringByTrimmingCharactersInSet:([NSCharacterSet newlineCharacterSet])];
    NSInteger age = ageString.integerValue;
    
    if (age <= 0) {
        NSLog(@"Возраст должен быть числом.");
        return;
    }
    
    NSString *safeName = [self encodeXML:name];
    NSString *safeAge = [self encodeXML:[NSString stringWithFormat:@"%ld", (long)age]];
    
    NSString *xmlString = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                           "<user>\n"
                           "    <name>%@</name>\n"
                           "    <age>%@</age>\n"
                           "</user>", safeName, safeAge];
    
    NSURL *fileURL = [self getFileURL:fileName];
    NSError *error;
    BOOL success = [xmlString writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (success) {
        NSLog(@"XML файл %@ успешно создан.", fileName);
    } else {
        NSLog(@"Ошибка при создании XML файла: %@", error.localizedDescription);
    }
}

- (NSString *)readFileNamed:(NSString *)fileName {
    NSURL *fileURL = [self getFileURL:fileName];
    NSError *error;
    NSString *xmlData = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    
    if (xmlData) {
        return [self decodeXML:xmlData];
    } else {
        NSLog(@"Ошибка при чтении XML файла: %@", error.localizedDescription);
        return nil;
    }
}

- (void)deleteFileNamed:(NSString *)fileName {
    NSURL *fileURL = [self getFileURL:fileName];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    
    if (success) {
        NSLog(@"XML файл %@ успешно удален.", fileName);
    } else {
        NSLog(@"Ошибка при удалении XML файла: %@", error.localizedDescription);
    }
}

// MARK: - Private Methods

- (NSString *)encodeXML:(NSString *)text {
    return [[[[[text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]
             stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
            stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
           stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
          stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
}

- (NSString *)decodeXML:(NSString *)text {
    return [[[[[text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]
             stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]
            stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
           stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""]
          stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
}

- (NSURL *)getFileURL:(NSString *)fileName {
    NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    return [documentsDirectory URLByAppendingPathComponent:fileName];
}

@end
