.MODEL SMALL
.STACK 

.DATA
    msg1 DB 10,13,'Ingrese el primer numero (1-3 digitos): $'
    msg2 DB 10,13,'Ingrese el segundo numero (1-3 digitos): $'
    msg3 DB 10,13,'Seleccione la operacion (+, -, *, /): $'
    msg4 DB 10,13,'El resultado es: $'
    msg5 DB 10,13,'Error: Division por cero!$'
    msg6 DB 10,13,'Presione ESC para salir o cualquier otra tecla para continuar...$'
    msg7 DB 10,13,'¿Desea salir? (S/N): $'
    msg8 DB 10,13,'Error: Caracter no valido. Intente de nuevo.$'
    num1 DW ?
    num2 DW ?
    result DW ?
    remainder DW ?
    op DB ?

.CODE
    ; Macro para imprimir un mensaje
    PRINT_MSG MACRO msg
        MOV AH, 09H
        LEA DX, msg
        INT 21H
    ENDM

    ; Macro para leer un número de 1-3 dígitos con validación
    READ_NUM MACRO num
        LOCAL read_loop, done, invalid_input
        MOV num, 0
    read_loop:
        MOV AH, 01H
        INT 21H
        CMP AL, 0DH ; Verificar si es Enter
        JE done
        CMP AL, '0' ; Verificar si es menor que '0'
        JB invalid_input
        CMP AL, '9' ; Verificar si es mayor que '9'
        JA invalid_input
        SUB AL, '0' ; Convertir a número
        MOV BL, AL
        MOV AX, num
        MOV DX, 10
        MUL DX
        ADD AX, BX
        MOV num, AX
        JMP read_loop
    invalid_input:
        PRINT_MSG msg8 ; Mostrar mensaje de error
        MOV num, 0 ; Reiniciar el número
        JMP read_loop ; Volver a pedir la entrada
    done:
    ENDM

    ; Macro para imprimir un número
    PRINT_NUM MACRO num
        LOCAL print_loop, print_digit
        MOV AX, num
        MOV CX, 0
        MOV BX, 10
    print_loop:
        XOR DX, DX
        DIV BX
        PUSH DX
        INC CX
        CMP AX, 0
        JNE print_loop
    print_digit:
        POP DX
        ADD DL, '0'
        MOV AH, 02H
        INT 21H
        LOOP print_digit
    ENDM

    ; Macro para sumar
    SUMAR MACRO num1, num2, result
        MOV AX, num1
        ADD AX, num2
        MOV result, AX
    ENDM

    ; Macro para restar
    RESTAR MACRO num1, num2, result
        MOV AX, num1
        SUB AX, num2
        MOV result, AX
    ENDM

    ; Macro para multiplicar
    MULTIPLICAR MACRO num1, num2, result
        MOV AX, num1
        IMUL num2
        MOV result, AX
    ENDM

    ; Macro para dividir (con parte decimal)
    DIVIDIR MACRO num1, num2, result, remainder
        MOV AX, num1
        CWD
        IDIV num2
        MOV result, AX
        MOV remainder, DX
    ENDM
;NADAIA
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

main_loop:
    ; Leer el primer número con validación
    PRINT_MSG msg1
    READ_NUM num1

    ; Leer el segundo número con validación
    PRINT_MSG msg2
    READ_NUM num2

    ; Leer la operación con validación
leer_operacion:
    PRINT_MSG msg3
    MOV AH, 01H
    INT 21H
    CMP AL, '+'
    JE operacion_valida
    CMP AL, '-'
    JE operacion_valida
    CMP AL, '*'
    JE operacion_valida
    CMP AL, '/'
    JE operacion_valida
    ; Si no es una operación válida, mostrar error y volver a pedir
    PRINT_MSG msg8
    JMP leer_operacion
operacion_valida:
    MOV op, AL

    ; Realizar la operación seleccionada
    CMP op, '+'
    JE suma
    CMP op, '-'
    JE resta
    CMP op, '*'
    JE multiplicacion
    CMP op, '/'
    JE division
    JMP fin

suma:
    SUMAR num1, num2, result
    JMP mostrar_resultado

resta:
    RESTAR num1, num2, result
    JMP mostrar_resultado

multiplicacion:
    MULTIPLICAR num1, num2, result
    JMP mostrar_resultado

division:
    CMP num2, 0
    JE error_division
    DIVIDIR num1, num2, result, remainder
    JMP mostrar_division

error_division:
    PRINT_MSG msg5
    JMP fin

mostrar_resultado:
    PRINT_MSG msg4
    PRINT_NUM result
    JMP preguntar_continuar

mostrar_division:
    PRINT_MSG msg4
    PRINT_NUM result
    ; Mostrar el punto decimal
    MOV AH, 02H
    MOV DL, '.'
    INT 21H
    ; Calcular y mostrar un solo dígito decimal
    MOV AX, remainder
    MOV BX, 10
    MUL BX
    IDIV num2
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    JMP preguntar_continuar

preguntar_continuar:
    PRINT_MSG msg6
    MOV AH, 01H
    INT 21H
    CMP AL, 1BH ; 1BH es el código ASCII para ESC
    JE preguntar_salir
    JMP main_loop

preguntar_salir:
    PRINT_MSG msg7
    MOV AH, 01H
    INT 21H
    CMP AL, 'S'
    JE fin
    CMP AL, 's'
    JE fin
    JMP main_loop

fin:
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN