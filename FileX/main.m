//
//  main.m
//  FileX
//
//  Created by eelenskiy on 07.12.2024.
//

#import <Foundation/Foundation.h>
#import "FileTypeHelper.h"
#import "FileManagerService.h"
#import "ZipFileManager.h"

#import "JSONFileManager.h"

void showMenu(void) {
    NSLog(@"\n\
Выберите действие:\n\
1. Показать логические диски - show drivers\n\
2. Создать - create 'filename'\n\
3. Прочитать - read 'filename'\n\
4. Удалить - delete 'filename'\n\
5. Размер файла - size 'filename'\n\
6. Разархивировать - unzip 'filename'\n\
0. Выход\n");
}

FileType fileTypeForFileName(NSString * _Nonnull fileName) {
    NSString *fileExtension = [fileName pathExtension];
    return [FileTypeHelper fileTypeFromExtension:fileExtension];
}


void checkConditionsForCreating(FileManagerService *fileManager, NSString *fileName, void (^completion)(void)) {
    FileType type = fileTypeForFileName(fileName);
    if (type != FileTypeUnknown) {
        if (![fileManager fileExistsOfType:type named:fileName]) {
            completion();
        } else {
            NSLog(@"Ошибка: файл %@ уже существует", fileName);
        }
    } else {
        NSLog(@"Ошибка: Неподдерживаемый формат файла.");
    }
}

void checkConditionsForReadingAndDeleting(FileManagerService *fileManager, NSString *fileName, void (^completion)(void)) {
    FileType type = fileTypeForFileName(fileName);
    if (type != FileTypeUnknown) {
        if ([fileManager fileExistsOfType:type named:fileName]) {
            completion();
        } else {
            NSLog(@"Ошибка: файл %@ не найден", fileName);
        }
    } else {
        NSLog(@"Ошибка: Неподдерживаемый формат файла.");
    }
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        showMenu();
        FileManagerService *fileManager = [[FileManagerService alloc] init];

        while (true) {
            NSLog(@"Введите команду:");
            char input[256];
            fgets(input, 256, stdin);
            NSString *inputString = [[NSString stringWithCString:input encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

            NSArray<NSString *> *components = [inputString componentsSeparatedByString:@" "];
            if (components.count < 2) {
                NSLog(@"Некорректный ввод. Попробуйте снова.");
                continue;
            }

            NSString *command = components[0];
            NSString *fileName = components[1];

            if ([command isEqualToString:@"show"] && [fileName isEqualToString:@"drivers"]) {
                [fileManager showLogicalDrives];
            } else if ([command isEqualToString:@"create"]) {
                checkConditionsForCreating(fileManager, fileName, ^{
                    FileType type = fileTypeForFileName(fileName);
                    [fileManager createFileOfType:type fileName:fileName];
                });
            } else if ([command isEqualToString:@"read"]) {
                checkConditionsForReadingAndDeleting(fileManager, fileName, ^{
                    FileType type = fileTypeForFileName(fileName);
                    NSString *content = [fileManager readFileOfType:type fileName:fileName];
                    if (content) {
                        NSLog(@"Содержимое файла:\n%@", content);
                    } else {
                        NSLog(@"Файл пустой");
                    }
                });
            } else if ([command isEqualToString:@"delete"]) {
                checkConditionsForReadingAndDeleting(fileManager, fileName, ^{
                    FileType type = fileTypeForFileName(fileName);
                    [fileManager deleteFileOfType:type fileName:fileName];
                });
            } else if ([command isEqualToString:@"size"]) {
                checkConditionsForReadingAndDeleting(fileManager, fileName, ^{
                    FileType type = fileTypeForFileName(fileName);
                    [fileManager getFileSizeOfType:type fileName:fileName];
                });
            } else if ([command isEqualToString:@"unzip"]) {
                checkConditionsForReadingAndDeleting(fileManager, fileName, ^{
                    FileType type = fileTypeForFileName(fileName);
                    if (type == FileTypeZIP) {
                        [fileManager unzipFileWithFileName:fileName];
                    } else {
                        NSLog(@"Ошибка: файл %@ не является архивом", fileName);
                    }
                });
            } else if ([command isEqualToString:@"0"]) {
                NSLog(@"Выход из программы.");
                break;
            } else {
                NSLog(@"Некорректный ввод. Пожалуйста, попробуйте снова.");
            }
        }
    }
    return 0;
}

