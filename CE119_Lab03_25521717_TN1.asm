
.data
msg:    .asciiz "Ket qua: "
.text
.globl main
main:
        li    $a0, 5            # x = 5
        jal   outer             # v0 = outer(5)
        move  $s0, $v0
        li    $v0, 4
        la    $a0, msg
        syscall
        move  $a0, $s0
        li    $v0, 1
        syscall
        li    $v0, 10
        syscall

# outer: tinh inner(x) + 1
# Tham so : $a0 = x
# Tra ve  : $v0 = 2*x + 1
# Thanh ghi su dung: $a0, $v0, $ra (luu tren khung ngan xep 4 byte)
outer:
        addi  $sp, $sp, -4      # mo dau: cap khung ngan xep 1 word (4 byte)
        sw    $ra, 0($sp)       # cat dia chi tro ve main vao ngan xep
        jal   inner             # goi inner(x), $v0 = 2*x
        addi  $v0, $v0, 1       # $v0 = inner(x) + 1
        lw    $ra, 0($sp)       # ket thuc: khoi phuc dia chi tro ve main
        addi  $sp, $sp, 4       # thu hoi khung ngan xep
        jr    $ra               # quay ve main

# inner: thu tuc la, tinh 2 * x
# Tham so : $a0 = x
# Tra ve  : $v0 = 2*x
# Thanh ghi su dung: $a0, $v0
inner:
        add   $v0, $a0, $a0
        jr    $ra
