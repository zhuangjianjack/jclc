#ifndef __COMM_DEF_H
#define __COMM_DEF_H
typedef enum
{
	FALSE = 0,
	TRUE = !FALSE
}BOOL_t;
uint16_t crc16_calc(uint8_t * pchMsg, uint16_t wDataLen);
uint16_t l2b16(uint16_t var);/*16位无符号整数小端模式转换为大端模式*/
void rbytes(uint8_t b[], uint8_t len);/*字节顺序反转，用于大端/小端存储格式的相互转换*/
#endif
