.MODEL SMALL
.STACK 100H
.DATA
    msg1 DB 'Ingrese el numero de iteraciones (1-11): $'
    msg2 DB 10, 13, 'Serie de Fibonacci: $'
    space DB ' $'
    iterations DB ?
    num1 DW 0
    num2 DW 1
    result DW ?
    buffer DB 6, ?, 6 DUP('$')  ; Buffer para entrada de usuario
    error_msg DB 10, 13, 'Numero debe estar entre 1 y 11!$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Mostrar mensaje para pedir iteraciones
    MOV AH, 09H
    LEA DX, msg1
    INT 21H
    
    ; Leer entrada del usuario
    MOV AH, 0AH
    LEA DX, buffer
    INT 21H
    
    ; Convertir entrada a número
    MOV SI, OFFSET buffer + 2
    CALL ASCII_TO_NUM
    MOV iterations, AL
    
    ; Validar que esté entre 1 y 11
    CMP AL, 1
    JL inp     ; Cambiamos FIN por INVALIDO (más cercano)
    CMP AL, 54
    JG inp     ; Cambiamos FIN por INVALIDO (más cercano)
    
    ; Mostrar mensaje de la serie
    MOV AH, 09H
    LEA DX, msg2
    INT 21H
    
    ; Inicializar variables para Fibonacci
    MOV CX, 0
    MOV CL, iterations
    MOV num1, 0
    MOV num2, 1
    
    ; Mostrar los primeros dos números si es necesario
    CMP CL, 1
    JE MOSTRAR_PRIMERO
    CMP CL, 2
    JE MOSTRAR_PRIMEROS_DOS
    
    ; Mostrar los primeros dos números
    MOV AX, num1
    CALL PRINT_NUM
    MOV AH, 09H
    LEA DX, space
    INT 21H
    
    MOV AX, num2
    CALL PRINT_NUM
    MOV AH, 09H
    LEA DX, space
    INT 21H
    
    ; Calcular y mostrar los siguientes números
    SUB CL, 2
CALCULAR_FIB:
    MOV AX, num1
    ADD AX, num2
    MOV result, AX
    
    ; Mostrar el número
    CALL PRINT_NUM
    MOV AH, 09H
    LEA DX, space
    INT 21H
    
    ; Actualizar variables para siguiente iteración
    MOV AX, num2
    MOV num1, AX
    MOV AX, result
    MOV num2, AX
    
    LOOP CALCULAR_FIB
    JMP FIN
inp:
jmp INVALIDO  
MOSTRAR_PRIMERO:
    MOV AX, num1
    CALL PRINT_NUM
    JMP FIN
    
MOSTRAR_PRIMEROS_DOS:
    MOV AX, num1
    CALL PRINT_NUM
    MOV AH, 09H
    LEA DX, space
    INT 21H
    
    MOV AX, num2
    CALL PRINT_NUM
    JMP FIN
    
INVALIDO:
    MOV AH, 09H
    LEA DX, error_msg
    INT 21H
    
FIN:
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Subrutina para convertir ASCII a número
ASCII_TO_NUM PROC
    XOR AX, AX
    XOR BX, BX
    
CONVERTIR:
    MOV BL, [SI]
    CMP BL, 0DH     ; Verificar si es fin de línea
    JE FIN_CONVERSION
    
    SUB BL, '0'     ; Convertir ASCII a número
    MOV DX, 10
    MUL DX          ; AX = AX * 10
    ADD AX, BX      ; AX = AX + dígito
    
    INC SI
    JMP CONVERTIR
    
FIN_CONVERSION:
    RET
ASCII_TO_NUM ENDP

; Subrutina para imprimir número en AX
PRINT_NUM PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV CX, 0       ; Contador de dígitos
    MOV BX, 10      ; Divisor
    
    ; Extraer dígitos y guardarlos en la pila
EXTRAER_DIGITOS:
    XOR DX, DX
    DIV BX          ; DX:AX / BX
    PUSH DX         ; Guardar residuo (dígito)
    INC CX
    
    CMP AX, 0
    JNE EXTRAER_DIGITOS
    
    ; Imprimir dígitos
IMPRIMIR_DIGITOS:
    POP DX
    ADD DL, '0'     ; Convertir a ASCII
    MOV AH, 02H
    INT 21H
    
    LOOP IMPRIMIR_DIGITOS
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM ENDP
;comentario para enseñarle a mi novia Nadia <3
END MAIN