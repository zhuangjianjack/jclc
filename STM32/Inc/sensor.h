#ifndef __SENSOR_H
#define __SENSOR_H
#define MODBUS_CMD_TIMEOUT 100  //ModBus命令发送超时时间（ms），超出此时间命令未发出认为发送失败
#define MODBUS_RESP_TIMEOUT 100 //ModBus等待响应超时时间（ms），即发出ModBus命令后，等待接收方响应的时间，超出此时间认为失去响应
#define POLLING_PERIOD 20		//巡检周期（s）
#define POLLING_INTERVAL 20 //RS485总线上不同传感器命令间隔时间（ms）
#define SENS_SIM 0					//传感器数据仿真，如果为1，则不会接收真实的传感器数据，直接填写一个预设的数据到modbus响应数据缓冲区
extern const char * SENS_TYPE_STR[];
typedef enum
{
	SEN_TEMP_HUMI = 0,	//土壤温湿度传感器
	SEN_ILLUM_T_H,			//光照温湿度传感器
	SEN_CO2_T_H,				//CO2温湿度传感器
	SEN_COND_SALT			//电导率盐分传感器
}SensorType_t;//传感器类型
__packed typedef struct
{
	uint8_t rs485addr;	//485总线地址
	uint8_t funcode;		//modbus功能码
	uint16_t regaddr;		//modbus寄存器首地址
	uint16_t regcount;	//modbus寄存器数量
	uint16_t crc16;				//16位CRC校验（小端存储）
}ModBus_Cmd_t;//ModBus命令格式
__packed typedef struct
{
	uint8_t rs485addr;	//485总线地址
	uint8_t funcode;		//modbus功能码
	uint8_t datasize;		//其后的数据长度（不包括CRC校验码）
	uint16_t regaddr;		//modbus寄存器首地址
	uint16_t regcount;	//modbus寄存器数量
	uint16_t crc16;				//16位CRC校验（小端存储）
}ModBus_Cmd_Ext_t;//ModBus命令扩展格式（非正规的）
__packed typedef union
{
	__packed uint8_t cmdbytes[9];
	ModBus_Cmd_t cmd;
	ModBus_Cmd_Ext_t cmd_ext;
}ModBus_Cmd_Union_t;
__packed typedef struct
{
	uint8_t rs485addr;	//485总线地址
	uint8_t funcode;		//modbus功能码
	uint8_t datasize;		//其后的数据长度（不包括CRC校验码）
	uint16_t humidity;		//湿度
	int16_t temperature;	//温度
	uint32_t illuminance;	//光照度
	uint16_t crc16;				//16位CRC校验（小端存储）
}ModBus_Resp_IHT_t;//光照温湿度传感器响应数据结构
__packed typedef struct
{
	uint8_t rs485addr;	//485总线地址
	uint8_t funcode;		//modbus功能码
	uint8_t datasize;		//其后的数据长度（不包括CRC校验码）
	uint16_t humidity;		//湿度
	int16_t temperature;	//温度
	uint16_t co2;					//二氧化碳浓度
	uint16_t crc16;				//16位CRC校验（小端存储）
}ModBus_Resp_CO2HT_t;//二氧化碳浓度温湿度传感器响应数据结构
__packed typedef struct
{
	uint8_t rs485addr;	//485总线地址
	uint8_t funcode;		//modbus功能码
	uint8_t datasize;		//其后的数据长度（不包括CRC校验码）
	uint16_t humidity;		//湿度
	int16_t temperature;	//温度
	uint16_t crc16;				//16位CRC校验（小端存储）
}ModBus_Resp_HT_t;//土壤水分温度传感器响应数据结构
__packed typedef struct
{
	uint8_t rs485addr;	//485总线地址
	uint8_t funcode;		//modbus功能码
	uint8_t datasize;		//其后的数据长度（不包括CRC校验码）
	uint16_t cond;			//电导率
	int16_t salt;				//盐分
	uint16_t crc16;				//16位CRC校验（小端存储）
}ModBus_Resp_CS_t;//土壤电导率盐分传感器响应数据结构
__packed typedef union
{
	uint8_t respbytes[13];
	ModBus_Resp_IHT_t resp_iht;
	ModBus_Resp_CO2HT_t resp_co2ht;
	ModBus_Resp_HT_t resp_ht;
	ModBus_Resp_CS_t resp_cs;
}ModBus_Resp_Union_t;
__packed typedef struct
{
	SensorType_t type;	//传感器类型
	ModBus_Cmd_Union_t *modbus_cmd;//modbus命令指针
	uint8_t mb_cmdsize;	//modbus命令长度
	ModBus_Resp_Union_t * modbus_resp;//modbus响应数据指针
	uint8_t mb_respsize;	//modbus响应数据长度
	BOOL_t mb_resp_new;
}Sensor_Handle_t;
/*发送传感器Modbus命令*/
BOOL_t Modbus_Send_Cmd(Sensor_Handle_t * hs);
/*接收传感器Modbus响应*/
BOOL_t Modbus_Receive_Resp(Sensor_Handle_t * hs);
/*传感器巡检*/
void Sensors_Polling(PtrQue_TypeDef * sq);
/*解析巡检后的传感器数据*/
void Sens_Data_Proc(PtrQue_TypeDef * sq);
/*传感器队列初始化*/
void Sensors_Que_Init(PtrQue_TypeDef * sq);
/*打印传感器队列*/
void Sensors_Que_Print(PtrQue_TypeDef * sq);
#endif
