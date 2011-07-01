//
//  PersistedKeyCombo.h
//  Serenitas
//
//  Created by Adam Ko on 23/08/2010.
//  Copyright 2010 Imperial College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import "PTKeyCombo.h"

#define PKZeroCombo ((KeyCombo){-1,0})

@interface AKPersistedKeyCombo : NSObject

+ (KeyCombo)keyComboForKey:(NSString *)key;
+ (PTKeyCombo *)ptKeyComboForKey:(NSString *)key;
+ (void)setKeyCombo:(KeyCombo)keyCombo forKey:(NSString *)key;
+ (void)setPTKeyCombo:(PTKeyCombo *)ptKeyCombo forKey:(NSString *)key;

@end

