[BITS 16]
[ORG 0x7C00]

jmp start

; -----------------------------
; Fonte 8x8 (apenas letras A-Z, 32 bytes, simplificado)
font:
    ; Letra A
    db 0x00,0x18,0x24,0x42,0x7E,0x42,0x42,0x00
    ; Letra B
    db 0x00,0x7C,0x42,0x7C,0x42,0x42,0x7C,0x00
    ; ...
    ; Adicione mais letras aqui (32 letras * 8 bytes = 256 bytes)
    times 256 - ($ - font) db 0

; -----------------------------
start:
    ; Entrar no modo gráfico 13h
    mov ax, 0x0013
    int 0x10

    ; Limpar tela
    call cls

    ; Mostrar mensagem
    mov si, msg_hello
    mov di, 0
    call print_string

main_loop:
    ; Esperar tecla
    mov ah, 0x00
    int 0x16
    mov ah, 0x0E
    int 0x10

    ; Salvar caractere na tela (modo gráfico)
    cmp al, 13          ; Enter
    je main_loop
    cmp al, 8           ; Backspace
    je main_loop

    ; Desenhar caractere gráfico
    push ax
    push bx
    push si
    mov ah, 0
    mov si, font
    ; Somente letras maiúsculas por enquanto (A=65)
    sub al, 'A'
    cmp al, 25
    ja skip_char
    mov cx, 8
    mov bx, [cursor_x]
    mov dx, [cursor_y]
draw_loop:
    mov di, si
    add di, ax
    shl di, 3
    add di, cx
    mov al, [font + di - 1]
    call draw_font_line
    loop draw_loop

    ; Atualizar cursor
    add word [cursor_x], 8
    cmp word [cursor_x], 320
    jl skip_char
    mov word [cursor_x], 0
    add word [cursor_y], 8
skip_char:
    pop si
    pop bx
    pop ax
    jmp main_loop

; -----------------------------
draw_font_line:
    ; AL = linha de bits
    ; BX = X
    ; DX = Y
    pusha
    mov cx, 8
draw_bit:
    shl al, 1
    jc draw_pixel
    jmp skip_pixel
draw_pixel:
    mov di, dx
    imul di, 320
    add di, bx
    mov byte [0xA0000 + di], 15
skip_pixel:
    inc bx
    loop draw_bit
    popa
    ret

; -----------------------------
print_string:
    ; SI = ponteiro para string
    ; DI = posição na VRAM (x/y traduzido)
.next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

; -----------------------------
cls:
    mov ax, 0xA000
    mov es, ax
    xor di, di
    mov al, 0
    mov cx, 320*200
    rep stosb
    ret

; -----------------------------
msg_hello: db "KILL OS v0.1", 0

; -----------------------------
cursor_x: dw 0
cursor_y: dw 0

; -----------------------------
times 510-($-$$) db 0
dw 0xAA55
