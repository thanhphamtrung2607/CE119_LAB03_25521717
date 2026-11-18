        .data
t1:     .asciiz "kien truc may tinh"
t2:     .asciiz "mips"
t3:     .asciiz ""
t4:     .asciiz "a bc def"
t5:     .asciiz "vi dieu khien co bo nho rat it"
table:  .word t1, t2, t3, t4, t5
N:      .word 5
bar:    .asciiz "|"
nl:     .asciiz "|\n"

        .text
        .globl main
main:
        la   $s3, table
        lw   $s4, N
loop:
        beq  $s4, $zero, done
        lw   $s5, 0($s3)         #dia chi chuoi hien tai
        move $a0, $s5
        jal  reverse_words
        li   $v0, 4              # in "|"
        la   $a0, bar
        syscall
        li   $v0, 4              # in ra chuoi ket qua
        move $a0, $s5
        syscall
        li   $v0, 4              # in "|\n"
        la   $a0, nl
        syscall
        addiu $s3, $s3, 4
        addiu $s4, $s4, -1
        j    loop
done:
        li   $v0, 10
        syscall

# strlen: thu tuc la
strlen:
        move $v0, $zero
sl_loop:
        addu $t0, $a0, $v0
        lb   $t1, 0($t0)
        beq  $t1, $zero, sl_done
        addiu $v0, $v0, 1
        j    sl_loop
sl_done:
        jr   $ra

#  rev_range: thu tuc la, dao [$a0,$a1] 
rev_range:
rr_loop:
        sltu $t0, $a0, $a1       # so sanh khong dau:  a0 < a1 ?
        beq  $t0, $zero, rr_done
        lb   $t1, 0($a0)
        lb   $t2, 0($a1)
        sb   $t2, 0($a0)
        sb   $t1, 0($a1)
        addiu $a0, $a0, 1
        addiu $a1, $a1, -1
        j    rr_loop
rr_done:
        jr   $ra

#  reverse_words: thu tuc khong la
reverse_words:
        addiu $sp, $sp, -16
        sw   $ra, 12($sp)
        sw   $s0, 8($sp)
        sw   $s1, 4($sp)
        sw   $s2, 0($sp)

        move $s0, $a0            # s0 = dau chuoi
        jal  strlen              # a0 van la dia chi chuoi
        beq  $v0, $zero, rw_exit # chuoi rong: khong lam gi
        addu $s1, $s0, $v0
        addiu $s1, $s1, -1       # s1 = dai chi ki tu cuoi

        move $a0, $s0            # buoc 1: dao toan bo chuoi
        move $a1, $s1
        jal  rev_range

        move $s2, $s0            # s2 = con tro quet
scan:
        sltu $t0, $s1, $s2       # s2 > s1 ? (vuot cuoi chuoi)
        bne  $t0, $zero, scan_done
        lb   $t1, 0($s2)
        li   $t2, 32             # ' '
        beq  $t1, $t2, scan_done
        addiu $s2, $s2, 1
        j    scan
scan_done:
        move $a0, $s0            # buoc 2: dao tu [s0, s2-1]
        addiu $a1, $s2, -1
        jal  rev_range
        sltu $t0, $s1, $s2       # da het chuoi
        bne  $t0, $zero, rw_exit
        addiu $s0, $s2, 1        # tiep theo bat dau sau dau cach
        move $s2, $s0
        j    scan

rw_exit:
        lw   $s2, 0($sp)
        lw   $s1, 4($sp)
        lw   $s0, 8($sp)
        lw   $ra, 12($sp)
        addiu $sp, $sp, 16
        jr   $ra
