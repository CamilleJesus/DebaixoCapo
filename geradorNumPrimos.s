##################################################
# Gerador de números primos
#
# Alunos:
# 	Camile
# 	Pedro Henrique Gomes
# 	Sarah Pereira
##################################################

.equ limite_inferior, r12
.equ dividendo, r11
.equ divisor, r6
.equ resto, r7
.equ metade_dividendo, r8
.equ dois, r9
.equ espaco, r20 #32
.equ enter,  r19 #10

.data
	.equ UART0, 0x860

.text



main:

	addi espaco, r0, 32
	addi enter, r19, 10
	addi r6, r0, 0
	addi r11, r0, 0
	
	num:		
		movia r5, UART0
		call nr_uart_rxchar
		blt r2, r0, num
		br loop
		
	pega_digito:
		muli r6, r6, 10
		add r8, r0, r2
		subi r8, r8, 48
		add r6, r6, r8
		call num
	
	
	loop:
		beq r2, espaco, guarda_num
		beq r2, enter, guarda_num
		br pega_digito
	
	guarda_num:
		beq r11,r0, guarda_num1
		br inicializacao
		
	
	guarda_num1:
		add limite_inferior,r0,r6
		addi r11, r11, 1
		addi r6, r0, 0
		call num

	inicializacao:
		add dividendo,r9,r6				#Guarda o limite superior em r3
		#addi limite_inferior,r0,2			#Guarda o limite inferior em r2
		addi dois, r0,2
		add divisor,r0, dois 				#Inicia o divisor em 2
		div metade_dividendo, dividendo, dois		#Pega a metade do dividendo
	
	verifica_se_primo:
	
		div resto,dividendo,divisor		#Pega o quociente da divisao
		mul resto,resto,divisor			#Multiplica o quociente da divisão pelo divisor
		sub resto,dividendo,resto		#Subtrai o dividendo pela multiplicação do quociente pelo divisor, para pega o valor do resto
		bne resto,r0, atualiza_divisor		#Se o resto for diferente de 0 atualiza o divisor
		br atualizar_dividendo			#O número não é primo, atualiza do dividendo
		
		
	atualiza_divisor:
		addi divisor, divisor, 1				#Aumenta dividor
		bgt metade_dividendo, divisor, verifica_se_primo		#Verifica se o divisor é menor ou igual a metade do dividendo
									#OBS: UM NÚMERO NÃO É DIVISIVEL POR NÚMEROS MAIOR QUE SUA METADE
						

		#bgt dividendo,divisor, verifica_se_primo #Verifica se o dividendo é maior que o divisor/contado
		
		#NESTA LINHA TEM QUE ADICIONAR O PRINT DO ATUAL DIVIDENDO SE CHEGOU ATÉ ESSA LINHA ELE É PRIMO
		mov r4, dividendo
		movia r15,UART0	
		call nr_uart_txhex
		
		movi r4, 0x2C
		movia r15,UART0	
		call nr_uart_txchar
		
		
		br atualizar_dividendo					#Atualiza do dividendo
	
	
	atualizar_dividendo:
		addi divisor,r0,2					#Reseta o divisor
		addi dividendo,dividendo, -1				#Diminui o dividendo
		div metade_dividendo, dividendo,dois			#Atualiza a metade do dividendo
		bgt dividendo,limite_inferior,verifica_se_primo		#Se o dividendo é maior que o limite inferior, continua a busca por mais números primos


.end
		
		
	
	
