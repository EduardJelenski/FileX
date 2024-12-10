//
//  User.h
//  FileX
//
//  Created by eelenskiy on 07.12.2024.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSSecureCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age;
+ (BOOL)supportsSecureCoding;

@end
