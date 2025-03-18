.MODEL SMALL
.STACK 100h
.DATA
    cadena DB 51 DUP('$')   ; Cadena de 50 caracteres + 1 para el carácter de fin de cadena
    mensajeMenu DB '1. Ingresar cadena', 13, 10
                DB '2. Buscar caracter en posicion', 13, 10
                DB '3. Recorrer y mostrar cadena', 13, 10
                DB '4. Limpiar cadena', 13, 10
                DB '5. Cambiar cadena', 13, 10
                DB '6. Salir', 13, 10, '$'
    mensajeIngrese DB 13, 10,  'Ingrese la cadena (max 50 caracteres): $'
    mensajeBuscar DB 13, 10,  'Ingrese el caracter a buscar: $'
    mensajePosicion DB 13, 10, 'Ingrese la posicion a buscar (0-49): $'
    mensajeEncontrado DB 13, 10, 'Caracter encontrado en la posicion!$'
    mensajeNoEncontrado DB 13, 10, 'Caracter no encontrado en la posicion$'
    mensajeLimpieza DB 13, 10, 'Cadena limpiada!$'
    mensajeCambio DB 13, 10, 'Cadena cambiada!$'
    mensajeOpcionInvalida DB 13, 10, 'Opcion invalida!$'
    saltoLinea DB 13, 10, '$'
    caracterBuscar DB ?     ; Almacena el caracter a buscar
    posicion DB ?          ; Almacena la posición a buscar

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

MENU:
    ; Mostrar menú
    MOV DX, OFFSET mensajeMenu
    MOV AH, 09h
    INT 21h

    ; Leer opción
    MOV AH, 01h
    INT 21h
    CMP AL, '1'
    JE INGRESAR_CADENA
    CMP AL, '2'
    JE BUSCAR_CARACTER_POSICION
    CMP AL, '3'
    JE RECORRER_CADENA
    CMP AL, '4'
    JE LIMPIAR_CADENA
    CMP AL, '5'
    JE puente1
    CMP AL, '6'
    JE puente2

    ; Opción inválida
    MOV DX, OFFSET mensajeOpcionInvalida
    MOV AH, 09h
    INT 21h
    JMP MENU

INGRESAR_CADENA:
    MOV DX, OFFSET mensajeIngrese
    MOV AH, 09h
    INT 21h

    MOV DX, OFFSET cadena
    MOV AH, 0Ah
    INT 21h
    JMP MENU

LIMPIAR_CADENA:
    MOV SI, OFFSET cadena
    MOV CX, 51
LIMPIAR_LOOP:
    MOV BYTE PTR [SI], '$'
    INC SI
    LOOP LIMPIAR_LOOP

    MOV DX, OFFSET mensajeLimpieza
    MOV AH, 09h
    INT 21h
    JMP MENU

    RECORRER_CADENA:
    MOV SI, OFFSET cadena + 1  ; Saltar el byte de longitud
    MOV CX, 50
MOSTRAR_LOOP:
    MOV DL, [SI]
    CMP DL, '$'
    JE FIN_MOSTRAR
    MOV AH, 02h
    INT 21h
    INC SI
    LOOP MOSTRAR_LOOP
FIN_MOSTRAR:
    JMP MENU

puente1:
jmp CAMBIAR_CADENA
puente2:
jmp SALIR

BUSCAR_CARACTER_POSICION:
    MOV DX, OFFSET mensajeBuscar
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h
    MOV caracterBuscar, AL

    MOV DX, OFFSET mensajePosicion
    MOV AH, 09h
    INT 21h

    MOV AH, 01h
    INT 21h
    SUB AL, '0'  ; Convertir ASCII a número
    MOV posicion, AL

    ; Verificar si la posición está dentro del rango válido
    MOV SI, OFFSET cadena + 1  ; Saltar el byte de longitud
    MOV CL, [SI - 1]           ; Obtener la longitud de la cadena
    CMP posicion, CL
    JAE NO_ENCONTRADO_POSICION ; Si la posición es mayor o igual a la longitud, no encontrado

    ; Buscar en la posición específica
    ADD SI, posicion
    MOV AL, [SI]
    CMP AL, caracterBuscar
    JE ENCONTRADO_POSICION

NO_ENCONTRADO_POSICION:
    MOV DX, OFFSET mensajeNoEncontrado
    MOV AH, 09h
    INT 21h
    JMP MENU

ENCONTRADO_POSICION:
    MOV DX, OFFSET mensajeEncontrado
    MOV AH, 09h
    INT 21h
    JMP MENU

CAMBIAR_CADENA:
    MOV DX, OFFSET mensajeCambio
    MOV AH, 09h
    INT 21h
    JMP INGRESAR_CADENA

SALIR:
    MOV AX, 4C00h
    INT 21h

END START