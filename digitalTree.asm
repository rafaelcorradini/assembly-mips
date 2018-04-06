   .data
theString: .space 64 #aloca 64bytes para a string de entrada
rootAdress: .space 32
rootLabel: .asciiz "root"
NT_Label: .asciiz "NT"
T_Label: .asciiz "T"
newLine: .asciiz "\n------\n" 
newLines: .asciiz "\nNew Input\n"
menuPrint: .asciiz "\n1 - Insercao \n2 - Remocao \n3 - Busca \n4 - Visualizacao\n5 - Fim\n"
teste: .asciiz "teste--------------------------------------------"
virgula: .asciiz ","
 
zero: .asciiz "0"
um: .asciiz "1"

barran: .asciiz "\n"
b1: .asciiz "("
b2: .asciiz ")"

raiz: .asciiz "raiz"
null: .asciiz "null"

te: .asciiz "T"
    
    .text

#Usage: for now as we start the program the

main:
	## Step 1: create the root node.
	## root = tree_node_create ($s2, 0, 0);
	
	la $a0, rootLabel
	li $a1, 0 # left = NULL
	li $a2, 0 # right = NULL
	jal tree_node_create # call tree_node_create to creat de root node
	move $s0, $v0 # and put the result into $s0, wich is the adress for the root node/
	move $a3, $s0 #move the root adress to a0
	
menu:	
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, menuPrint #carrega o endereço de str_data_entering para o a0
	syscall #chamada de sistema para E/S
	
	li $v0, 5 #codigo para leitura de int
	syscall
	move $t1, $v0
	
	beq $t1, 1, input_loop
	beq $t1, 2, remove
	beq $t1, 3, input_loop
	beq $t1, 4, menu_to_print
	beq $t1, 5, exit

input_loop:
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, newLines #carrega o endereço de str_data_entering para o a0
	syscall #chamada de sistema para E/S
	
	li      $v0, 8 #codigo para leitura de string
	la      $a0, theString #atribui o endereço de theString para a0
	li      $a1, 64 #numero maximo de bytes qye pode contar a string
	syscall
	
	la $t1, theString #load the adress of a input string
	
	#move $a3, $s0 #move the root adress to a0
	jal insert_node
	
	j menu
	#li $v0, 11 # atribui 4 para v0 (codigo para printar string)
	#move $a0, $t2 #carrega o endereço de str_data_entering para o a0
	#syscall #chamada de sistema para E/S
	
	#add $t1,$t1,1 
	#j input_loop


menu_to_print:
	move $s0, $a3	
	jal Print_em_ordem_de_nivel
	j menu
	
	
insert_node:
	
	#set stack fram
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	addu $fp, $sp, 32
	
	move  $s0, $a3 #put rootAdress (a0) to s0
	
	
	
search_loop:
	lb  $t2, ($t1)	  #get the first bit
	beq $t2, '\0', input_loop #checks for the end of the string
	beq $t2, '-', end_insertion #check for the caracer to leave the insertion
	beq $t2, '0' go_left #go to insert left rotine
	beq  $t2, '1' , go_right  #got to insert right rotine
	add $t1,$t1,1 #this is done like this brcause of the null terminator
	j search_loop #got search_loop
	
go_left:
	
	li $v0, 1 #just a debug tes (can exclude but it can be usefull to the print trie rotine)
	li $a0, 0 #just a debug tes (can exclude but it can be usefull to the print trie rotine)
	syscall #just a debug tes (can exclude but it can be usefull to the print trie rotine)
	lw $s1, 4($s0) #load the content of $so + 4 to $s1
	beqz $s1, add_left #if the adress is null, start the creat_node rotine
	move $s0, $s1 
	add $t1,$t1,1 
	j search_loop
		
add_left:
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, newLine#carrega o endereço de str_data_entering para o a0
	syscall #chamada de sistema para E/S
	add $t1,$t1,1
	lb  $t2, ($t1)	  #get the first bit
	la $a0, NT_Label
	beq $t2, '0' add_left_aux #go to insert left rotine
	beq  $t2, '1' , add_left_aux  #got to insert right rotine
	
set_left_terminal_node:
	la $a0, T_Label	
	
add_left_aux:	
	li $a1, 0 # left = NULL
	li $a2, 0 # right = NULL
	jal tree_node_create # call tree_node_create to creat the root node
	move $s2, $v0 # and put the result into $s0, wich is the adress for the root node/	
	sw  $s2, 4($s0)
	move $s0, $s2
	j search_loop


		
go_right:
	li $v0, 1
	li $a0, 1
	syscall
	lw $s1, 8($s0)
	beqz $s1, add_right
	move $s0, $s1
	add $t1,$t1,1 
	j search_loop
		
add_right:
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, newLine#carrega o endereço de str_data_entering para o a0
	syscall #chamada de sistema para E/S
	add $t1,$t1,1
	lb  $t2, ($t1)	  #get the first bit
	la $a0, NT_Label
	beq $t2, '0' add_right_aux
	beq  $t2, '1' , add_right_aux  
	
set_right_terminal_node:
	la $a0, T_Label	
	
