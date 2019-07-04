#ifndef __COMMAND_H
#define __COMMAND_H
#define K_ON(port, pin) HAL_GPIO_WritePin(port, pin, GPIO_PIN_SET)
#define K_OFF(port, pin) HAL_GPIO_WritePin(port, pin, GPIO_PIN_RESET)
#define SW_NUM 5
#define SW_CMD_LEN 3
#define RELAY_DELAY 100 //ms �̵��������ͺ�ʱ��
typedef enum
{
	ACT_STOP = 0,
	ACT_ON,
	ACT_OFF
}SWActType_t;
typedef enum
{
	SW_FAN = 0,	//�������
	SW_SUNSHADE,//������
	SW_TOPFILM,	//����Ĥ
	SW_SIDEFILM,//���Ĥ
	SW_LIGHT		//����
}SWType_t;
typedef struct
{
	SWType_t	type;				//����
	SWActType_t	action;				//����
	CommandResType_t result;	//����ִ�н��
	SWActType_t status;				//״̬
	BOOL_t				command_new;//�������־
	char *				cmdbuf;			//�������
	uint8_t				cmdsize;		//���������С
	GPIO_TypeDef *k1_port;
	uint16_t			k1_pin;
	GPIO_TypeDef *k2_port;
	uint16_t			k2_pin;
}SW_Handle_t;//���ؾ��
/*ִ�п���������*/
BOOL_t SW_Cmd_Exec(PtrQue_TypeDef * swq);
/*�������������ˢ�¿��ض���*/
void SW_Cmd_Analysis(PtrQue_TypeDef * swq, char c);
/*������г�ʼ��*/
void SW_Que_Init(PtrQue_TypeDef * swq);
/*���ƿ��ض���*/
void SW_Control(SW_Handle_t * sw);
CommandResType_t SW_OFF(SW_Handle_t * sw);
CommandResType_t SW_ON(SW_Handle_t * sw);
CommandResType_t SW_STOP(SW_Handle_t * sw);
#endif
