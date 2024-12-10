//
//  ZipFileManager.h
//  FileX
//
//  Created by eelenskiy on 08.12.2024.
//

#import "IFileManager.h"
#import <Foundation/Foundation.h>

@interface ZipFileManager : NSObject <IFileManager>

- (void)unzipFileWithName:(NSString *)fileName;

@end

