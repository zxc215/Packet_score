#include <stdint.h>
#include "pif_plugin.h"
#include "pif_plugin_score_metadata.h"

#define ARRAY_SIZE (1024*1024) //1M

static __lmem uint16_t  score_array[ARRAY_SIZE] = {0};
static __lmem uint64_t array_tail = 0;

int pif_plugin_add_score_array(EXTRACTED_HEADERS_T* headers, MATCH_DATA_T* data)
{
    PIF_PLUGIN_score_metadata_T* score_metadata = NULL;

    if ( !pif_plugin_hdr_score_metadata_present(headers) )
    {
        return PIF_PLUGIN_RETURN_DROP;
    }

    if( NULL == (score_metadata = pif_plugin_hdr_get_score_medata(headers)))
    {
        return PIF_PLUGIN_RETURN_DROP;
    }

    score_array[array_tail++] = score_metadata->score;

    return PIF_PLUGIN_RETURN_FORWARD;
}
