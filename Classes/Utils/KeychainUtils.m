
#import "KeychainUtils.h"
#import <Security/Security.h>

static NSString *KeychainUtilsErrorDomain = @"KeychainUtilsErrorDomain";

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR
@interface KeychainUtils (PrivateMethods)
+ (SecKeychainItemRef) getKeychainItemReferenceForitemKey: (NSString *) itemKey forServiceName: (NSString *) serviceName error: (NSError **) error;
@end
#endif

@implementation KeychainUtils

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR

+ (NSString *) getItemFromKeychain: (NSString *) itemKey 
                    forServiceName: (NSString *) serviceName 
                             error: (NSError **) error
{
	if (!itemKey || !serviceName) {
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return nil;
	}
	
	SecKeychainItemRef item = [KeychainUtils getKeychainItemReferenceForitemKey: itemKey forServiceName: serviceName error: error];
	
	if (*error || !item) {
		return nil;
	}
	
	// from Advanced Mac OS X Programming, ch. 16
    UInt32 length;
    char *itemValue;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;
	
    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;
    
    list.count = 4;
    list.attr = attributes;
    
    OSStatus status = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&itemValue);
	
	if (status != noErr) {
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: status userInfo: nil];
		return nil;
    }
    
	NSString *itemValueString = nil;
	
	if (itemValue != NULL) {
		char itemValueBuffer[1024];
		
		if (length > 1023) {
			length = 1023;
		}
		strncpy(itemValueBuffer, itemValue, length);
		
		itemValueBuffer[length] = '\0';
		itemValueString = [NSString stringWithCString:itemValueBuffer];
	}
	
	SecKeychainItemFreeContent(&list, itemValue);
    
    CFRelease(item);
    
    return itemValueString;
}

+ (BOOL) addItemIntoKeychain: (NSString *) itemKey 
                    andValue: (NSString *) itemValue 
              forServiceName: (NSString *) serviceName 
              updateExisting: (BOOL) updateExisting 
                       error: (NSError **) error
{	
	if (!itemKey || !itemValue || !serviceName) {
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return;
	}
	
	OSStatus status = noErr;
	
	SecKeychainItemRef item = [KeychainUtils getKeychainItemReferenceForitemKey: itemKey forServiceName: serviceName error: error];
	
	if (*error && [*error code] != noErr) {
		return;
	}
	
	*error = nil;
	
	if (item) {
		status = SecKeychainItemModifyAttributesAndData(item,
                                                        NULL,
                                                        strlen([itemValue UTF8String]),
                                                        [itemValue UTF8String]);
		
		CFRelease(item);
	}
	else {
		status = SecKeychainAddGenericitemValue(NULL,                                     
                                                strlen([serviceName UTF8String]), 
                                                [serviceName UTF8String],
                                                strlen([itemKey UTF8String]),                        
                                                [itemKey UTF8String],
                                                strlen([itemValue UTF8String]),
                                                [itemValue UTF8String],
                                                NULL);
	}
	
	if (status != noErr) {
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: status userInfo: nil];
	}
}

+ (BOOL) deleteItemFromKeychain: (NSString *) itemKey 
                 forServiceName: (NSString *) serviceName 
                          error: (NSError **) error
{
	if (!itemKey || !serviceName) {
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: 2000 userInfo: nil];
		return;
	}
	
	*error = nil;
	
	SecKeychainItemRef item = [KeychainUtils getKeychainItemReferenceForitemKey: itemKey forServiceName: serviceName error: error];
	
	if (*error && [*error code] != noErr) {
		return;
	}
	
	OSStatus status;
	
	if (item) {
		status = SecKeychainItemDelete(item);
		
		CFRelease(item);
	}
	
	if (status != noErr) {
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: status userInfo: nil];
	}
}

+ (SecKeychainItemRef) getKeychainItemReferenceForitemKey: (NSString *) itemKey forServiceName: (NSString *) serviceName error: (NSError **) error {
	if (!itemKey || !serviceName) {
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: -2000 userInfo: nil];
		return nil;
	}
	
	*error = nil;
    
	SecKeychainItemRef item;
	
	OSStatus status = SecKeychainFindGenericitemValue(NULL,
                                                      strlen([serviceName UTF8String]),
                                                      [serviceName UTF8String],
                                                      strlen([itemKey UTF8String]),
                                                      [itemKey UTF8String],
                                                      NULL,
                                                      NULL,
                                                      &item);
	
	if (status != noErr) {
		if (status != errSecItemNotFound) {
			*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: status userInfo: nil];
		}
		
		return nil;		
	}
	
	return item;
}

#else

