.equ espaco, r20 #32
.equ enter,  r19 #10

.data
.equ UART0, 0x860
.text




main: 
	addi r15, r0,1
	addi espaco, r0, 32
	addi enter, r19, 10
	addi r6, r0, 0

	num:		
		movia r10, UART0
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
		beq r2, espaco, inicio
		beq r2, enter, inicio
		br pega_digito
	
	inicio:
		mov r10, r15
		movi r8, 1
		call fib

		mov r4, r1
	  	movia r10,UART0	
	  	call nr_uart_txhex
		
  		movi r4, 0x2C
	  	movia r10,UART0	
	  	call nr_uart_txchar
		
    	  
    	addi r15,r15, 1
    	bge r6, r15, inicio
    	br END
    	  
    	  
      
	fib:
		bgt r10, r8, fibonacci
		mov r1, r10
     		ret
      
	fibonacci:
      		subi sp, sp, 12
      		stw ra, 0(sp)
      
      		stw r10, 4(sp)
     		subi r10, r10, 1
      		call fib
      
      		ldw r10, 4(sp)
     		stw r1, 8(sp)
      
      
      		subi r10, r10, 2
      		call fib
      
      		ldw r5, 8(sp)
      		add r1, r5, r1
      
      		ldw ra, 0(sp)
      		addi sp, sp, 12
      		ret
      	
      	END:
      	
      		.end
