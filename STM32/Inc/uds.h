#ifndef __UDS_H_
#define __UDS_H_
#define  QUESIZE 20
#define  PTRQUESIZE 7
//��ȡ�������ݸ���
#define __QUE_COUNT(PQUE) (((PQUE)->rear - (PQUE)->front + QUESIZE) % QUESIZE)
//��ȡ�������������ݸ���
#define __PTRQUE_COUNT(PQUE) (((PQUE)->rear - (PQUE)->front + PTRQUESIZE) % PTRQUESIZE)
typedef struct {
  uint8_t data[QUESIZE];
  uint8_t front;
  uint8_t rear;
}CircleQue_TypeDef;//֧�ֲ�ѯ��ͷ��ѭ���ֽڶ��У�����ʱ��Ӹ��Ǿ�����

void Que_Init(CircleQue_TypeDef * pq);
BOOL_t Que_In(CircleQue_TypeDef * pq, uint8_t c);
BOOL_t Que_Out(CircleQue_TypeDef * pq, uint8_t *c);
BOOL_t Que_Query(CircleQue_TypeDef * pq, uint8_t *c);

typedef struct {
  void * data[PTRQUESIZE];
  uint8_t front;//ͷָ��
  uint8_t rear;//βָ��
	uint8_t current;//��ǰ����ָ�루���ڲ�ѯ������
}PtrQue_TypeDef;//֧�ֱ�����ѯ��ѭ��ָ����У�����ʱ���������

void PtrQue_Init(PtrQue_TypeDef * pq);
BOOL_t PtrQue_In(PtrQue_TypeDef * pq, void * psh);
BOOL_t PtrQue_Out(PtrQue_TypeDef * pq, void ** ppsh);
BOOL_t PtrQue_Query(PtrQue_TypeDef * pq, void ** ppsh);

#endif