+ (NSString *) getItemFromKeychain: (NSString *) itemKey 
                    forServiceName: (NSString *) serviceName 
                             error: (NSError **) error
{
	if (!itemKey || !serviceName) {
		if (error != nil) {
			*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return nil;
	}
	
	if (error != nil) {
		*error = nil;
	}
    
	// Set up a query dictionary with the base query attributes: item type (generic), itemKey, and service
	
	NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil] autorelease];
	NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, itemKey, serviceName, nil] autorelease];
	
	NSMutableDictionary *query = [[[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
	
	// First do a query for attributes, in case we already have a Keychain item with no itemValue data set.
	// One likely way such an incorrect item could have come about is due to the previous (incorrect)
	// version of this code (which set the itemValue as a generic attribute instead of itemValue data).
	
	NSDictionary *attributeResult = NULL;
	NSMutableDictionary *attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
	OSStatus status = SecItemCopyMatching((CFDictionaryRef) attributeQuery, (CFTypeRef *) &attributeResult);
	
	[attributeResult release];
	[attributeQuery release];
	
	if (status != noErr) {
		// No existing item found--simply return nil for the itemValue
		if (error != nil && status != errSecItemNotFound) {
			//Only return an error if a real exception happened--not simply for "not found."
			*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: status userInfo: nil];
		}
		
		return nil;
	}
	
	// We have an existing item, now query for the itemValue data associated with it.
	
	NSData *resultData = nil;
	NSMutableDictionary *itemValueQuery = [query mutableCopy];
	[itemValueQuery setObject: (id) kCFBooleanTrue forKey: (id) kSecReturnData];
    
	status = SecItemCopyMatching((CFDictionaryRef) itemValueQuery, (CFTypeRef *) &resultData);
	
	[resultData autorelease];
	[itemValueQuery release];
	
	if (status != noErr) {
		if (status == errSecItemNotFound) {
			// We found attributes for the item previously, but no itemValue now, so return a special error.
			// Users of this API will probably want to detect this error and prompt the user to
			// re-enter their credentials.  When you attempt to store the re-entered credentials
			// using storeitemKey:anditemValue:forServiceName:updateExisting:error
			// the old, incorrect entry will be deleted and a new one with a properly encrypted
			// itemValue will be added.
			if (error != nil) {
				*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: -1999 userInfo: nil];
			}
		}
		else {
			// Something else went wrong. Simply return the normal Keychain API error code.
			if (error != nil) {
				*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: status userInfo: nil];
			}
		}
		
		return nil;
	}
    
	NSString *itemValue = nil;	
    
	if (resultData) {
		itemValue = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
	}
	else {
		// There is an existing item, but we weren't able to get itemValue data for it for some reason,
		// Possibly as a result of an item being incorrectly entered by the previous code.
		// Set the -1999 error so the code above us can prompt the user again.
		if (error != nil) {
			*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: -1999 userInfo: nil];
		}
	}
    
	return [itemValue autorelease];
}

+ (BOOL) addItemIntoKeychain: (NSString *) itemKey 
                    andValue: (NSString *) itemValue 
              forServiceName: (NSString *) serviceName 
              updateExisting: (BOOL) updateExisting 
                       error: (NSError **) error
{		
	if (!itemKey || !itemValue || !serviceName) 
    {
		if (error != nil) 
        {
			*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
	
	// See if we already have a itemValue entered for these credentials.
	NSError *getError = nil;
	NSString *existingitemValue = [KeychainUtils getItemFromKeychain: itemKey forServiceName: serviceName error:&getError];
    
	if ([getError code] == -1999) 
    {
		// There is an existing entry without a itemValue properly stored (possibly as a result of the previous incorrect version of this code.
		// Delete the existing item before moving on entering a correct one.
        
		getError = nil;
		
		[self deleteItemFromKeychain: itemKey forServiceName: serviceName error: &getError];
        
		if ([getError code] != noErr) 
        {
			if (error != nil) 
            {
				*error = getError;
			}
			return NO;
		}
	}
	else if ([getError code] != noErr) 
    {
		if (error != nil) 
        {
			*error = getError;
		}
		return NO;
	}
	
	if (error != nil) 
    {
		*error = nil;
	}
	
	OSStatus status = noErr;
    
	if (existingitemValue) 
    {
		// We have an existing, properly entered item with a itemValue.
		// Update the existing item.
		
		if (![existingitemValue isEqualToString:itemValue] && updateExisting) 
        {
			//Only update if we're allowed to update existing.  If not, simply do nothing.
			
			NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, 
                              kSecAttrService, 
                              kSecAttrLabel, 
                              kSecAttrAccount, 
                              nil] autorelease];
			
			NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, 
                                 serviceName,
                                 serviceName,
                                 itemKey,
                                 nil] autorelease];
			
			NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];			
			
			status = SecItemUpdate((CFDictionaryRef) query, (CFDictionaryRef) [NSDictionary dictionaryWithObject: [itemValue dataUsingEncoding: NSUTF8StringEncoding] forKey: (NSString *) kSecValueData]);
		}
	}
	else 
    {
		// No existing entry (or an existing, improperly entered, and therefore now
		// deleted, entry).  Create a new entry.
		
		NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, 
                          kSecAttrService, 
                          kSecAttrLabel, 
                          kSecAttrAccount, 
                          kSecValueData, 
                          nil] autorelease];
		
		NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, 
                             serviceName,
                             serviceName,
                             itemKey,
                             [itemValue dataUsingEncoding: NSUTF8StringEncoding],
                             nil] autorelease];
		
		NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];			
        
		status = SecItemAdd((CFDictionaryRef) query, NULL);
	}
	
	if (error != nil && status != noErr) 
    {
		// Something went wrong with adding the new item. Return the Keychain error code.
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: status userInfo: nil];
        
        return NO;
	}
    
    return YES;
}

+ (BOOL) deleteItemFromKeychain: (NSString *) itemKey 
                 forServiceName: (NSString *) serviceName 
                          error: (NSError **) error 
{
	if (!itemKey || !serviceName) 
    {
		if (error != nil) 
        {
			*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: -2000 userInfo: nil];
		}
		return NO;
	}
	
	if (error != nil) 
    {
		*error = nil;
	}
    
	NSArray *keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil] autorelease];
	NSArray *objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, itemKey, serviceName, kCFBooleanTrue, nil] autorelease];
	
	NSDictionary *query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
	
	OSStatus status = SecItemDelete((CFDictionaryRef) query);
	
	if (error != nil && status != noErr) 
    {
		*error = [NSError errorWithDomain: KeychainUtilsErrorDomain code: status userInfo: nil];		
        
        return NO;
	}
    
    return YES;
}

#endif

@end