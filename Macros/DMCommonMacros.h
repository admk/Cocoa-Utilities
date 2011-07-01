//
//  DMCommonMacros.h
//  Common Macros
//
//  Function IsEmpty() for checking if a Cocoa Object is empty

static inline BOOL IsEmpty(id thing) {
    return 
		thing == nil
	||	([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) 
	|| 	([thing respondsToSelector:@selector(count) ] && [(NSArray *)thing count] == 0);
}
