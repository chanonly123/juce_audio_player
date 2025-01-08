#include <JuceHeader.h>
#include "includes/juce_lib.h"
#include "Logger.h"
#include "JuceMixPlayer.h"
#include "Models.h"

void Java_com_rmsl_juce_Java_juceMessageManagerInit()
{
    juce::MessageManager::getInstance();
}

void juceEnableLogs()
{
    enableLogsValue = true;
}

// MARK: JuceMixPlayer

void *JuceMixPlayer_init()
{
    return new JuceMixPlayer();
}

void JuceMixPlayer_deinit(void *ptr)
{
    juce::MessageManager::getInstanceWithoutCreating()->callAsync([=] {
        delete static_cast<JuceMixPlayer *>(ptr);
    });
}

void JuceMixPlayer_play(void *ptr)
{
    static_cast<JuceMixPlayer *>(ptr)->play();
}

void JuceMixPlayer_pause(void *ptr)
{
    static_cast<JuceMixPlayer *>(ptr)->pause();
}

void JuceMixPlayer_stop(void *ptr)
{
    static_cast<JuceMixPlayer *>(ptr)->stop();
}

void JuceMixPlayer_set(void* ptr, const char* json)
{
    static_cast<JuceMixPlayer *>(ptr)->setJson(json);
}

void JuceMixPlayer_onStateUpdate(void* ptr, void (*onStateUpdate)(void* ptr, const char*))
{
    static_cast<JuceMixPlayer *>(ptr)->onStateUpdate(onStateUpdate);
}

void JuceMixPlayer_onProgress(void* ptr, void (*onProgress)(void* ptr, float))
{
    static_cast<JuceMixPlayer *>(ptr)->onProgress(onProgress);
}

void JuceMixPlayer_onError(void* ptr, void (*onError)(void* ptr, const char*))
{
    static_cast<JuceMixPlayer *>(ptr)->onError(onError);
}

float JuceMixPlayer_getDuration(void *ptr)
{
    return static_cast<JuceMixPlayer *>(ptr)->getDuration();
}

int JuceMixPlayer_isPlaying(void *ptr)
{
    return static_cast<JuceMixPlayer *>(ptr)->isPlaying();
}

void JuceMixPlayer_seek(void* ptr, float value)
{
    static_cast<JuceMixPlayer *>(ptr)->seek(value);
}
