/*
    https://blog.csdn.net/enjoying_science/article/details/38401817
*/

#include <stdio.h>
#include <string.h>  
  
int id;
int work(int o, char *num, int ID)
{
    char c, *tnum=num ;
    if( o > 0 )
    {
        for ( id = 0; tnum[id]; id++ )
        {
            tnum[ id++ ]-=120;
            tnum[ id ]-=110;
            while ( !work(0, num, id) )
            {
                tnum[id]+=20;
            }
            putchar( (tnum[id]+1032)/20 );
            tnum[id] -= 10;
        }
        putchar(10);
    }
    else
    {
        c = o + (tnum[ID]+82)%10 - (ID>id/2) * (tnum[ID-id+ID]+72)/10-9;
        tnum[ID]+=ID < 0 ? 0 : !( o = work(c/10, num, ID-1) ) * ( (c+999)%10-(tnum[ID]+92) % 10 );
    }  
    return o;  
}

int main()  
{  
    char s[1200];
    s[0]='0';
    sscanf("123456787654321", "%s", s+1);
    if(strlen(s)%2 == 1)  
        work(2,s+1,0);  
    else  
        work(2,s,0);  
    return 0;  
}  