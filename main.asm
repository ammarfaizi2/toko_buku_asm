
section .data
	a1_s db "Masukkan ID barang: "
	a1_l equ $-a1_s
	filename db "id_barang.txt"

section .bss
	input resb 5
	search_buf resb 4

section .text
	global _start

_start:
	mov rsi,a1_s
	mov rdx,a1_l
	call mp
	call get_id
	mov rsi,input
	mov rdx,rax
	call mp
	call open_file
	mov r9,rax
	call search
	call exit

open_file:
	mov rax,2
	mov rdi,filename
	mov rsi,0
	syscall
	ret

search:
	call sread
	call check
	cmp r10,1
	jne search
	ret

chread:
	mov rax,0
	mov rdi,r9
	mov rsi,search_buf
	mov rdx,1
	syscall
	ret

sread:
	mov rax,0
	mov rdi,r9
	mov rsi,search_buf
	mov rdx,4
	syscall
	ret

mp:
	mov rax,1
	mov rdi,1
	syscall
	ret

get_id:
	mov rax,0
	mov rdi,0
	mov rsi,input
	mov rdx,5
	syscall
	dec rax
	ret

exit:
	mov rax,60
	xor rdi,rdi
	syscall
	ret