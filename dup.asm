.MODEL
.STACK
.DATA
    cadena db 20 dup (" "),"$"
    num equ $-cadena ;ontine tamaño de la cadena
    msgTotal db 10, 13, "Tiene un total de vocales: $"
    total db 0
    msgBienvenida db 10,13, "Ingresa una cadena de texto: $"
.CODE

    main proc 
    mov ax, @DATA
    mov ds, AX
    

    ;mensaje bindvenida
    mov ah,09H
    lea dx,msgBienvenida
    int 21h

    mov ah, 3fh
    mov bx,0
    mov cx,20d
    mov dx, OFFSET[cadena]
    int 21H

    mov ah,02H
    mov dl,10
    int 21h

    mov ah,09H
    mov dx,OFFSET[cadena]
    int 21h

    mov si,0
    mov dx,0h  
    mov cx,num

    ciclo:
        mov al, cadena[si];mueve la posicion del arrglo
        cmp al, 97d
        je va
        cmp al, 101d
        je va
        cmp al, 105d
        je va
        cmp al, 111d
        je va
        cmp al, 117d
        je va
        cmp al, 'A'
        je va
        cmp al, 'E'
        je va
        cmp al, 'I'
        je va
        cmp al, 'O'
        je va
        cmp al, 'U'
        je va

        regresa:
            inc si 
            loop ciclo
            jmp imprimir
        va:
            inc total
            jmp regresa
        imprimir:
            mov al,total
            aam
            mov bx,ax
            add bx,3030h

            mov ah,09H
            lea dx,msgTotal
            int 21h

            mov ah, 02h 
            mov dl,bl
            int 21h

            jmp fin

        fin:
            int 27h

    main endp

    
END main