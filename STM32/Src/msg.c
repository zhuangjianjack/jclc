#include "main.h"
typedef enum {CMD_READY, CMD_RX} Cmd_State_t;
void UART_Msg_Rx(char c)
{
	static char buf[CMDSTR_SIZE];
	static uint8_t i = 0;
	static Cmd_State_t s = CMD_READY;
	BOOL_t cmd_rxed;
	Command_t * msg;
	int j,k;
	cmd_rxed = FALSE;
	switch (s)
	{
		case CMD_READY:
			if (c == '@')
			{
				i = 0;
				s = CMD_RX;
			}
			break;
		case CMD_RX:
			if (c == '@')
			{
				i = 0;//start a new command receiving again
			}
			else if (c == '#')
			{
				cmd_rxed = TRUE;//received a command.
				s = CMD_READY;
			}
			else if (i >= CMDSTR_SIZE)//overflow
			{
				i = 0;
				s = CMD_READY;
			}
			else
			{
				buf[i] = c;
				i++;
			}
			break;
		default:
			i = 0;
			s = CMD_READY;
	}
	if (cmd_rxed)
	{
		buf[i] = '\0';
		printf_dbg("rx cmd: %s\r\n", buf);
		if (buf[0] >= 'a' && buf[0] <= 'd') //valid command char
		{
			if (buf[1] == ',')//format check
			{
				msg = (Command_t *)malloc(sizeof(Command_t));
				msg->cmd = buf[0];
				msg->data[0] = 0;
				msg->data[1] = 0;
				msg->retcode = RES_FAILED;
				for (j = 2; j < i; j++)
				{
					if (buf[j] == ',')
						break;
				}
				for (k = 2; k < j; k++)
				{
					msg->data[0] = msg->data[0] * 10 + buf[k] - 0x30;
				}
				for (k = j + 1; k < i; k++)
				{
					msg->data[1] = msg->data[1] * 10 + buf[k] - 0x30;
				}
				PtrQue_In(&msg_que, (void *)msg);
			}
		}
//		while (PtrQue_Out(&msg_que, (void **)&msg))
//		{
//			printf_dbg("que: %c,%d,%d\r\n", msg->cmd, msg->data[0], msg->data[1]);
//		}
	}
}

void events_proc()
{
	Command_t * msg;
	SW_Handle_t * swh;
	int i;
	while (PtrQue_Out(&msg_que, (void **)&msg))
	{
		printf_dbg("process msg: %c,%d,%d\r\n", msg->cmd, msg->data[0], msg->data[1]);
		switch (msg->cmd)
		{
			case 'a':
				LED0_ON();
				Sensors_Polling_Ex(&sens_que, msg->data[0]);
				LED0_OFF();
				break;
			case 'b':
				printf("@%c,%d,%c#", msg->cmd, msg->data[0], ((SW_Handle_t *)(switch_que.data[msg->data[0] - 1]))->status);
				break;
			case 'c':
				if (msg->data[0] < 0 || msg->data[0] > 5)
				{
					msg->retcode = RES_FAILED;
				}
				else
				{
					if (msg->data[0] == 0) // control all switch (ID = 0)
					{
						for (i = 0; i < 5; i++)
						{
							swh = (SW_Handle_t *)(switch_que.data[i]);
							switch (msg->data[1])
							{
								case ACT_STOP://STOP
									msg->retcode = SW_STOP(swh);
									break;
								case ACT_ON://ON
									msg->retcode = SW_ON(swh);
									break;
								case ACT_OFF://OFF
									msg->retcode = SW_OFF(swh);
									break;
								default://no valid switch action in command string
									msg->retcode = RES_FAILED;
							}
							printf("@c,%d#", msg->retcode);
						}
					}
					else //control one switch
					{
						swh = (SW_Handle_t *)(switch_que.data[msg->data[0] - 1]);
						switch (msg->data[1])
						{
							case ACT_STOP://STOP
								msg->retcode = SW_STOP(swh);
								break;
							case ACT_ON://ON
								msg->retcode = SW_ON(swh);
								break;
							case ACT_OFF://OFF
								msg->retcode = SW_OFF(swh);
								break;
							default://no valid switch action in command string
								msg->retcode = RES_FAILED;
						}
						printf("@c,%d#", msg->retcode);
					}
				}
				break;
			case 'd':
				printf("@d,1#");
				break;
		}
	}
	if (gevents & EV_PTIMOUT)
	{
		gevents ^= EV_PTIMOUT;
		LED0_ON();
		Sensors_Polling_Ex(&sens_que, 0);
		LED0_OFF();
	}
	if (gevents & EV_RSTIMOUT)
	{
		gevents ^= EV_RSTIMOUT;
		LED1_TOGGLE();
	}
}