add_right_aux:	
	li $a1, 0 # left = NULL
	li $a2, 0 # right = NULL
	jal tree_node_create # call tree_node_create to creat de root node
	move $s2, $v0 # and put the result into $s0, wich is the adress for the root node/	
	sw  $s2, 8($s0) #
	move $s0, $s2
	j search_loop
	

	
end_search_loop:
	j insert_node
	
end_insertion:
	lw $ra, 28($sp) # restore the Return Address.
	lw $fp, 24($sp) # restore the Frame Pointer.
	lw $s0, 20($sp) # restore $s0.
	lw $s1, 16($sp) # restore $s1.
	lw $s2, 12($sp) # restore $s2.
	addu $sp, $sp, 32 # restore the Stack Pointer.
	jr $ra # return.

tree_node_create:
	# set up the stack frame:
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	addu $fp, $sp, 32
	
	# grab the parameters:
	move $s0, $a0 # $s0 = rootLabel
	move $s1, $a1 # $s1 = left
	move $s2, $a2 # $s2 = right

	li $a0, 12 # need 12 bytes for the new node.
	li $v0, 9 # sbrk is syscall 9.
	syscall
	move $s3, $v0
	sw $s0, 0($s3) # node->label = label
	sw $s1, 4($s3) # node->left = left
	sw $s2, 8($s3) # node->right = right

	move $v0, $s3 # put return value into v0.
	
	# release the stack frame:
	lw $ra, 28($sp) # restore the Return Address.
	lw $fp, 24($sp) # restore the Frame Pointer.
	lw $s0, 20($sp) # restore $s0.
	lw $s1, 16($sp) # restore $s1.
	lw $s2, 12($sp) # restore $s2.
	lw $s3, 8($sp) # restore $s3.
	addu $sp, $sp, 32 # restore the Stack Pointer.
	jr $ra # return.
	## end of tree_node_create.



#char Print_LevelOrder(TREE_T *T){
#/*
# * Esta função imprime em 'FStream' toda a árvore binária de busca 'T'.
# * Note que ela vai imprimir da forma "largura", ou seja, todos os elementos do nível 1, 2, 3, ..., e n, sendo n o último nível da árvore.
# *
# * Ela retorna 1 se imprimiu com sucesso, ou 0 em caso de erros.
# */
# if(T==NULL) return 0;
# int i=1;
# fprintf("Largura:");
# while(Print_Node_LevelOrder(i,T->Root)==1) i++; // O 'i' É O NÍVEL
# printf("\n");
# return 1;
#}

#RECEBE EM $S0 NO RAIZ
Print_em_ordem_de_nivel:
	# set up the stack frame:
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	addu $fp, $sp, 32
	
	move $t4, $s0
	move $t3, $t4
	#if(No ==NULL) return
	beqz $s0, Fim_Print_em_ordem_de_nivel
	
	#aux para nivel
	li $t6, 1
	li $t7, 0
	li $s4, 1

		
		
#LOOP PARA NIVEIS		
LOOP_pon:
	beqz $s4, Fim_LOOP_pon	
	move $s5, $t6
	move $s0, $t3
	
	#PRINT T(N), N++
	li $v0, 4 # atribui 4 para v0 (codigo
	la $a0, te#carrega o endereço de 
	syscall #chamada de sistema para E/S 
	li $v0, 1 # atribui 4 para v0 (codigo
	move $a0, $t7#carrega o endereço de 
	syscall #chamada de sistema para E/S 
	addi $t7, $t7, 1	
	
	jal Print_no_em_ordem_nivel
	
	addi, $t6, $t6, 1
	li $s6, 1
	
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, barran#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S 
	
	j LOOP_pon
	
#PRINT \n	
Fim_LOOP_pon:
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, barran#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S 
	
	
Fim_Print_em_ordem_de_nivel:
	# rz elease the stack frame:
	lw $ra, 28($sp) # restore the Return Address.
	lw $fp, 24($sp) # restore the Frame Pointer.
	lw $s0, 20($sp) # restore $s0.
	lw $s1, 16($sp) # restore $s1.
	lw $s2, 12($sp) # restore $s2.
	lw $s3, 8($sp) # restore $s3.
	addu $sp, $sp, 32 # restore the Stack Pointer.
	jr $ra # return.

#char Print_Node_LevelOrder(int Level,NO_T *N){ // Complexidade O(n²).
# /*
# * Esta é uma função auxiliar para "Print_LevelOrder".
# */
# if(N==NULL) return 0;
# char R;
# print nivel , endreco
# if(Level<=1){
#  fprintf(" %d",N->Value);;
#  return 1;
# }
# Level--;
# R=Print_Node_LevelOrder(Level,N->L);
# if(Print_Node_LevelOrder(Level,N->R)!=1 && R!=1) return 0;
# return 1;
#}

#recebe o nivel em $s5, e o no em $s0, retorna valores em $s4
P2:
	
Print_no_em_ordem_nivel:
	# set up the stack frame:
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s5, 8($sp)
	addu $fp, $sp, 32
	
	beqz $s6, n_recupera_raiz
	j fim_n_recupera_raiz
