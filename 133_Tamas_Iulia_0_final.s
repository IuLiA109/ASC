.data
    matrix: .space 40000
    m: .space 40000
    nrLegaturi: .space 400
    j: .space 4
    i: .space 4
    lineIndex: .space 4
    columnIndex: .space 4
    cerinta: .space 4
    n: .space 4                 # nr noduri
    index: .space 4             # index = i
    leg: .space 4
    formatScanf: .asciz "%ld"
    formatPrintf: .asciz "%ld "
    formatPrintf2: .asciz "%ld"
    newLine: .asciz "\n"        #   endl
    lung: .space 4              #  lungime drum cerinta 2
    srs: .space 4               #  nod sursa
    dest: .space 4              #  nod destinatie
.text
matrix_mult:
    pushl %ebp 
    movl %esp, %ebp

    movl 8(%ebp), %esi     # in eax avem adresa matrix(m1)
    movl 12(%ebp), %ebx     # in ebx avem adresa lui m(m2)
    movl 16(%ebp), %ecx     # in ecx avem adesa lui m(mret)
    movl 20(%ebp), %edi     # in edx avem n
    subl $40012, %esp
    movl $0, -4(%ebp)        # -4(ebp) = z
    movl $0, -8(%ebp)        # -8(ebp) = i
    movl $0, -12(%ebp)       # -12(ebp) = j
    #-16(ebp)        # -16(ebp) = mres2

for_z:
    movl -4(%ebp), %eax 
    movl 20(%ebp),%ebx
    cmp %eax, %ebx
    je ex_for_z
    movl $0, -8(%ebp)        # -8(ebp) = i
    fori:
        movl -8(%ebp), %eax 
        movl 20(%ebp),%ebx
        cmp %eax, %ebx
        je ex_fori 
        movl $0, -12(%ebp)       # -12(ebp) = j

        movl $0, %edx
        movl -4(%ebp), %eax
        mull 20(%ebp) 
        addl -8(%ebp),%eax        # eax = z*n+i
        movl %ebp, %edi
		subl $40000, %edi
        movl $0, (%edi, %eax,4)

        forj:
            movl -12(%ebp), %eax 
            movl 20(%ebp),%ebx
            cmp %eax, %ebx
            je ex_forj

            movl $0, %edx
            movl -4(%ebp), %eax
            mull 20(%ebp) 
            addl -12(%ebp),%eax        # eax = z*n+j
            pushl %eax      # punem z*n+j pe stiva
            movl $0, %edx
            movl -12(%ebp), %eax
            mull 20(%ebp) 
            addl -8(%ebp),%eax        # eax = j*n+i
            movl 12(%ebp), %esi 
            movl (%esi,%eax,4),%eax     # eax = m2[j][i]
            popl %ebx           # pop z*n+j
            movl 8(%ebp), %esi
            movl (%esi, %ebx, 4), %ebx      #ebx = m1[z][j]
            mull %ebx           # eax = m1[z][j]*m2[j][i]
            movl %eax, %ecx     # ecx = m1[z][j]*m2[j][i]

            movl $0, %edx
            movl -4(%ebp), %eax
            mull 20(%ebp) 
            addl -8(%ebp),%eax        # eax = z*n+i
            movl %ebp, %edi
			subl $40000, %edi
            addl %ecx, (%edi, %eax,4)
            movl (%edi, %eax,4), %ecx

            incl -12(%ebp) 
            jmp forj
        ex_forj:
        incl -8(%ebp)
        jmp fori

    ex_fori:

    incl -4(%ebp)
    jmp for_z

ex_for_z:
    movl $0, -8(%ebp)        # -8(ebp) = i
    movl $0, -12(%ebp)       # -12(ebp) = j

fori2:
    movl -8(%ebp), %eax 
    movl 20(%ebp),%ebx
    cmp %eax, %ebx
    je ex_fori2 
    movl $0, -12(%ebp)       # -12(ebp) = j

    forj2:
        movl -12(%ebp), %eax 
        movl 20(%ebp),%ebx
        cmp %eax, %ebx
        je ex_forj2

        movl $0, %edx
        movl -8(%ebp), %eax
        mull 20(%ebp) 
        addl -12(%ebp),%eax        # eax = i*n+j
        movl %ebp, %edi
		subl $40000, %edi
        movl (%edi, %eax,4), %ebx
        movl 16(%ebp), %esi
        movl %ebx, (%esi,%eax,4)

        incl -12(%ebp) 
        jmp forj2

    ex_forj2:

    incl -8(%ebp)
    jmp fori2

