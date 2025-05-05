.MODEL SMALL
.STACK 
.DATA
    msg1 db 'Ingresa una cadena en lenguaje F: $'
    msg2 db 0Dh,0Ah, 'Cadena en lenguaje F: $'
    msg3 db 0Dh,0Ah, 'Cadena convertida: $'
    msg4 db 0Dh,0Ah, 'Cantidad de vocales:', 0Dh,0Ah, '$'

    msg_a db 'a: $'
    msg_e db 0Dh,0Ah,'e: $'
    msg_i db 0Dh,0Ah,'i: $'
    msg_o db 0Dh,0Ah,'o: $'
    msg_u db 0Dh,0Ah,'u: $'

    cad_original db 100 dup('$')    
    cad_convertida db 100 dup('$')  

    num db 0

    cont_a db 0
    cont_e db 0
    cont_i db 0
    cont_o db 0
    cont_u db 0

.CODE

pedir_cadena PROC
    lea dx, msg1
    mov ah, 9
    int 21h

    lea dx, cad_original
    mov ah, 0Ah
    int 21h

    mov al, cad_original+1
    mov num, al
    ret
pedir_cadena ENDP

mostrar_entrada PROC
    lea dx, msg2
    mov ah, 9
    int 21h

    lea dx, cad_original+2
    mov ah, 9
    int 21h
    ret
mostrar_entrada ENDP

convertir_a_normal PROC
    mov si, 0
    mov di, 0

recorrer:
    mov al, cad_original[si+2]  ; Leer carácter actual
    cmp al, 0Dh
    je fin_convertir

    ; Copiar siempre el carácter actual
    mov cad_convertida[di], al

    ; Verificamos si es vocal
    cmp al, 'a'
    je es_vocal
    cmp al, 'e'
    je es_vocal
    cmp al, 'i'
    je es_vocal
    cmp al, 'o'
    je es_vocal
    cmp al, 'u'
    je es_vocal
    cmp al, 'A'
    je es_vocal
    cmp al, 'E'
    je es_vocal
    cmp al, 'I'
    je es_vocal
    cmp al, 'O'
    je es_vocal
    cmp al, 'U'
    je es_vocal

no_vocal:
    inc si
    inc di
    jmp recorrer

es_vocal:
    
    mov ah, cad_original[si+3] 
    cmp ah, 'f'
    jne no_vocal

    mov ah, cad_original[si+4] 
    cmp ah, al
    jne no_vocal


    add si, 2 
    inc si    
    inc di
    jmp recorrer

fin_convertir:
    mov cad_convertida[di], '$'
    ret
convertir_a_normal ENDP

mostrar_convertida PROC
    lea dx, msg3
    mov ah, 9
    int 21h

    lea dx, cad_convertida
    mov ah, 9
    int 21h
    ret
mostrar_convertida ENDP

contar_vocales_individual PROC
    mov si, 0

contar_loop:
    mov al, cad_convertida[si]
    cmp al, '$'
    je fin_contar

    cmp al, 'a'
    je contar_a
    cmp al, 'A'
    je contar_a
    cmp al, 'e'
    je contar_e
    cmp al, 'E'
    je contar_e
    cmp al, 'i'
    je contar_i
    cmp al, 'I'
    je contar_i
    cmp al, 'o'
    je contar_o
    cmp al, 'O'
    je contar_o
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

siguiente:
    inc si
    jmp contar_loop

fin_contar:
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
    call mostrar_entrada
    call convertir_a_normal
    call mostrar_convertida
    call contar_vocales_individual
    call mostrar_contador_vocales

    mov ah, 4Ch
    int 21h
MAIN ENDP

END MAIN
