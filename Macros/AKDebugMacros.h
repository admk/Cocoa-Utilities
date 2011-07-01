//
//	AKDebugMacros.h
//	Debug Macros
//
//	Created by Adam Ko on 6/12/2010.
//	Copyright 2010 Loca Apps. All rights reserved.
//
//	INSTRUCTIONS
//	Import this file in your prefix header file
//	Add DEBUG=1 in your target's preprocessor macros for debug builds
//	Use DLog in place of NSLog for debugging outputs
//	And ZAssert in place of NSAssert for assertions

#	ifdef DEBUG
#	pragma mark DEBUG
#		define DLog(...)								\
			NSLog(@"%s %@", __PRETTY_FUNCTION__,		\
				[NSString stringWithFormat:__VA_ARGS__]	\
			)											
#		define ALog(...)								\
			[[NSAssertionHandler currentHandler]		\
				handleFailureInFunction:				\
					[NSString							\
						stringWithCString:				\
							__PRETTY_FUNCTION__			\
						encoding:						\
							NSUTF8StringEncoding		\
					]									\
				file:									\
					[NSString							\
						stringWithCString:				\
							__FILE__					\
						encoding:						\
							NSUTF8StringEncoding		\
					]									\
				lineNumber:								\
					__LINE__							\
				description:							\
					__VA_ARGS__							\
			]
#	else
#	pragma mark -
#	pragma mark RELEASE
#		define DLog(...) do {} while (0)
#		ifndef NS_BLOCK_ASSERTIONS
#			define NS_BLOCK_ASSERTIONS
#		endif
#		define ALog(...)								\
			NSLog(@"%s %@", __PRETTY_FUNCTION__,		\
				[NSString stringWithFormat:__VA_ARGS__]	\
			)
#	endif
#	pragma mark -
#	pragma mark ASSERTIONS
#	define ZAssert(condition, ...)						\
			do {										\
				if (!(condition)) {						\
					ALog(__VA_ARGS__);					\
				}										\
			} while(0)
