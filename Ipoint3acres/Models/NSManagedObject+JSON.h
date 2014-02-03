//
//  NSManagedObject+JSON.h
//  BookReader
//
//  Created by 苑　海勝 on 2013/12/03.
//  Copyright (c) 2013年 苑　海勝. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSManagedObject (safeSetValuesKeysWithDictionary)
- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
@end
