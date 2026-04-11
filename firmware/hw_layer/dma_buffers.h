/**
 * @file dma_buffers.h
 *
 * Combined DMA-safe memory region for all buffers that need cache-coherent
 * access on Cortex-M7 (SD card, big buffer, USB MSD block buffer).
 */

#pragma once

#include <cstdint>

#if EFI_PROD_CODE

#if EFI_FILE_LOGGING
#include "ff.h"

struct SdLogBufferWriter;

#if EFI_WIFI
/**
 * Shared HTTP server buffers.
 * Placed here to ensure they are inside the non-cacheable MPU region on H7.
 */
struct HttpBuffer {
	FIL file;
	uint8_t reqBuf[2048];
	uint8_t fileBuf[2800];
	uint8_t httpOut[1400];
};
#endif // EFI_WIFI

#endif // EFI_FILE_LOGGING

namespace dma_buffers {

void initMpu();
uint8_t* bigBuffer();
uint8_t* sdCardBlockBuffer();
uint8_t* msdIniBlockBuffer();

#if EFI_FILE_LOGGING
FATFS* fs();
FIL* logFileFd();
SdLogBufferWriter& logBuffer();
#endif // EFI_FILE_LOGGING

#if EFI_WIFI
HttpBuffer* http();
#endif // EFI_WIFI

} // namespace dma_buffers

#endif // EFI_PROD_CODE
