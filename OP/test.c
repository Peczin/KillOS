
void _start(void){
  char* video = (char*)0xA8000;
  video[0] = 0x0F;
  video[1] = 0x41;
}
