.model SMALL
.STACK
.data
    arr db 5 dup(' '),"$";arreglo que guarda datos
    m1 db 10,"Ingrese los caratecteres que se almacenanenan la pila : ",10,"$"
    m2 db 10,"Los elementos en la pila al reves son : ",10,"$"
    m3 db 10,"Los elementos en la pila en orden son : ",10,"$"
.code 
    mov ax,@data
    mov ds,ax
    mov cl,4
    mov ah, 09h
    mov dx, offset m1
    int 21h

    ingresar:
        mov ah, 01h;para ingresar caracteres
        int 21h
        push ax;meter a la pila de ax la teña que se ingreso
    loop ingresar

    mov ah, 09h
    mov dx, offset m2 ;mensaje2
    int 21h

    mov cl,04;iniciamos el contador para que se repita n veces el 
    mov si,03h;moevemos a si para inicializarla para tomar la posicion de la pila

    sacar:
        pop ax; sacamos el valor de la pila y se almacena en ax

        mov ah,02h ;impresion de caracter
        mov dl,al;movemos a dl para imprimir 
        int 21h
        mov arr[si],al;guardamos el valor de al en el arreglo   
        dec si;decrementamos si para que tome la siguiente posicion
    loop sacar

    mov ah, 09h
    mov dx, offset m3 ;mensaje3
    int 21h

    mostrar:
        mov ah,09h
        mov dx,offset arr
        int 21h

    salir:
        mov ax,4c00h
        int 21h
end  