#ifndef __COMM_DEF_H
#define __COMM_DEF_H
typedef enum
{
	FALSE = 0,
	TRUE = !FALSE
}BOOL_t;
uint16_t crc16_calc(uint8_t * pchMsg, uint16_t wDataLen);
uint16_t l2b16(uint16_t var);/*16λ�޷�������С��ģʽת��Ϊ���ģʽ*/
void rbytes(uint8_t b[], uint8_t len);/*�ֽ�˳��ת�����ڴ��/С�˴洢��ʽ���໥ת��*/
#endif
