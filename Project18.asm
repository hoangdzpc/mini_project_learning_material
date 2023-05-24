.data
a: .word 1, 2, 3, 4, 5
b: .word 1, 2, 3, 4, 5
size: .word 5
true_msg: .asciiz "True\n"
swap_msg: .asciiz "Swap\n"
false_msg: .asciiz "False\n"
.text
create:
    	la $t0, a  		# Đưa địa chỉ của mảng a vào $t0
    	la $t1, b  		# Đưa địa chỉ của mảng b vào $t1
    	lw $t2, size    	# Đưa kích thước của mảng vào $t2
    	li $t3, 0       	# Khởi tạo số phần tử khác nhau bằng 0
    	li $t6, -1      	# Khởi tạo địa chỉ của phần tử khác nhau đầu tiên ở mảng a bằng -1
    	li $t7, -1      	# Khởi tạo địa chỉ của phần tử khác nhau thứ hai ở mảng a bằng -1
    	li $t8, -1		# Khởi tạo địa chỉ của phần tử khác nhau đầu tiên ở mảng b bằng -1
    	li $t9, -1		# Khởi tạo địa chỉ của phần tử khác nhau thứ hai ở mảng b bằng -1
loop:
    	beq $t2, $zero, end     # Nếu kích thước của mảng bằng 0 thì thoát khỏi vòng lặp
    	lw $t4, 0($t0)  # Lấy phần tử đầu tiên của mảng a
    	lw $t5, 0($t1)  # Lấy phần tử đầu tiên của mảng b
    	bne $t4, $t5, check     # Nếu phần tử đầu tiên của hai mảng khác nhau thì chuyển sang bước kiểm tra
    	addi $t0, $t0, 4    # Tăng địa chỉ của mảng a lên 4
    	addi $t1, $t1, 4    # Tăng địa chỉ của mảng b lên 4
    	addi $t2, $t2, -1   # Giảm kích thước của mảng xuống 1
    	j loop      # Quay lại vòng lặp
check:
    	beq $t6, -1, update1   # Nếu chỉ số của phần tử khác nhau đầu tiên bằng -1 thì cập nhật nó
    	beq $t7, -1, update2   # Nếu chỉ số của phần tử khác nhau thứ hai bằng -1 thì cập nhật nó
    	bne $t3, 2, end 	 # Nếu đã có hai phần tử khác nhau thì thoát khỏi vòng lặp
update1:
    	move $t6, $t0   # Lưu địa chỉ của phần tử khác nhau đầu tiên của a 
    	move $t8, $t1	# Lưu địa chỉ của phần tử hiện tại ở mảng b 
    	addi $t3, $t3, 1	# Tăng giá trị số phần tử khác nhau
    	addi $t0, $t0, 4    # Tăng địa chỉ của mảng a lên 4
    	addi $t1, $t1, 4    # Tăng địa chỉ của mảng b lên 4
    	addi $t2, $t2, -1   # Giảm kích thước của mảng xuống 1
    	j loop      # Quay lại vòng lặp
update2:
    	move $t7, $t0   # Lưu địa chỉ của phần tử khác nhau thứ hai của a
    	move $t9, $t1	# Lưu địa chỉ của phần tử hiện tại ở mảng b 
    	addi $t3, $t3, 1	# Tăng giá trị số phần tử khác nhau
    	addi $t0, $t0, 4    # Tăng địa chỉ của mảng 1 lên 4
    	addi $t1, $t1, 4    # Tăng địa chỉ của mảng 2 lên 4
    	addi $t2, $t2, -1   # Giảm kích thước của mảng xuống 1
    	j loop      # Quay lại vòng lặp
end:
    	beq $t3, 0, print_true      # Nếu không có phần tử nào khác nhau thì in ra "True"
    	beq $t3, 2, last_compare      # Nếu chỉ có một phần tử khác nhau thì in ra "Swap"
    	j print_false       # Nếu có nhiều hơn hai phần tử khác nhau thì in ra "False"
print_true:
    	li $v0, 4       # Đặt $v0 để in ra chuỗi
    	la $a0, true_msg    # Đưa địa chỉ của chuỗi "True" vào $a0
    	syscall     # In ra chuỗi "True"
    	j exit      # Thoát khỏi chương trình
last_compare:	#So sánh chéo để đưa ra kết quả cuối cùng
   	lw $t0, 0($t6)	
   	lw $t1, 0($t9)	
    	lw $t2, 0($t7)	
    	lw $t3, 0($t8)
    	# Các lệnh trên để backup dữ liệu đã lưu ở update1 và update2 
    	bne $t0, $t1, print_false
    	bne $t2, $t3, print_false
    	j print_true
    	# Các lệnh trên để thực hiện so sánh chéo
print_false:
    	li $v0, 4       # Đặt $v0 để in ra chuỗi
    	la $a0, false_msg   # Đưa địa chỉ của chuỗi "False" vào $a0
    	syscall     # In ra chuỗi "False"
    	j exit      # Thoát khỏi chương trình
exit:
    	li $v0, 10      # Đặt $v0 để thoát khỏi chương trình
    	syscall     # Thoát khỏi chương trình
