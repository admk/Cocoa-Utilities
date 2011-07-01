//
//	AKDebugMacros.h
//	Debug Macros
//
//	Created by Adam Ko on 6/12/2010.
//	Copyright 2010 Loca Apps. All rights reserved.
//
//	INSTRUCTIONS
//	Import this file in your prefix header file
//
//  Any object declared like this -
//    id obj AKScopeReleased = [[Obj alloc] init];
//  Will get released when obj goes out of scope
//
//  And AKScopeAutoreleased() is handy for loops -
//    for (...) {
//        AKScopeAutoreleased();
//        // your sorcery goes here...
//    }
//  Use this in loops can lower your memory usage

#define $_TOKENPASTE(x,y) x##y
#define $$TOKENPASTE(x,y) $_TOKENPASTE(x, y)


#define AKScopeReleased __attribute__((cleanup(__scopeRelease)))

#define AKScopeAutoreleased()							\
       NSAutoreleasePool *$$TOKENPASTE(__pool_,__LINE__)	\
			AKScopeReleased = [[NSAutoreleasePool alloc] init]

static inline void __scopeRelease(id *objectRef) {
    [*objectRef release], *objectRef = nil;
}
