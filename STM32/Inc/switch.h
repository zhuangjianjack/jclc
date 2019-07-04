#ifndef __COMMAND_H
#define __COMMAND_H
#define K_ON(port, pin) HAL_GPIO_WritePin(port, pin, GPIO_PIN_SET)
#define K_OFF(port, pin) HAL_GPIO_WritePin(port, pin, GPIO_PIN_RESET)
#define SW_NUM 5
#define SW_CMD_LEN 3
#define RELAY_DELAY 100 //ms 继电器动作滞后时间
typedef enum
{
	ACT_STOP = 0,
	ACT_ON,
	ACT_OFF
}SWActType_t;
typedef enum
{
	SW_FAN = 0,	//环流风机
	SW_SUNSHADE,//遮阳网
	SW_TOPFILM,	//顶卷膜
	SW_SIDEFILM,//侧卷膜
	SW_LIGHT		//照明
}SWType_t;
typedef struct
{
	SWType_t	type;				//类型
	SWActType_t	action;				//动作
	CommandResType_t result;	//命令执行结果
	SWActType_t status;				//状态
	BOOL_t				command_new;//新命令标志
	char *				cmdbuf;			//命令缓冲区
	uint8_t				cmdsize;		//命令缓冲区大小
	GPIO_TypeDef *k1_port;
	uint16_t			k1_pin;
	GPIO_TypeDef *k2_port;
	uint16_t			k2_pin;
}SW_Handle_t;//开关句柄
/*执行控制器命令*/
BOOL_t SW_Cmd_Exec(PtrQue_TypeDef * swq);
/*解析串口命令，并刷新开关队列*/
void SW_Cmd_Analysis(PtrQue_TypeDef * swq, char c);
/*命令队列初始化*/
void SW_Que_Init(PtrQue_TypeDef * swq);
/*控制开关动作*/
void SW_Control(SW_Handle_t * sw);
CommandResType_t SW_OFF(SW_Handle_t * sw);
CommandResType_t SW_ON(SW_Handle_t * sw);
CommandResType_t SW_STOP(SW_Handle_t * sw);
#endif
