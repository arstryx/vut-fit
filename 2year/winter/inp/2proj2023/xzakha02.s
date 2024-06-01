; Autor reseni: Arsenii Zakharenko xakha02
; Pocet cyklu k serazeni puvodniho retezce: 3965
; Pocet cyklu razeni sestupne serazeneho retezce: 4892
; Pocet cyklu razeni vzestupne serazeneho retezce: 447 
; Pocet cyklu razeni retezce s vasim loginem: 955
; Implementovany radici algoritmus: bubble sort
; ------------------------------------------------

; DATA SEGMENT
                .data
; login:          .asciiz "vitejte-v-inp-2023"    ; puvodni uvitaci retezec
; login:          .asciiz "vvttpnjiiee3220---"  ; sestupne serazeny retezec
; login:          .asciiz "---0223eeiijnpttvv"  ; vzestupne serazeny retezec
  login:          .asciiz "xzakha02"            ; SEM DOPLNTE VLASTNI LOGIN
                                                ; A POUZE S TIMTO ODEVZDEJTE

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize - "funkce" print_string)

; CODE SEGMENT
                .text

main:
    daddi r4, r0, login             ; set r4 to point to login

strlen:                             ; get the length of the login
    lb r21, 0(r4)                   ; downoad first symbol of login to r21
    beq r21, r0, strlen_finish      ; if \0, end loop (jump to strlen_finish)
    daddi r20, r20, 1               ; length++ (r20)
    daddi r4, r4, 1                 ; move to the next symbol
    jal strlen                      ; continue loop
    
strlen_finish:                      ; reorganize values for main part
    daddi r20, r20, -1              ; we need length-1 for our realisation
    add r10, r0, r20                ; move new length to r10
    daddi   r4, r0, login           ; reset pointer to login
    daddi r1, r0, 0                 ; set swap flag (r1) to 0

inner_loop:                         ; main part of the bubble sort     
    lb r7, 0(r4)                    ; load first symbol to r7
    lb r8, 1(r4)                    ; and the next to r8
    sub r16, r8, r7                 ; compare using substitution
    bgez r16, no_swap               ; if first symbo; < next, do not swap
    sb r8, 0(r4)                    ; swap symbols (1)
    sb r7, 1(r4)                    ; swap symbols (2)
    daddi r1, r0, 1                 ; swap made, set flag  
                
no_swap:                            ; if no swaps were made or when we got here
    daddi   r4, r4, 1               ; move to the next symbol
    daddi r10, r10, -1              ; length-- (r10)
    beq r10, r0, half_end           ; if length is 0, jump to half_end
    jal inner_loop                  ; otherwise continue loop with updated values

half_end:                           ; decide if it is the end of bubble sort
    beq r1, r0, end                 ; end if no swaps on iteration were made
    daddi   r4, r0, login           ; reset pointer to login
    daddi r1, r0, 0                 ; reset swap flag
    add r10, r0, r20                ; reset length
    jal inner_loop                  ; go to the next iteration
    
end:                                ; when succesfully sorted
    daddi   r4, r0, login           ; reset pointer to login
    jal print_string                ; write sorted string to output
    syscall 0;                      ; stop
                                    
print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address

