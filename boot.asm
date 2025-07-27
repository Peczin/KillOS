; boot.asm
[org 0x7C00]
[bits 16]

start:
    ; Modo texto: mostrar "K"
    mov ah, 0x0E
    mov al, 'K'
    int 0x10

    ; Mudar para modo gráfico 13h (320x200, 256 cores)
    mov ax, 0x0013
    int 0x10

    ; Definir segmento da VRAM (A000:0000)
    mov ax, 0xA000
    mov es, ax

    ; Desenhar 1 pixel branco no offset 100
    mov di, 100
    mov al, 0x0F
    stosb

    ; Obs: os próximos int 10h não funcionam no modo gráfico
    ;     portanto, não é possível imprimir texto com int 10h/0Eh aqui.
    ;     Você precisará desenhar fontes manualmente na VRAM.

    ; Carregar o segundo setor (setor 2) da imagem para 0x1000
    mov ah, 0x02      ; função: ler setores
    mov al, 1         ; número de setores
    mov ch, 0         ; cilindro 0
    mov cl, 2         ; setor 2 (1 = boot, 2 = kernel)
    mov dh, 0         ; cabeça 0
    mov dl, 0x00      ; drive 0 (disquete ou imagem)
    mov bx, 0x1000    ; destino da leitura
    int 0x13

    ; Ir para o código carregado (kernel gráfico)
    jmp 0x0000:0x1000

    ; Preencher até 510 bytes
    times 510 - ($ - $$) db 0
    dw 0xAA55          ; Assinatura de boot
