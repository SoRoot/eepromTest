#pragma once

//////////////////////////////////////////////////////////////////
// Define the global variables and const variables
//////////////////////////////////////////////////////////////////
const BYTE MSB_FALLING_EDGE_CLOCK_BYTE_IN = '\x24';
const BYTE MSB_FALLING_EDGE_CLOCK_BYTE_OUT = '\x11';
const BYTE MSB_RISING_EDGE_CLOCK_BIT_IN = '\x22';
FT_STATUS ftStatus;						 // Status defined in D2XX to indicate operation result
FT_HANDLE ftHandle;						 // Handle of FT2232H device port
BYTE OutputBuffer[1024];			 // Buffer to hold MPSSE commands and data to be sent to FT2232H
BYTE InputBuffer[1024];				 // Buffer to hold Data bytes to be read from FT2232H
DWORD dwClockDivisor = 0x0095; // Value of clock divisor, SCL Frequency = 60/((1+0x0095)*2) (MHz) = 200khz
DWORD dwNumBytesToSend = 0;		 // Index of output buffer
DWORD dwNumBytesSent = 0, dwNumBytesRead = 0, dwNumInputBuffer = 0;


void HighSpeedSetI2CStart(void);
void HighSpeedSetI2CStop(void);
BOOL SendByteAndCheckACK(BYTE dwDataSend);
BOOL initEEPROM(void);
BOOL programEEPROM(void);
BOOL readEEPROM(void);