n_recupera_raiz:
	move $s0, $t4
	
fim_n_recupera_raiz:
	li $s6, 0
	#SE FOR NULL SAIMOS DA FUNCAO
	beqz $s0, Fim_no_ordem_nivel
	
	#SE O NIVEL FOR MENOR QUE 1
	#li $v0, 1 # atribui 4 para v0 (codigo
	#move $a0, $s5#carrega o endereço de 
	#syscall #chamada de sistema para E/S 
	
	#PRINT VIRGULA
        #li $v0, 4 # atribui 1 para v0
	#la $a0, virgula#carrega o endereço de \n para o a0
	#syscall #chamada de sistema para E/S
	
	#li $v0, 1 # atribui 4 para v0 (codigo para printar string)
	#move $a0, $s0#carrega o endereço de \n para o a0
	#syscall #chamada de sistema para E/S 
	
	ble  $s5, 1, Print
fim_print:

	#MUDA O NIVEL
	add $s5, $s5, -1
	#li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	#la $a0, barran#carrega o endereço de \n para o a0
	#syscall #chamada de sistema para E/S 
	
	#BUSCA A ESQUERDA
	li, $s7, 1 
	lw $t4, 4($s0)
	jal Print_no_em_ordem_nivel
	move $t1, $s4
	
	#BUSCA A DIREITA
	li, $s7, 2
	lw $t4, 8($s0)
	jal Print_no_em_ordem_nivel
	move $t2, $s4
	
	#IF $t1 != 1 && $$t2 != 1
	bne $t1, 1, if_and
	
	
Fim_non:
	#VALORES DE RETRONO SAO DESCARTADOS
	# rz elease the stack frame:
	lw $ra, 28($sp) # restore the Return Address.
	lw $fp, 24($sp) # restore the Frame Pointer.
	lw $s0, 20($sp) # restore $s0.
	lw $s1, 16($sp) # restore $s1.
	lw $s2, 12($sp) # restore $s2.
	lw $s5, 8($sp) # restore $s3.
	addu $sp, $sp, 32 # restore the Stack Pointer.
	jr $ra # return.


#AUXILIARES PARA PRINT_NO _ORDEM_NIVEL
Fim_no_ordem_nivel:
	#RETORNA 0
	li $s4, 0
	j Fim_non
	
#IF $t1 != 1 && $s4 != 1
if_and:
	bne $t2, 1, fim_if_and_true
	j fim_if_and_false
	
#$s4 return 0
fim_if_and_true:
	#RETORNA 0
	li $s4, 0
	j Fim_non
	
#$s4 return 1   
fim_if_and_false:
	#RETORNA 1
	li $s4, 1
	j Fim_non




#SUBROTINA DE IMPRESSAO	
Print:	
	#RETORNA 1
	li $s4, 1
	
	#PRINT (
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, b1#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	
	#PRINT 0
	lw $t0, ($s0) 
	la $t1, rootLabel
	beq $t0, $t1, is_root
	beq $s7, 2, Print_1
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, zero#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	j fim_print_1

is_root:	
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, rootLabel#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	#PRINT VIRGULA
       	li $v0, 4 # atribui 1 para v0
	la $a0, virgula#carrega o endereço d
	syscall #chamada de sistema para E/S
	j equal_nt

Print_1:
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, um#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	
fim_print_1:
	#PRINT VIRGULA
        li $v0, 4 # atribui 1 para v0
	la $a0, virgula#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	
#PRINT NT OR T
	la $t0, NT_Label
	lw, $t1, ($s0)
	
	beq $t0, $t1 , equal_nt
	#NON EQUAL NT
	#PRINT T
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, T_Label #carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	j fim_equal_nt
	
equal_nt:
	#PRINT NT
	li $v0, 4 # atribui 4 para v0 (codigo para printar string)
	la $a0, NT_Label #carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	
fim_equal_nt:
	#PRINT VIRGULA
        li $v0, 4 # atribui 1 para v0
	la $a0, virgula#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	
        #PRINT &ESQ
        lw $t1, 4($s0) 
        beqz $t1, ESQ_NULL
        li $v0, 1 # atribui 1 para v0
	lw $a0, 4($s0)#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	j ESQ_NULL_FIM
	
ESQ_NULL:
	li $v0, 4 # atribui 1 para v0
	la $a0, null #carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	
ESQ_NULL_FIM:	
	#PRINT VIRGULA
        li $v0, 4 # atribui 1 para v0
	la $a0, virgula #carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	
	#PRINT &DIR
	lw $t1, 8($s0)
	beqz $t1, DIR_NULL
        li $v0, 1 # atribui 1 para v0
	lw $a0, 8($s0)#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	j DIR_NULL_FIM
	
DIR_NULL:
	li $v0, 4 # atribui 1 para v0
	la $a0, null #carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S
	
DIR_NULL_FIM:	
	#PRINT )
        li $v0, 4 # atribui 1 para v0
	la $a0, b2#carrega o endereço de \n para o a0
	syscall #chamada de sistema para E/S

	j Fim_non

	
remove: 

exit:
	li $v0, 10
	syscall				
	


	
			