ex_fori2:

    addl $40012,%esp
    popl %ebp
    ret
.global main
main:
    pushl $cerinta                       #  nr cerinta
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $n                            # nr noduri
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    movl $0, index
#creearea in memeorie a matricei
et_for_legaturi:
    movl index, %ecx
    cmp %ecx, n 
    je ex
    pushl $leg
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    lea nrLegaturi, %edi
    movl index, %ecx
    movl leg, %eax
    movl %eax, (%edi,%ecx,4)
    
    incl index
    jmp et_for_legaturi

ex:
    movl $0, i

for_i:
    movl i, %ecx
    cmp %ecx, n 
    je ex_for_i
    movl $0, j 

    for_j:
        movl j, %eax
        lea nrLegaturi, %edi 
        movl i, %ecx
        movl (%edi,%ecx,4), %ebx
        cmp %eax, %ebx
        je ex_for_j

        pushl $leg          #in leg avem x
        pushl $formatScanf
        call scanf
        popl %ebx
        popl %ebx

        movl i, %eax
        movl $0, %edx 
        mull n 
        addl leg, %eax
        lea matrix, %esi 
        lea m, %edi 
        movl $1, (%esi, %eax, 4)
        movl $1, (%edi, %eax, 4)

        incl j 
        jmp for_j

    ex_for_j:
    incl i 
    jmp for_i

ex_for_i:
    movl cerinta, %eax 
    movl $2, %ebx
    cmp %eax, %ebx
    je cerinta_2
    movl $1, %ebx
    cmp %eax, %ebx
    jne et_exit

#afisarea
et_afis_matr:
    movl $0, lineIndex

for_lines:
    movl lineIndex, %ecx
    cmp %ecx, n
    je et_exit
    movl $0, columnIndex

for_columns:
    movl columnIndex, %ecx
    cmp %ecx, n
    je cont

    movl lineIndex, %eax
    movl $0, %edx
    mull n
    addl columnIndex, %eax      
    
    lea matrix, %edi
    movl (%edi, %eax, 4), %ebx
    pushl %ebx
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    // pushl $0
    // call fflush
    // popl %ebx
    
    incl columnIndex
    jmp for_columns

cont:
    pushl $newLine
    call printf
    popl %ebx

    incl lineIndex
    jmp for_lines
#-------------------------------------------------------------
# gcc -m32 133_Tamas_Iulia_0.s -o 133_Tamas_Iulia_0
cerinta_2:
    pushl $lung                      #  lungime drum
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $srs                        # nod sursa
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    pushl $dest                      #  nod destinatie
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    movl $1, i 
for_fct:
    movl i, %ecx
    cmp %ecx, lung
    je ex_for_fct

    pushl n               # n
    pushl $m               # mres
    pushl $m               # m2
    pushl $matrix          # m1
    call matrix_mult 
    popl %ebx
    popl %ebx
    popl %ebx
    popl %ebx

    incl i 
    jmp for_fct 

ex_for_fct:
#afisam m[srs][dest]
    movl srs, %eax 
    movl $0, %edx 
    mull n 
    addl dest, %eax 

    lea m, %esi 
    movl (%esi, %eax,4), %ebx
    pushl %ebx
    pushl $formatPrintf2
    call printf
    popl %ebx
    popl %ebx



// #afisarea matricea m
// et_afis_matr2:
//     movl $0, lineIndex
// for_lines2:
//     movl lineIndex, %ecx
//     cmp %ecx, n
//     je et_exit
//     movl $0, columnIndex

// for_columns2:
//     movl columnIndex, %ecx
//     cmp %ecx, n
//     je cont2

//     movl lineIndex, %eax
//     movl $0, %edx
//     mull n
//     addl columnIndex, %eax      
    
//     lea m, %edi
//     movl (%edi, %eax, 4), %ebx
//     pushl %ebx
//     pushl $formatPrintf
//     call printf
//     popl %ebx
//     popl %ebx

//     pushl $0
//     call fflush
//     popl %ebx
    
//     incl columnIndex
//     jmp for_columns2

// cont2:
//     movl $4, %eax
//     movl $1, %ebx
//     movl $newLine, %ecx
//     movl $2, %edx
//     int $0x80
//     incl lineIndex
//     jmp for_lines2


et_exit:

    pushl $0
    call fflush
    popl %ebx

    movl $1, %eax
    movl $0, %ebx
    int $0x80
    