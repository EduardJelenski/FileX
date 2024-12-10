//
//  FileTypeHelper.m
//  FileX
//
//  Created by eelenskiy on 07.12.2024.
//


#import "FileTypeHelper.h"

@implementation FileTypeHelper

+ (NSString *)fileExtensionForType:(FileType)fileType {
    switch (fileType) {
        case FileTypeTXT:
            return @"txt";
        case FileTypeJSON:
            return @"json";
        case FileTypeXML:
            return @"xml";
        case FileTypeZIP:
            return @"zip";
        default:
            return nil;
    }
}

+ (FileType)fileTypeFromExtension:(NSString *)extension {
    if ([extension isEqualToString:@"txt"]) {
        return FileTypeTXT;
    } else if ([extension isEqualToString:@"json"]) {
        return FileTypeJSON;
    } else if ([extension isEqualToString:@"xml"]) {
        return FileTypeXML;
    } else if ([extension isEqualToString:@"zip"]) {
        return FileTypeZIP;
    } else {
        return FileTypeUnknown; 
    }
}

@end
