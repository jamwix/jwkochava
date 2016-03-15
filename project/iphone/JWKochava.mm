#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
#import "TrackAndAd.h"
#include "JWKochava.h"

@interface JWKochava:NSObject <KochavaTrackerClientDelegate>
{
    KochavaTracker *kochavaTracker;
    NSDictionary *_attrResult;
}

- (void)initWithOptions:(NSDictionary*) options;
- (void)trackEvent:(NSString*) eventTitle withValue:(NSString*) eventValue;
- (void)identityLink:(NSDictionary*) options;
- (NSString*)getKochavaId;
- (NSString*)getAttributionData;
- (void) Kochava_attributionResult:(NSDictionary *)attributionResult;

@end

@implementation JWKochava

- (void)initWithOptions:(NSDictionary*) options
{
    kochavaTracker = [[KochavaTracker alloc] initKochavaWithParams: options];
    kochavaTracker.trackerDelegate = self;
}

- (void) Kochava_attributionResult:(NSDictionary *)attributionResult
{
    _attrResult = attributionResult;
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

- (NSString*)getAttributionData
{
    //NSDictionary* data = [kochavaTracker retrieveAttribution];
    if (!_attrResult || _attrResult == nil || ![NSJSONSerialization isValidJSONObject: _attrResult]) 
    {
        NSLog(@"NO ATTR RESULT FOUND");
        return @"null";
    }

     NSError *error;
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject: _attrResult
                                                        options: 0
                                                          error: &error];

     if (!jsonData) {
        NSLog(@"getAttributionData error: %@", error.localizedDescription);
        return @"null";
     } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     } 
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

    const char * jwkGetAttributionData()
    {
        return [[myKochava getAttributionData] UTF8String];
    }
}
