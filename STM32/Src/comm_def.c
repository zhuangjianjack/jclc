#include "main.h"

const uint16_t wCRCTalbeAbs[] = {
	0x0000, 0xCC01, 0xD801, 0x1400, 0xF001, 0x3C00, 0x2800, 0xE401, \
	0xA001, 0x6C00, 0x7800, 0xB401, 0x5000, 0x9C01, 0x8801, 0x4400\
};
uint16_t crc16_calc(uint8_t * pchMsg, uint16_t wDataLen) 
{
  uint16_t wCRC = 0xFFFF;
  uint16_t i;
  uint8_t chChar;
  for (i = 0; i < wDataLen; i++) {
		chChar = *pchMsg++;
		wCRC = wCRCTalbeAbs[(chChar ^ wCRC) & 15] ^ (wCRC >> 4);
    wCRC = wCRCTalbeAbs[((chChar >> 4) ^ wCRC) & 15] ^ (wCRC >> 4);
  }
  return wCRC;
}
/*16位无符号整数小端模式转换为大端模式*/
uint16_t l2b16(uint16_t var)
{
	uint8_t *p, t;
	p = (uint8_t *)&var;
	t = *p;
	*p = *(p + 1);
	*(p + 1) = t;
	return var;
}
/*字节顺序反转，用于大端/小端存储格式的相互转换*/
void rbytes(uint8_t b[], uint8_t len)
{
	uint8_t i;
	uint8_t t;
	for (i = 0; i < len / 2; i++)
	{
		t = b[i];
		b[i] = b[len -1 - i];
		b[len -1 - i] = t;
	}
}
