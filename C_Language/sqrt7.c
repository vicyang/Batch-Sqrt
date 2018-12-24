/*
    reference
    https://www.codeproject.com/articles/69941/%2fArticles%2f69941%2fBest-Square-Root-Method-Algorithm-Function-Precisi
*/

#include <stdio.h>
#include <stdlib.h>
float sqrt1(const float x);
float  sqrt2(const float x);
float sqrt3(const float x);
float sqrt4(const float m);
float sqrt5(const float m);
float sqrt7(float x);



int main(int argc, char *argv[] ) 
{
    printf("%f\n", sqrt1(2.0) );
    printf("%f\n", sqrt2(2.0) );
    printf("%f\n", sqrt3(2.0) );
    printf("%f\n", sqrt4(2.0) );
    printf("%f\n", sqrt5(2.0) );
    printf("%f\n", sqrt7(2.0) );
    return 0;
}

float sqrt1(const float x)  
{
  union
  {
    int i;
    float x;
  } u;
  u.x = x;
  u.i = (1<<29) + (u.i >> 1) - (1<<22); 
  
  // Two Babylonian Steps (simplified from:)
  // u.x = 0.5f * (u.x + x/u.x);
  // u.x = 0.5f * (u.x + x/u.x);
  u.x =       u.x + x/u.x;
  u.x = 0.25f*u.x + x/u.x;

  return u.x;
} 

#define SQRT_MAGIC_F 0x5f3759df 
 float  sqrt2(const float x)
{
  const float xhalf = 0.5f*x;
 
  union // get bits for floating value
  {
    float x;
    int i;
  } u;
  u.x = x;
  u.i = SQRT_MAGIC_F - (u.i >> 1);  // gives initial guess y0
  return x*u.x*(1.5f - xhalf*u.x*u.x);// Newton step, repeating increases accuracy 
}   

float sqrt3(const float x)  
{
  union
  {
    int i;
    float x;
  } u;

  u.x = x;
  u.i = (1<<29) + (u.i >> 1) - (1<<22); 
  return u.x;
} 

float sqrt4(const float m)
{
   int i=0; 
   while( (i*i) <= m )
          i++;
    i--; 
   float d = m - i*i; 
 float p=d/(2*i); 
 float a=i+p; 
   return a-(p*p)/(2*a);
}  

float sqrt5(const float m)
{
   float i=0;
   float x1,x2;
   while( (i*i) <= m )
          i+=0.1f;
   x1=i;
   for(int j=0;j<10;j++)
   {
       x2=m;
      x2/=x1;
      x2+=x1;
      x2/=2;
      x1=x2;
   }
   return x2;
}   

float sqrt7(float x)
 {
   unsigned int i = *(unsigned int*) &x; 
   // adjust bias
   i  += 127 << 23;
   // approximation of square root
   i >>= 1; 
   return *(float*) &i;
 } 