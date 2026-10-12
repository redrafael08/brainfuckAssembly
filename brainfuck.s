.global brainfuck

format_str: .asciz "We should be executing the following code:\n%s"
format_str2: .asciz "\n%c\n"

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.

#hoi

brainfuck:
	pushq %rbp
	movq %rsp, %rbp

	pushq	%rdi		# push instruction pointer -8
	subq	$8,%rsp		# stack alignment

	movq %rdi, %rsi
	movq $format_str, %rdi
	call printf		# print instruction
	movq $0, %rax

	

	movq $16, %r10  # make memory pointer 16

	movq	$2000,%rdi
clearMemoryLoop:
	subq	$8,%rsp  # move stackpointer down
	movq	$0,(%rsp)
	decq	%rdi
	cmpq	$0,%rdi
	jge		clearMemoryLoop	
	


instruction:

	movq $0, %rax		
	movq -8(%rbp), %r9 # move instruction pointer to r9

	movq	$format_str2,%rdi   

	movq	$0, %r8
	movb 	(%r9), %r8b # move instruction to r8
	movq	%r8, %rsi  

	
	call printf   # print instruction

	
	/*
	cmpq	 $62,%r8 
	jmp	movPr
	cmpq	 $60,%r8
	jmp	movPl
	cmpq	 $43,%r8
	*/
	jmp	Incr
	cmpq	 $45,%r8
	/*
	jmp	Decr
	cmpq	 $46,%r8
	*/
	jmp	Outp
	cmpq	 $44,%r8
	
	/*
	jmp	Inp
	cmpq	 $91,%r8
	
	jmp	JmpPast
	cmpq	 $93,%r8
	jmp	JmpBack
	*/
	
	



	incq	-8(%rbp)  # increase instruction pointer

	#cmpq	$0, %r8	# check if end of instruction
	#jne instruction
	jmp	instruction








	movq %rbp, %rsp
	popq %rbp
	ret


movPr:
	decq %r10# move memory pointer to right
	jmp	instruction


movPl:
	incq %r10 # move memory pointer to left
	jmp	instruction



Incr:
	incb (%rbp,%r10,1)  # increase memory cell by 1
	jmp	instruction

Decr:
	decb (%rbp,%r10,1) # decrease memory cell by 1
	jmp	instruction
	
Outp:

	movq	$0, %rax
	movq	$format_str2,%rdi
	movq	$0,%rsi
	movb	(%rbp,%r10,1),%sil

	call 	printf

	call exit
	jmp	instruction


Inp:

    subq    $16, %rsp  # move stack pointer 16 points down 
    leaq    -8(%rbp) , %rsi  # load effective memory address in rsi argument 2 of input
    movq     $format_str2 , %rdi  #first argument scanf
    movq     $0 , %rax  #no vector register used to scanf
    call    scanf # scan
	jmp	instruction


JmpPast:
	addq $0,%rdi  # if (rsp) == 0 jmp ]
	jmp	instruction


JmpBack:  # jmp (rsp) != 0 jmp [
	jmp	instruction



/*


	62>	Move the pointer to the right
60<	Move the pointer to the left
43+	Increment the memory cell at the pointer
45-	Decrement the memory cell at the pointer
46.	Output the character signified by the cell at the pointer printf
44,	Input a character and store it in the cell at the pointer scanf
9Decr1[	Jump past the matching ] if the cell at the pointer is 0
93]	Jump back to the matching [ if the cell at the pointer is nonzero




[
	code
]


*/