//
//  FileTypeHelper.h
//  FileX
//
//  Created by eelenskiy on 07.12.2024.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FileType) {
    FileTypeTXT,
    FileTypeJSON,
    FileTypeXML,
    FileTypeZIP,
    FileTypeUnknown = NSNotFound
};

@interface FileTypeHelper : NSObject

+ (NSString *)fileExtensionForType:(FileType)fileType;
+ (FileType)fileTypeFromExtension:(NSString *)extension;

@end
