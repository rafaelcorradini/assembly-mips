    .data
    .align 0

str_hello: .asciiz "Hello World++"

str_hello_n: .asciiz "Hello World--"

    .text
    .align 2
    .globl main

main: 
    li $v0, 5
    syscall
    move $t2, $v0

    beq $t2, 0, end
    bge $t2, 0, negative

    li $v0, 4
    la $a0, str_hello
    syscall

    j main

negative:
    li $v0, 4
    la $a0, str_hello_n
    syscall

    j main

end:
    li $v0, 10
    syscall    