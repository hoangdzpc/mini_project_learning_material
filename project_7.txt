#Project 7
.data
Inputn: .asciiz "So nguoi va cay: "
Inputa: .asciiz "nhap chieu cao cua nguoi va cay: "
space: .asciiz " "
A: .word 0	#Dung de in luu tru chieu cao da duoc sap xep
.text
#Nhap vao so nguoi va cay
readn:	
	li $v0,51
	la $a0, Inputn		#So nguoi va cay
	syscall
	add $s0, $0,$a0		#s0 = n
	add $s1, $0, $s0	#s1 =n
	mul $a2, $a0, 4		#a2 = 4*n dung de dieu chinh lai $sp
	mflo $a2
	sub $sp, $sp ,$a2
#Nhap cac phan tu chieu cao
reada:
	la $a0, Inputa		#Thong bao
	syscall
	sw $a0, 0($sp)		#luu gia tri vua nhap vao stack
	add $sp , $sp, 4	#chuyen den ngan xep tiep theo trong stack
	subi $s0, $s0, 1	#n =n -1 de dem so phan tu da nhap
	bnez $s0, reada		#neu da het thi dung
main: 	
	la $t8, A		#luu dia chi cua mang A vao t8
	sub $sp, $sp, $a2	#dich chuyen lai $sp ve phan tu dau mang
	jal Find_loop		#goto find
	la $t8, A		#Luu lai dia chi cua phan tu dau Mang A vao t8
#In chieu cao da sap xep
print: 		
	li $v0, 1		
	lw $a0,	0($t8)
	syscall			#In chieu cao
	la $a0, space
	li $v0, 4
	syscall			#In " "
	add $t8, $t8, 4		#Tro toi phan tu tiep trong A
	subi $s1, $s1, 1	#n = n-1 de dem so phan tu da in
	bnez $s1, print		#n khac 0 ? tiep tuc vong lap
quit: 	li $v0, 10 		#terminate
	syscall
endmain:
Find_loop: 
	lw $t0,0($sp)			#load gia tri tu stack vao t0
	addi $a3,$a2,-4			#dung a3 = a2 - 4 ( tuong tu nhu j =i-1 ) de kiem tra dieu kien vong lap thu 2
	subi $a2, $a2, 4		#i = i-1 de kiem tra dieu kien dung cua vong lap thu 1
	beqz $a2, done			#neu i=0, da duyet het stack, ket thuc sap xep
				#neu chua duyet het, tiep tuc vong lap
	addi $sp,$sp,4			#tro toi phan tu tiep theo trong mang
	slt $t9, $0, $t0		#kiem tra t9 = t0 > 0 ?
	bnez $t9, Continue		#neu >0 thi tim chieu cao cua nguoi tiep, thuc hien vong lap thu 2
	sw $t0, 0($t8)			#neu <0 thi day la chieu cao cua cay, luu vao mang A va khong thay doi vi tri
	addi $t8, $t8, 4 		#tro toi phan tu tiep theo cua mang A
	j Find_loop			#quay lai vong lap Find_loop
Find_loop_end:
#Vong lap thu 2 mang ten Continue
Continue:	
	lw $t1,0($sp) 		 	#luu gia tri chieu cao tu stack ra t1
	slt $t9, $0, $t1		#t9 =1 neu la chieu cao cua nguoi
	bnez $t9, Compare		#Neu la chieu cao cua nguoi thi so sanh chieu cao voi nguoi o vong lap 1
				#Neu la chieu cao cua cay
	beqz $a3, Reset			#Neu het vong lap thu 2 thi reset lai stack va tiep tuc thuc hien vong lap 1
	addi $sp,$sp,4			#tro toi phan tu tiep theo trong stack
	subi $a3, $a3,4			# j = j-1
	j Continue			#Quay lai vong lap thu 2
#So sanh chieu cao 2 nguoi
Compare:
	slt $t9, $t1, $t0		# t9 =1 Neu chieu cao cua nguoi dung sau < chieu cao nguoi dung truoc
	bnez $t9, Swap			# Neu t9=1 , doi vi tri cua ho
				#Neu khong, dieu chinh lai $sp va j 
	addi $sp,$sp,4			# tro toi phan tu tiep theo trong stack
	subi $a3, $a3, 4		# j = j-1
	j Continue		#Quay lai vong lap thu 2
#Doi vi tri cua 2 nguoi
Swap:
	sw $t0,0($sp) 		#luu chieu cao nguoi cao hon vao lai stack
	add $t0, $0, $t1	#luc nay t0 = chieu cao nguoi thap hon
	j Continue		#Quay lai vong lap thu 2
#sau khi ket thuc vong lap 2, can dat lai $sp va ghi lai gia tri chieu cao t0 vao mang A
Reset:
	sw $t0, 0($t8)		#luu chieu cao t0 vao A
	addi $t8,$t8, 4		#Tro toi phan tu tiep trong A
	sub $sp, $sp, $a2	#Dieu chinh lai $sp toi phan tu tiep theo trong vong lap 1
	j Find_loop		#Quay lai chuong trinh 1
done: 	
	sw $t0, 0($t8)		#luu chieu cao t0 vao A
	jr $ra 			

