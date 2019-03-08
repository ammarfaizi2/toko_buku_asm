;
; @author Ammar Faizi <ammarfaizi2@gmail.com> https://ww.facebook.com/ammarfaizi2
;
section .data
	a1_s db "Masukkan ID barang: "
	a1_l equ $-a1_s
	a2_s db "Sedang melakukan pencarian...",10
	a2_l equ $-a2_s
	a3_s db 10,"Barang ditemukan!",10
	a3_l equ $-a3_s
	filename db "id_barang.txt"

section .bss
	input resb 5
	search_buf resb 5
	fetch_buf resb 1

section .text
	global _start

_start:
	mov rsi,a1_s
	mov rdx,a1_l
	call mp
	call get_id
	call show_wait
	call open_file
	mov r9,rax
	call search
	call exit

show_wait:
	mov rsi,a2_s
	mov rdx,a2_l
	call mp
	ret

open_file:
	mov rax,2
	mov rdi,filename
	mov rsi,0
	syscall
	ret

search:
	cmp r10,1
	je chread
	call sread
	call check
	cmp rax,1
	je bef_found
	jmp search
	ret

bef_found:
	mov rsi,a3_s
	mov rdx,a3_l
	call mp
	call found
	ret

found:
	mov rax,0
	mov rdi,r9
	mov rsi,fetch_buf
	mov rdx,1
	syscall
	cmp rax,0
	je exit
	mov rsi,fetch_buf
	mov rdx,rax
	call mp
	mov rdx,[fetch_buf]
	cmp rdx,10
	jne found
	ret

check:
	mov rdi,[search_buf]
	mov rsi,[input]
	and rsi,0x00000000ffffff
	and rdi,0x00ffffff
	cmp rsi,rdi
	je found_flag
	ret

found_flag:
	mov rax,1
	mov r10,1
	jmp check+35
	ret

chread:
	mov rax,0
	mov rdi,r9
	mov rsi,search_buf
	mov rdx,1
	syscall
	mov r10,0
	call search
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