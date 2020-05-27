//
/*
 * Copyright (c) 2020 Elastos Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */


#import "ELACouncilAndSecretariatModel.h"

@implementation ELACouncilAndSecretariatModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:keyValues];
    NSDictionary *data = [keyValues objectForKey:@"data"];
    [dic removeObjectForKey:@"data"];
    [dic addEntriesFromDictionary:data];
    return [self mj_objectWithKeyValues:dic context:nil];
    
}
+ (NSDictionary *)objectClassInArray
{
    return @{
        @"council":[ELACouncilModel class],
        @"secretariat":[ELASecretariatModel class],
    };
    
}

@end

@implementation ELACouncilModel

@end

@implementation ELASecretariatModel

@end
