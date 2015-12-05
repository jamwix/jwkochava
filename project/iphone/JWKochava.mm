#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import "TrackAndAd.h"
#include "JWKochava.h"

@interface JWKochava:NSObject
{
    KochavaTracker *kochavaTracker;
}

- (void)initWithOptions:(NSDictionary*) options;
- (void)trackEvent:(NSString*) eventTitle withValue:(NSString*) eventValue;
- (void)identityLink:(NSDictionary*) options;
- (NSString*)getKochavaId;

@end

@implementation JWKochava

- (void)initWithOptions:(NSDictionary*) options
{
    kochavaTracker = [[KochavaTracker alloc] initKochavaWithParams: options];
}

- (void)trackEvent:(NSString*) eventTitle withValue:(NSString*) eventValue
{
    [kochavaTracker trackEvent: eventTitle : eventValue];
}

- (void)identityLink:(NSDictionary*) options
{
    [kochavaTracker identityLinkEvent: options];
}

- (NSString*)getKochavaId
{
    NSString* deviceId = [kochavaTracker getKochavaDeviceId];
    if (deviceId == nil)
    {  
        return @"";
    }

    return deviceId;
}

@end

extern "C"
{
    static JWKochava * myKochava = nil;
    void jwkInit(const char *sOptions)
    {

        if (myKochava != nil)
        {
            return;
        }

        myKochava = [[JWKochava alloc] init];

		NSString *optsJson = [ [NSString alloc] initWithUTF8String: sOptions ];
        NSData *data = [optsJson dataUsingEncoding: NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *opts = [NSJSONSerialization JSONObjectWithData: data
                                                             options: nil
                                                               error: &error];

        if (!error)
        {
            [myKochava initWithOptions: opts];
        }
    }

    void jwkIdentityLink(const char *sOptions)
    {
        myKochava = [[JWKochava alloc] init];

		NSString *optsJson = [ [NSString alloc] initWithUTF8String: sOptions ];
        NSData *data = [optsJson dataUsingEncoding: NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *opts = [NSJSONSerialization JSONObjectWithData: data
                                                             options: nil
                                                               error: &error];

        if (!error)
        {
            [myKochava identityLink: opts];
        }
    }

    void jwkTrackEvent(const char *sTitle, const char *sValue)
    {
		NSString *title = [ [NSString alloc] initWithUTF8String: sTitle ];
		NSString *value = [ [NSString alloc] initWithUTF8String: sValue ];

        [myKochava trackEvent: title withValue: value];
    }

    const char * jwkKochavaId()
    {
        return [[myKochava getKochavaId] UTF8String];
    }
}
