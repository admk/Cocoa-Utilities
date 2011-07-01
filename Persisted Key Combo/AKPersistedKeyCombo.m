//
//  AKPersistedKeyCombo.m
//  PersistedKeyCombo
//
//  Created by Adam Ko on 23/08/2010.
//  Copyright 2010 Imperial College. All rights reserved.
//

#import "AKPersistedKeyCombo.h"

@interface AKPersistedKeyCombo (Private)

+ (PTKeyCombo *)_ptKeyComboFromKeyCombo:(KeyCombo)keyCombo;
+ (KeyCombo)_keyComboFromPTKeyCombo:(PTKeyCombo *)ptKeyCombo;

@end

@implementation AKPersistedKeyCombo

+ (KeyCombo)keyComboForKey:(NSString *)key
{
	NSDictionary* savedDefaults = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if (!savedDefaults)
	{
		NSLog(@"PersistedKeyCombo: failed to load keyCombo for key %@", key);
		return PKZeroCombo;
	}
	KeyCombo savedKeyCombo;
	savedKeyCombo.code = [[savedDefaults objectForKey:@"keyCode"] shortValue];
	savedKeyCombo.flags = [[savedDefaults objectForKey:@"modifierFlags"] unsignedIntValue];
	return savedKeyCombo;
}

+ (PTKeyCombo *)ptKeyComboForKey:(NSString *)key
{
	KeyCombo keyCombo = [AKPersistedKeyCombo keyComboForKey:key];
	return [AKPersistedKeyCombo _ptKeyComboFromKeyCombo:keyCombo];
}

+ (void)setKeyCombo:(KeyCombo)keyCombo forKey:(NSString *)key
{
	NSDictionary* defaults = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithShort: keyCombo.code], @"keyCode",
							  [NSNumber numberWithInt: keyCombo.flags], @"modifierFlags", nil];
	[[NSUserDefaults standardUserDefaults] setObject:defaults forKey:key];
}

+ (void)setPTKeyCombo:(PTKeyCombo *)ptKeyCombo forKey:(NSString *)key
{
	KeyCombo keyCombo = [AKPersistedKeyCombo _keyComboFromPTKeyCombo:ptKeyCombo];
	[AKPersistedKeyCombo setKeyCombo:keyCombo forKey:key];
}

#pragma mark private
+ (PTKeyCombo *)_ptKeyComboFromKeyCombo:(KeyCombo)keyCombo
{
	NSInteger keyCode = keyCombo.code;
	NSUInteger modifiers = SRCocoaToCarbonFlags(keyCombo.flags);
	return [PTKeyCombo keyComboWithKeyCode:keyCode modifiers:modifiers];
}
+ (KeyCombo)_keyComboFromPTKeyCombo:(PTKeyCombo *)ptKeyCombo
{
	KeyCombo keyCombo;
	keyCombo.code = [ptKeyCombo keyCode];
	keyCombo.flags = [ptKeyCombo modifiers];
	return keyCombo;
}

@end

