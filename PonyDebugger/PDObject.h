//
//  PDObject.h
//  PonyExpress
//
//  Created by Mike Lewis on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PD_JSONObject)

- (id)PD_JSONObjectCopy;
- (id)PD_JSONObject;

@end

extern NSString *const PDDebuggerErrorDomain;
extern const NSInteger PDDebuggerRequiredAttributeMissingCode;

// Subclasses must implement the copying and mutable copying protocols
@interface PDObject : NSObject <NSCopying>

+ (NSDictionary *)keysToEncode;

@property (nonatomic, copy, readonly) NSDictionary *store;

- (BOOL)validate:(NSError **)error;


// KVC - overridden to access generic dictionary storage
- (id)valueForKey:(NSString *)key;    

// KVC - overridden to access generic dictionary storage
- (void)setValue:(id)value forKey:(NSString *)key;

- (id)PD_JSONObject;

@end


NS_INLINE BOOL PDObjectValidateValueNotNil(id value, NSString *localizedDescription, NSError **error) {
    if (!value) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:PDDebuggerErrorDomain code:PDDebuggerRequiredAttributeMissingCode userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:localizedDescription, NSLocalizedDescriptionKey, nil]];
        }
        return NO;
    }
    return YES;
}
