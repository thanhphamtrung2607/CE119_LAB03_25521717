
.data
n_val:  .word 20               
msg:    .asciiz "F(n) = "

.text
.globl main

main:
        lw    $a0, n_val
        jal   fib_opt
        move  $s0, $v0
        li    $v0, 4
        la    $a0, msg
        syscall
        move  $a0, $s0
        li    $v0, 1
        syscall
        li    $v0, 10
        syscall

# Thu tuc : fib_opt
# Mieu ta : Tinh F(n) bang de quy co toi uu truong hop co so:
#           Kiem tra n < 2 truoc khi cap khung ngan xep. Neu n < 2 thi tra ve
#           ngay ma khong cap khung (tiet kiem 9 lenh cho moi lan goi co so)
# Tham so : $a0 = n (n >= 0)
# Tra ve  : $v0 = F(n)
# Thanh ghi su dung: $ra, $s0, $s1 (chi cap khung 12 byte khi n >= 2), $t0
fib_opt:
        slti  $t0, $a0, 2       # kiem tra truong hop co so truoc khi cap khung
        beq   $t0, $zero, fo_rec
        move  $v0, $a0          # F(0) = 0, F(1) = 1
        jr    $ra               # tro ve ngay, khong can cap/thu hoi khung

fo_rec:
        addi  $sp, $sp, -12     # cap khung 12 byte khi n >= 2
        sw    $ra, 8($sp)
        sw    $s0, 4($sp)
        sw    $s1, 0($sp)

        move  $s0, $a0          # $s0 = n
        addi  $a0, $s0, -1      # $a0 = n - 1
        jal   fib_opt           # $v0 = F(n - 1)
        move  $s1, $v0          # $s1 = F(n - 1)
        addi  $a0, $s0, -2      # $a0 = n - 2
        jal   fib_opt           # $v0 = F(n - 2)
        add   $v0, $s1, $v0     # $v0 = F(n - 1) + F(n - 2)

        lw    $s1, 0($sp)       # khoi phuc $s1, $s0, $ra
        lw    $s0, 4($sp)
        lw    $ra, 8($sp)
        addi  $sp, $sp, 12
        jr    $ra
