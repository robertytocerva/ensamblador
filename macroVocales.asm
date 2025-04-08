.MODEL SMALL
.STACK
.DATA
    cadena db 20 dup (" "),"$"
    num equ $-cadena ; contiene tamaño de la cadena
    msgTotal db 10, 13, "Tiene un total de vocales: $"
    total db 0
    msgBienvenida db 10,13, "Ingresa una cadena de texto: $"



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
    main proc 
        mov ax, @DATA
        mov ds, ax
        
        ; Mostrar mensaje de bienvenida
        mov ah, 09H
        lea dx, msgBienvenida
        int 21h

        ; Leer cadena del usuario
        mov ah, 3fh
        mov bx, 0
        mov cx, 20d
        mov dx, OFFSET [cadena]
        int 21H

        ; Mostrar cadena ingresada
        mov ah, 02H
        mov dl, 10
        int 21h

        mov ah, 09H
        mov dx, OFFSET [cadena]
        int 21h

        ; Llamar al procedimiento para contar vocales
        call contar_vocales_proc
        
        ; Mostrar resultado
        mov ah, 09H
        lea dx, msgTotal
        int 21h

        mov ah, 02h 
        mov dl, total
        add dl, 30h  ; Convertir a ASCII
        int 21h

        ; Terminar programa
        mov ax, 4C00h
        int 21h
    main endp

    ; Procedimiento para contar vocales
    contar_vocales_proc proc
        contar_vocales cadena  ; Usamos la macro
        mov total, al          ; Guardamos el resultado
        ret
    contar_vocales_proc endp

    
    
END main