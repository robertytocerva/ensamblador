.MODEL SMALL
.STACK
.DATA
    msg1 db "Numero 1 (0-9): $"
    msg2 db 13,10,"Numero 2 (0-9): $"
    msgR db 13,10,"Resultado: $"

.CODE

; ===================
; MACROS
; ===================

; Imprime un mensaje (recibe como parámetro la etiqueta del mensaje)
IMPRIMIR_MENSAJE MACRO mensaje
    mov ah, 09h
    lea dx, mensaje
    int 21h
ENDM

; Lee un número del teclado (0–9), lo deja en AL
LEER_DIGITO MACRO
    mov ah, 01h
    int 21h
    sub al, '0'
ENDM

; Suma BL + BH, resultado en AL
SUMAR MACRO
    mov al, bl
    add al, bh
ENDM

; Imprime el número en AL (de 0 a 18)
IMPRIMIR_NUMERO MACRO
    push ax
    xor ah, ah
    mov bl, 10
    div bl          ; AL = decenas, AH = unidades

    MOV cl,ah
    cmp al, 0
    je solo_unidad
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

solo_unidad:
    mov ah,cl
    add ah, '0'
    mov dl, ah
    mov ah, 02h
    int 21h

    pop ax
ENDM

; ===================
; MAIN
; ===================

main PROC
    mov ax, @data
    mov ds, ax

    IMPRIMIR_MENSAJE msg1
    LEER_DIGITO
    mov bl, al

    IMPRIMIR_MENSAJE msg2
    LEER_DIGITO
    mov bh, al

    SUMAR

    IMPRIMIR_MENSAJE msgR
    IMPRIMIR_NUMERO

    mov ah, 4Ch
    int 21h
main ENDP

END main