org 0x7C00

start:
    ; entra no modo gráfico 13h
    mov ax, 0x13
    int 0x10

    ; configura ES = A000h (VRAM do modo 13h)
    mov ax, 0xA000
    mov es, ax
    xor di, di      ; posição inicial

    mov cx, 64000   ; 320x200 pixels
    mov al, 0x1E    ; cor (qualquer uma visível)

.loop:
    stosb
    loop .loop

hang:
    jmp hang

times 510 - ($ - $$) db 0
dw 0xAA55
