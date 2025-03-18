; Programa para revertir cadenas y verificar si es un palíndromo
.MODEL SMALL
.STACK
.DATA

    cad1 db 100 dup(' '),"$"  ; Cadena original
    cad2 db 100 dup(' '),"$"  ; Cadena sin espacios para invertir
    cad3 db 100 dup(' '),"$"  ; Cadena invertida con espacios
    conta db 0
    tamcad db 0
    mensaje_si db "Es un palindromo$"
    mensaje_no db "No es un palindromo$"

.CODE

    main proc

        mov ax, @data
        mov ds, ax
        mov es, ax
        
        mov ah, 3fh  ; Leer cadena
        mov bx, 00h  
        mov cx, 100  
        mov dx, offset cad1  
        int 21h

        lea si, [cad1]

    contar:
        mov cl, [si]
        mov dl, 13   ; Enter
        inc [tamcad]
        inc si
        cmp cl, dl
        jne contar

        lea si, [cad1]
        lea di, [cad2]

    copiar:
        mov al, [si]
        mov dl, 13
        cmp al, dl
        je invertir

        mov dl, 20h   ; Espacio
        cmp al, dl
        je guardar_espacio

        mov [di], al  ; Copiar letra en cad2
        inc di
        inc conta

    guardar_espacio:
        inc si
        mov dl, [tamcad]
        cmp dl, [conta]
        jne copiar

    invertir:
        dec di
        lea si, [cad1]
        lea bx, [cad3]
        mov dx, di

    invertir_loop:
        mov al, [si]  
        mov dl, 20h  
        cmp al, dl
        jne copiar_caracter  

        mov [bx], al  
        inc bx
        inc si
        jmp seguir

    copiar_caracter:
        mov al, [di]  
        mov [bx], al  
        dec di        
        inc bx       
        inc si        

    seguir:
        cmp si, dx
        jle invertir_loop

    imprimir:
        mov ah, 02h
        mov dl, 13
        int 21h
        mov ah, 09h
        mov dx, offset cad3
        int 21h

    ; Llamar a función que verifica palíndromo
        call es_palindromo

    salida:
        mov ax, 4c00h
        int 21h          

    ; Función para verificar si la cadena es un palíndromo
    es_palindromo proc
        lea si, [cad2]  ; Cadena original sin espacios
        lea di, [cad3]  ; Cadena invertida sin espacios
        mov cx, conta   ; Número de caracteres a comparar

    comparar:
        mov al, [si]  
        mov bl, [di]  
        cmp al, bl  
        jne no_palindromo  

        inc si  
        inc di  
        loop comparar  

    ; Si sale del bucle sin diferencias, es palíndromo
        mov ah, 09h  
        mov dx, offset mensaje_si  
        int 21h  
        ret  

    no_palindromo:
        mov ah, 09h  
        mov dx, offset mensaje_no  
        int 21h  
        ret  
    es_palindromo endp

    main endp
END
