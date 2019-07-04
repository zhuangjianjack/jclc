#ifndef __MSG_H
#define __MSG_H
#define CMDSTR_SIZE 7
#define CMDDATA_NUM 2
typedef enum
{
	RES_FAILED = 0,
	RES_OK,
	RES_KEEP
}CommandResType_t;
typedef struct
{
	char cmd;
	uint8_t data[CMDDATA_NUM];
	CommandResType_t retcode;
}Command_t;

void UART_Msg_Rx(char c);
void events_proc(void);
#endif
