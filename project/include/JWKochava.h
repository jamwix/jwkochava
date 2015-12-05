#ifndef JWKOCHAVA_H
#define JWKOCHAVA_H


namespace jwkochava {
	
    extern "C"
    {
        void jwkInit(const char *sOptions);
        void jwkTrackEvent(const char *sTitle, const char *sValue);
        void jwkIdentityLink(const char *sOptions);
        const char * jwkKochavaId();
    }
	
}


#endif
