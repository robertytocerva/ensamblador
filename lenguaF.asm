.MODEL SMALL
.STACK 
.DATA
    msg1 db 'Ingresa una cadena: $'
    msg2 db 0Dh,0Ah, 'Cadena original: $'
    msg3 db 0Dh,0Ah, 'Cadena en lenguaje F: $'
    msg4 db 0Dh,0Ah, 'Cantidad de vocales:', 0Dh,0Ah, '$'
    msg_a db 'a: $'
    msg_e db 0Dh,0Ah,'e: $'
    msg_i db 0Dh,0Ah,'i: $'
    msg_o db 0Dh,0Ah,'o: $'
    msg_u db 0Dh,0Ah,'u: $'

    cad_original db 100 dup('$')
    cad_lenguajeF db 300 dup('$')

    num db 0 ; 

    cont_a db 0
    cont_e db 0
    cont_i db 0
    cont_o db 0
    cont_u db 0

.CODE


contar_vocales MACRO cad
    LOCAL ciclo, va, regresa
    push si
    push cx
    mov si, 0
    mov cx, num
    mov al, 0
    
    ciclo:
        mov ah, cad[si]
        cmp ah, 97d    ; 'a'
        je va
        cmp ah, 101d   ; 'e'
        je va
        cmp ah, 105d   ; 'i'
        je va
        cmp ah, 111d   ; 'o'
        je va
        cmp ah, 117d   ; 'u'
        je va
        cmp ah, 'A'
        je va
        cmp ah, 'E'
        je va
        cmp ah, 'I'
        je va
        cmp ah, 'O'
        je va
        cmp ah, 'U'
        je va

    regresa:
        inc si
        loop ciclo
        jmp fin_macro
        
    va:
        inc al
        jmp regresa
        
    fin_macro:
    pop cx
    pop si
ENDM



pedir_cadena PROC
    ; Mostrar mensaje
    lea dx, msg1
    mov ah, 9
    int 21h

    ; Leer cadena
    lea dx, cad_original
    mov ah, 0Ah
    int 21h

    ; Guardar longitud
    mov al, cad_original+1
    mov num, al
    ret
pedir_cadena ENDP

mostrar_cadena PROC
    lea dx, msg2
    mov ah, 9
    int 21h

    ; Mostrar la cadena
    lea dx, cad_original+2
    mov ah, 9
    int 21h
    ret
mostrar_cadena ENDP

convertir_lenguajeF PROC
    mov si, 0
    mov di, 0

inicio_convertir:
    mov al, cad_original[si+2]
    cmp al, 0Dh
    je fin_convertir

    ; Copiar caracter
    mov cad_lenguajeF[di], al
    inc di


    cmp al, 'a'
    je insertar_f
    cmp al, 'e'
    je insertar_f
    cmp al, 'i'
    je insertar_f
    cmp al, 'o'
    je insertar_f
    cmp al, 'u'
    je insertar_f
    cmp al, 'A'
    je insertar_f
    cmp al, 'E'
    je insertar_f
    cmp al, 'I'
    je insertar_f
    cmp al, 'O'
    je insertar_f
    cmp al, 'U'
    je insertar_f
    jmp continuar

insertar_f:
    
    mov cad_lenguajeF[di], 'f'
    inc di
    
    mov cad_lenguajeF[di], al
    inc di

continuar:
    inc si
    jmp inicio_convertir

fin_convertir:
    mov cad_lenguajeF[di], '$' 
    ret
convertir_lenguajeF ENDP

mostrar_lenguajeF PROC
    ; Mostrar mensaje
    lea dx, msg3
    mov ah, 9
    int 21h

    ; Mostrar cadena transformada
    lea dx, cad_lenguajeF
    mov ah, 9
    int 21h
    ret
mostrar_lenguajeF ENDP

contar_vocales_individual PROC
    mov si, 0
    mov cx, num

contar_loop:
    mov al, cad_original[si+2]

    ; Comparar 'a' o 'A'
    cmp al, 'a'
    je contar_a
    cmp al, 'A'
    je contar_a

    ; Comparar 'e' o 'E'
    cmp al, 'e'
    je contar_e
    cmp al, 'E'
    je contar_e

    ; Comparar 'i' o 'I'
    cmp al, 'i'
    je contar_i
    cmp al, 'I'
    je contar_i

    ; Comparar 'o' o 'O'
    cmp al, 'o'
    je contar_o
    cmp al, 'O'
    je contar_o

    ; Comparar 'u' o 'U'
    cmp al, 'u'
    je contar_u
    cmp al, 'U'
    je contar_u

    jmp siguiente

contar_a:
    inc cont_a
    jmp siguiente

contar_e:
    inc cont_e
    jmp siguiente

contar_i:
    inc cont_i
    jmp siguiente

contar_o:
    inc cont_o
    jmp siguiente

contar_u:
    inc cont_u
    jmp siguiente

siguiente:
    inc si
    loop contar_loop
    ret
contar_vocales_individual ENDP

mostrar_contador_vocales PROC
    lea dx, msg4
    mov ah, 9
    int 21h

    lea dx, msg_a
    mov ah, 9
    int 21h
    mov dl, cont_a
    add dl, '0'
    mov ah, 2
    int 21h

    lea dx, msg_e
    mov ah, 9
    int 21h
    mov dl, cont_e
    add dl, '0'
    mov ah, 2
    int 21h

    lea dx, msg_i
    mov ah, 9
    int 21h
    mov dl, cont_i
    add dl, '0'
    mov ah, 2
    int 21h

    lea dx, msg_o
    mov ah, 9
    int 21h
    mov dl, cont_o
    add dl, '0'
    mov ah, 2
    int 21h

    lea dx, msg_u
    mov ah, 9
    int 21h
    mov dl, cont_u
    add dl, '0'
    mov ah, 2
    int 21h

    ret
mostrar_contador_vocales ENDP

MAIN PROC
    mov ax, @DATA
    mov ds, ax

    call pedir_cadena
    call mostrar_cadena
    call convertir_lenguajeF
    call mostrar_lenguajeF
    call contar_vocales_individual
    call mostrar_contador_vocales

    ; Terminar programa
    mov ah, 4Ch
    int 21h
MAIN ENDP

END MAIN
