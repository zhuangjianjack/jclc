#ifndef __SENSOR_H
#define __SENSOR_H
#define MODBUS_CMD_TIMEOUT 100  //ModBus����ͳ�ʱʱ�䣨ms����������ʱ������δ������Ϊ����ʧ��
#define MODBUS_RESP_TIMEOUT 100 //ModBus�ȴ���Ӧ��ʱʱ�䣨ms����������ModBus����󣬵ȴ����շ���Ӧ��ʱ�䣬������ʱ����Ϊʧȥ��Ӧ
#define POLLING_PERIOD 20		//Ѳ�����ڣ�s��
#define POLLING_INTERVAL 20 //RS485�����ϲ�ͬ������������ʱ�䣨ms��
#define SENS_SIM 0					//���������ݷ��棬���Ϊ1���򲻻������ʵ�Ĵ��������ݣ�ֱ����дһ��Ԥ������ݵ�modbus��Ӧ���ݻ�����
extern const char * SENS_TYPE_STR[];
typedef enum
{
	SEN_TEMP_HUMI = 0,	//������ʪ�ȴ�����
	SEN_ILLUM_T_H,			//������ʪ�ȴ�����
	SEN_CO2_T_H,				//CO2��ʪ�ȴ�����
	SEN_COND_SALT			//�絼���ηִ�����
}SensorType_t;//����������
__packed typedef struct
{
	uint8_t rs485addr;	//485���ߵ�ַ
	uint8_t funcode;		//modbus������
	uint16_t regaddr;		//modbus�Ĵ����׵�ַ
	uint16_t regcount;	//modbus�Ĵ�������
	uint16_t crc16;				//16λCRCУ�飨С�˴洢��
}ModBus_Cmd_t;//ModBus�����ʽ
__packed typedef struct
{
	uint8_t rs485addr;	//485���ߵ�ַ
	uint8_t funcode;		//modbus������
	uint8_t datasize;		//�������ݳ��ȣ�������CRCУ���룩
	uint16_t regaddr;		//modbus�Ĵ����׵�ַ
	uint16_t regcount;	//modbus�Ĵ�������
	uint16_t crc16;				//16λCRCУ�飨С�˴洢��
}ModBus_Cmd_Ext_t;//ModBus������չ��ʽ��������ģ�
__packed typedef union
{
	__packed uint8_t cmdbytes[9];
	ModBus_Cmd_t cmd;
	ModBus_Cmd_Ext_t cmd_ext;
}ModBus_Cmd_Union_t;
__packed typedef struct
{
	uint8_t rs485addr;	//485���ߵ�ַ
	uint8_t funcode;		//modbus������
	uint8_t datasize;		//�������ݳ��ȣ�������CRCУ���룩
	uint16_t humidity;		//ʪ��
	int16_t temperature;	//�¶�
	uint32_t illuminance;	//���ն�
	uint16_t crc16;				//16λCRCУ�飨С�˴洢��
}ModBus_Resp_IHT_t;//������ʪ�ȴ�������Ӧ���ݽṹ
__packed typedef struct
{
	uint8_t rs485addr;	//485���ߵ�ַ
	uint8_t funcode;		//modbus������
	uint8_t datasize;		//�������ݳ��ȣ�������CRCУ���룩
	uint16_t humidity;		//ʪ��
	int16_t temperature;	//�¶�
	uint16_t co2;					//������̼Ũ��
	uint16_t crc16;				//16λCRCУ�飨С�˴洢��
}ModBus_Resp_CO2HT_t;//������̼Ũ����ʪ�ȴ�������Ӧ���ݽṹ
__packed typedef struct
{
	uint8_t rs485addr;	//485���ߵ�ַ
	uint8_t funcode;		//modbus������
	uint8_t datasize;		//�������ݳ��ȣ�������CRCУ���룩
	uint16_t humidity;		//ʪ��
	int16_t temperature;	//�¶�
	uint16_t crc16;				//16λCRCУ�飨С�˴洢��
}ModBus_Resp_HT_t;//����ˮ���¶ȴ�������Ӧ���ݽṹ
__packed typedef struct
{
	uint8_t rs485addr;	//485���ߵ�ַ
	uint8_t funcode;		//modbus������
	uint8_t datasize;		//�������ݳ��ȣ�������CRCУ���룩
	uint16_t cond;			//�絼��
	int16_t salt;				//�η�
	uint16_t crc16;				//16λCRCУ�飨С�˴洢��
}ModBus_Resp_CS_t;//�����絼���ηִ�������Ӧ���ݽṹ
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
	SensorType_t type;	//����������
	ModBus_Cmd_Union_t *modbus_cmd;//modbus����ָ��
	uint8_t mb_cmdsize;	//modbus�����
	ModBus_Resp_Union_t * modbus_resp;//modbus��Ӧ����ָ��
	uint8_t mb_respsize;	//modbus��Ӧ���ݳ���
	BOOL_t mb_resp_new;
}Sensor_Handle_t;
/*���ʹ�����Modbus����*/
BOOL_t Modbus_Send_Cmd(Sensor_Handle_t * hs);
/*���մ�����Modbus��Ӧ*/
BOOL_t Modbus_Receive_Resp(Sensor_Handle_t * hs);
/*������Ѳ��*/
void Sensors_Polling(PtrQue_TypeDef * sq);
/*����Ѳ���Ĵ���������*/
void Sens_Data_Proc(PtrQue_TypeDef * sq);
/*���������г�ʼ��*/
void Sensors_Que_Init(PtrQue_TypeDef * sq);
/*��ӡ����������*/
void Sensors_Que_Print(PtrQue_TypeDef * sq);
#endif
