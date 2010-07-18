/* Ггг. Совсем нехуй делать

#include <windows.h>
#include <iostream>
using namespace std;
#pragma comment (lib, "ws2_32.lib")
const int bs=500*1024;
#define cb() memset(b,0,bs)
#define ln "\n----------------------------------------------------------------------"
#define se( X ) {sprintf_s(b,bs,"%s%s%s%s%s","<html><head><title>",X,\
"</title></head><body><center><b><span style=\"font-size:404px;\">",X,\
"</span></b></center></body></html>" );send(a,b,(int)strlen(b),0);closesocket(a);return 0;}
DWORD WINAPI r(LPVOID g){SOCKET a=*((SOCKET*)(g));CHAR b[bs];cb();recv(a,b,bs,0);cout<<b<<ln;CHAR
s[1024];memset(s,0,1024);if(b[0]!='G'||b[1]!='E'||b[2]!='T')se("400");for(int i=5,j=0;b[i]!=' ';j++)
{if(b[i]=='%'){for(int k=1;k<3;k++){s[j]*=16;if(b[i+k]>='0'&&b[i+k]<='9')s[j]+=b[i+k]-'0';else if(b
[i+k]>='a'&&b[i+k]<='f')s[j]+=b[i+k]-'a'+10;else if(b[i+k]>='A'&&b[i+k]<='F')s[j]+=b[i+k]-'A'+10;else
{s[j]='%';i-=2;break;}}i+=3;}else s[j]=b[i++];}if(!s[0])sprintf_s(s,1024,"%s","index.html");if(strstr
(s,"\\")||s[0]=='/')se("404");cb();FILE *f;if(fopen_s(&f,s,"rb"))se("404")else{while(!feof(f)){cb();
int m=(int)fread(b,1,bs,f);for(int n=0;n<m;)n+=send(a,&b[n],m-n,0);}fclose(f);}closesocket(a);
return 0;}WSADATA wd;SOCKET ls;void e(char* text){printf("%s%s","Error: ",text);getchar();exit(1);}
int main(){ printf( "%s%s", "starting httpalivo 0.2", ln );if(WSAStartup(MAKEWORD(2,0),&wd))
e("WSAStartup");if((ls=socket(PF_INET,SOCK_STREAM,0))==INVALID_SOCKET)e(
"Failed to create listening socket");SOCKADDR_IN c;memset(&c,0,sizeof(SOCKADDR_IN));c.sin_family=
AF_INET;c.sin_port=htons(80);c.sin_addr.s_addr=inet_addr("0.0.0.0");if(bind(ls,(SOCKADDR*)&c,sizeof(
SOCKADDR_IN)))e("Failed to bind listening socket");if(listen(ls,10))e("listen() error");SOCKADDR_IN
ca;SOCKET cs;INT x=sizeof(SOCKADDR_IN);while(1){cs=accept(ls,(SOCKADDR*)&ca,&x);if(cs!=INVALID_SOCKET)
CreateThread(NULL,0,r,(void*)&cs,0,NULL);else printf("Warning: accept() failed\n");}return 0;}

/*/