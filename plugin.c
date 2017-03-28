#include <stdint.h>
#include "pif_plugin.h"
#include "pif_plugin_metadata.h"

#define ARRAY_SIZE (1024*360) //1K

static __declspec(emem) uint16_t  score_array[ARRAY_SIZE] = {0};
static __declspec(mem) uint64_t array_tail = 0;

int pif_plugin_add_to_array(EXTRACTED_HEADERS_T* headers, MATCH_DATA_T* data)
{

    if(array_tail < ARRAY_SIZE)
    {
         score_array[array_tail++] = (uint16_t)pif_plugin_meta_get__score_metadata__score(headers);
    }
    else
    {
	return PIF_PLUGIN_RETURN_DROP;    
    }

    return PIF_PLUGIN_RETURN_FORWARD;
}
