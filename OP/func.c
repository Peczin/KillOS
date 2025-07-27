
#include <locale.h>
int main(){
  setlocale(LC_ALL, "Portuguse");
  int f = 0x0F;
  printv("%i", f);
  return 0;
  


}



void _limpar(){
  char* clear = (char*)0xa;
  clear[0] = 0x0F;
  clear[1] = 0x0A;
}

