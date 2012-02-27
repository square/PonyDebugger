#import <PonyDebugger/PDObject.h>
#import <PonyDebugger/PDDebugger.h>
#import <PonyDebugger/PDDynamicDebuggerDomain.h>


// Information about the Frame on the page.
@interface PDPageFrame : PDObject

// Frame unique identifier.
// Type: string
@property (nonatomic, retain) NSString *identifier;

// Parent frame identifier.
// Type: string
@property (nonatomic, retain) NSString *parentId;

// Identifier of the loader associated with this frame.
@property (nonatomic, retain) NSString *loaderId;

// Frame's name as specified in the tag.
// Type: string
@property (nonatomic, retain) NSString *name;

// Frame document's URL.
// Type: string
@property (nonatomic, retain) NSString *url;

// Frame document's security origin.
// Type: string
@property (nonatomic, retain) NSString *securityOrigin;

// Frame document's mimeType as determined by the browser.
// Type: string
@property (nonatomic, retain) NSString *mimeType;

@end


// Information about the Frame hierarchy along with their cached resources.
@interface PDPageFrameResourceTree : PDObject

// Frame information for this tree item.
@property (nonatomic, retain) PDPageFrame *frame;

// Child frames.
// Type: array
@property (nonatomic, retain) NSArray *childFrames;

// Information about frame resources.
// Type: array
@property (nonatomic, retain) NSArray *resources;

@end


// Search match for resource.
@interface PDPageSearchMatch : PDObject

// Line number in resource content.
// Type: number
@property (nonatomic, retain) NSNumber *lineNumber;

// Line with match content.
// Type: string
@property (nonatomic, retain) NSString *lineContent;

@end


// Search result for resource.
@interface PDPageSearchResult : PDObject

// Resource URL.
// Type: string
@property (nonatomic, retain) NSString *url;

// Resource frame id.
@property (nonatomic, retain) NSString *frameId;

// Number of matches in the resource content.
// Type: number
@property (nonatomic, retain) NSNumber *matchesCount;

@end


// Cookie object
@interface PDPageCookie : PDObject

// Cookie name.
// Type: string
@property (nonatomic, retain) NSString *name;

// Cookie value.
// Type: string
@property (nonatomic, retain) NSString *value;

// Cookie domain.
// Type: string
@property (nonatomic, retain) NSString *domain;

// Cookie path.
// Type: string
@property (nonatomic, retain) NSString *path;

// Cookie expires.
// Type: integer
@property (nonatomic, retain) NSNumber *expires;

// Cookie size.
// Type: integer
@property (nonatomic, retain) NSNumber *size;

// True if cookie is http-only.
// Type: boolean
@property (nonatomic, retain) NSNumber *httpOnly;

// True if cookie is secure.
// Type: boolean
@property (nonatomic, retain) NSNumber *secure;

// True in case of session cookie.
// Type: boolean
@property (nonatomic, retain) NSNumber *session;

@end


