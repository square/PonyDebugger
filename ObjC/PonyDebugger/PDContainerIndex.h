//
//  PDContainerIndex.h
//  PonyDebugger
//
//  Created by Wen-Hao Lue on 2013-04-28.
//
//

#import <Foundation/Foundation.h>


#pragma mark - Public Interface

@interface PDContainerIndex : NSObject

- (id)initWithName:(NSString *)name index:(NSInteger)index;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger index;

@end

