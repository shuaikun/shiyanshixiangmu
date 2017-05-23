
#import <UIKit/UIKit.h>


@interface KeychainUtils : NSObject {
  
}

+ (NSString *) getItemFromKeychain: (NSString *) itemKey 
                    forServiceName: (NSString *) serviceName 
                             error: (NSError **) error;


+ (BOOL) addItemIntoKeychain: (NSString *) itemKey 
                    andValue: (NSString *) itemValue 
              forServiceName: (NSString *) serviceName 
              updateExisting: (BOOL) updateExisting 
                       error: (NSError **) error;


+ (BOOL) deleteItemFromKeychain: (NSString *) itemKey 
                 forServiceName: (NSString *) serviceName 
                          error: (NSError **) error;

@end