;
; @author Ammar Faizi <ammarfaizi2@gmail.com> https://www.facebook.com/ammarfaizi2
;
section .data
	a1_s db "Masukkan ID barang: "
	a1_l equ $-a1_s
	a2_s db "Sedang melakukan pencarian...",10
	a2_l equ $-a2_s
	a3_s db 10,"Barang ditemukan!",10
	a3_l equ $-a3_s
	a4_s db 10,"Mohon maaf, barang dengan ID: ",34
	a4_l equ $-a4_s
	a5_s db 34," tidak ditemukan",10
	a5_l equ $-a5_s
	filename db "database_barang.txt",0

section .bss
	input resb 5
	search_buf resb 5
	fetch_buf resb 1
	in_l resb 2
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
	cmp r8,1
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
	and rdx,0xff
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
	mov r8,1
	ret

found_flag:
	mov rax,1
	mov r11,1
	jmp check+35
	ret

chread:
	mov rax,0
	mov rdi,r9
	mov rsi,search_buf
	mov rdx,1
	syscall
	mov rsi,[rsi]
	cmp rax,0
	je not_found
	and rsi,0xff
	cmp rsi,10
	je check_end
	jmp chread
	ret

check_end:
	mov r8,0
	jmp search
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
	cmp rax,3
	mov [in_l],rax
	jne not_found
	ret

exit:
	mov rax,60
	xor rdi,rdi
	syscall
	ret

not_found:
	mov rsi,a4_s
	mov rdx,a4_l
	call mp
	mov rsi,input
	mov rdx,[in_l]
	call mp
	mov rsi,a5_s
	mov rdx,a5_l
	call mp
	jmp exit
	ret
