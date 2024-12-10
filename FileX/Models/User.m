//
//  User.m
//  FileX
//
//  Created by eelenskiy on 07.12.2024.
//

#import <Foundation/Foundation.h>
#import "User.h"

@implementation User

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age {
    self = [super init];
    if (self) {
        _name = name;
        _age = age;
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.age forKey:@"age"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    NSString *name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
    NSInteger age = [coder decodeIntegerForKey:@"age"];
    return [self initWithName:name age:age];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"User(name: %@, age: %ld)", self.name, (long)self.age];
}

@end
