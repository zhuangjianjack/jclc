#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <string.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <sqlite3.h>
#include "cJSON.h"

#define SERVPORT 6666
#define MAXDATASIZE 512
#define BACKLOG 2

struct SENSOR
{
	int id;
	int type;				
	float data1;
	float data2;
	float data3;
};
struct SW
{
		int id;
		int type;
		int data;
};

int main()
{
	struct SENSOR sensor;
	struct SW sw;
	int sockfd,client_fd;
	int sin_size,ret;
	struct sockaddr_in my_addr,remote_addr;
	char buf[512],data[3],sql[100];
	fd_set rfd_set,wfd_set,efd_set;
	char * errmsg;
	sqlite3 * db = 0;
	ret = sqlite3_open("sfDB.db",&db);
	if(ret != SQLITE_OK)
	{
		printf("open failed!\n");
		sqlite3_close(db);
		return 0;
	}
	if((sockfd = socket(AF_INET,SOCK_STREAM,0)) == -1)
	{
		perror("socket");
		exit(1);
	}
	bzero(&my_addr,sizeof(struct sockaddr_in));
	my_addr.sin_family=AF_INET;
	my_addr.sin_port=htons(SERVPORT);
	inet_aton("127.0.0.1",&my_addr.sin_addr);
	if(bind(sockfd,(struct sockaddr *)&my_addr,sizeof(struct sockaddr)) == -1)
	{
		perror("bind");
		exit(1);
	}
	if(listen(sockfd,BACKLOG) == -1)
	{
		perror("listen");
		exit(1);
	}
	sin_size = sizeof(struct sockaddr_in);
	while(1)
	{
		int result=0,size,dsize;
		if((client_fd = accept(sockfd,(struct sockaddr *)&remote_addr,&sin_size)) == -1)
		{
			perror("accept");
			exit(1);	
		}
		fcntl(client_fd,F_SETFD,O_NONBLOCK);
		int s;
		s=recv(client_fd,buf,MAXDATASIZE,0);
		buf[s-1]='\0';
		printf("%s\n",buf);
		cJSON *json = cJSON_Parse(buf);
		cJSON *node = NULL;
		cJSON *tnode;
		node = cJSON_GetObjectItem(json,"Obj");
		if(node != NULL)
		{
			if(strcmp("Sens",node->valuestring) == 0)
			{
				node = cJSON_GetObjectItem(json,"Num");
				if(node != NULL)
				{
					size = node->valueint;
				}
				cJSON *jsonarray= cJSON_GetObjectItem(json,"Payload");
				cJSON_GetArraySize(jsonarray);
				for(int i=0;i<size;i++)
				{
					node = cJSON_GetArrayItem(jsonarray,i);
					printf("i:%d\n",i);
					if(node != NULL)
					{
						tnode = cJSON_GetObjectItem(node,"ID");
						if(tnode != NULL)
						{
							sensor.id = tnode->valueint;
						}
						tnode = cJSON_GetObjectItem(node,"Type");
						if(tnode != NULL)
						{
							sensor.type = tnode->valueint;
						}
						tnode = cJSON_GetObjectItem(node,"Data");
						if(tnode != NULL)
						{
							dsize = cJSON_GetArraySize(tnode);
							for(int k=0;k<dsize;k++)
							{
								printf("k:%d\n",k);
								cJSON *ttnode = cJSON_GetArrayItem(tnode,k);
								data[k] = ttnode->valuedouble;
							}
						}
						if(sensor.id == 1 || sensor.id == 2)
						{
							sensor.data1 = data[0];
							sensor.data2 = data[1];
							sensor.data3 = data[2];
							sprintf(sql,"insert into sensor(id,type,data1,data2,data3) values(%d,%d,%.1f,%.1f,%.1f);",sensor.id,sensor.type,sensor.data1,sensor.data2,sensor.data3);
							result = sqlite3_exec(db,sql,0,0,&errmsg);
							if(result != SQLITE_OK)
							{		
								printf("insert falied!\n");
							}
						}
						else
						{
							sensor.data1 = data[0];
							sensor.data2 = data[1];
							sprintf(sql,"insert into sensor(id,type,data1,data2) values(%d,%d,%.1f,%.1f);",sensor.id,sensor.type,sensor.data1,sensor.data2);
							result = sqlite3_exec(db,sql,0,0,&errmsg);
							if(result != SQLITE_OK)
							{		
								printf("insert falied!\n");
							}
						}
					}
				}
			}
			if(strcmp("SW",node->valuestring) == 0)
			{
				node = cJSON_GetObjectItem(json,"Num");
				if(node != NULL)
				{
					size = node->valueint;
				}
				cJSON *jsonarray= cJSON_GetObjectItem(json,"Payload");
				for(int i=0;i<size;i++)
				{
					cJSON *node = cJSON_GetArrayItem(jsonarray,i);
					if(node != NULL)
					{
						tnode = cJSON_GetObjectItem(node,"ID");
						if(tnode != NULL)
						{
							sw.id = tnode->valueint;
						}
						tnode = cJSON_GetObjectItem(node,"Type");
						if(tnode != NULL)
						{
							sw.type = tnode->valueint;
						}
						tnode = cJSON_GetObjectItem(node,"Data");
						if(tnode != NULL)
						{
							sw.data = tnode->valueint;
						}
						sprintf(sql,"insert into sw(id,type,data) values(%d,%d,%d);",sw.id,sw.type,sw.data);
						result = sqlite3_exec(db,sql,0,0,&errmsg);
						if(result != SQLITE_OK)
						{
							printf("insert falied!\n");
						}
					}
				}
			}
		}
	}
	close(client_fd);
	sqlite3_close(db);
}




