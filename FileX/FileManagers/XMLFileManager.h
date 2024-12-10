//
//  XMLFileManager.h
//  FileX
//
//  Created by eelenskiy on 10.12.2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMLFileManager : NSObject

- (void)createFileWithName:(NSString *)fileName;
- (NSString * _Nullable)readFileNamed:(NSString *)fileName;
- (void)deleteFileNamed:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
