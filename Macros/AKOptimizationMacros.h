/********************
* boilerplate stuff *
*********************/

#define $_TOKENPASTE(x,y) x##y
#define $$TOKENPASTE(x,y) $_TOKENPASTE(x, y)

#define $_ITR $$TOKENPASTE($itr,__LINE__)
#define $_DATE $$TOKENPASTE($date,__LINE__)

inline static BOOL $_release(id obj)
{
	[obj release];
	return YES;
}


/**********************
* optimization macros *
**********************/

#define AKPollingIterationOptimize(iteration) \
    static int $_ITR = 0; \
    if ($_ITR++ > iteration) \
        if (!($_ITR = 0))

#define AKPollingIntervalOptimize(interval) \
	static NSDate *$_DATE = [[NSDate date] retain]; \
	if ([$_DATE timeIntervalSinceNow] < -interval) \
		if ($_release($_DATE) && \
			($_DATE = [[NSDate date] retain]))
