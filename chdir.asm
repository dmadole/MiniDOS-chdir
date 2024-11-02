
;  Copyright 2024, David S. Madole <david@madole.net>
;
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License, or
;  (at your option) any later version.
;
;  This program is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with this program.  If not, see <https://www.gnu.org/licenses/>.


            #include include/bios.inc
            #include include/kernel.inc


          ; Executable program header

            org   2000h-6
            dw    start
            dw    end-start
            dw    start

start:      br    skipspc


          ; Build information

            db    11+80h                ; month
            db    2                     ; day
            dw    2024                  ; year
            dw    1                     ; build

            db    'See github.com/dmadole/MiniDOS-chdir for more info',0


skipspc:    lda   ra                    ; skip any leading spaces
            lbz   display
            sdi   ' '
            lbdf  skipspc

            dec   ra                    ; back up to prior character

            glo   ra                    ; save the start of pathname
            plo   rf
            ghi   ra
            phi   rf

getnext:    lda   ra                    ; if at end of pathname
            lbz   gotpath
            sdi   ' '
            lbnf  getnext

            dec   ra                    ; zero terminate pathname
            ldi   0
            str   ra
            inc   ra

skipend:    lda   ra                    ; skip any trailing spaces
            lbz   gotpath
            sdi   ' '
            lbdf  skipend

            sep   scall                 ; if more than one argument
            dw    o_inmsg
            db    'USAGE: chdir [newdir]',13,10,0
            sep   sret


          ; If we got a single argument, pass to O_CHDIR and that's it.

gotpath:    sep   scall                 ; call chdir, return 0 if no error
            dw    o_chdir
            lbnf  return

            sep   scall                 ; else output message
            dw    o_inmsg
            db    'ERROR: Invalid directory name',13,10,0

            ldi   1                     ; and return 1
            sep   sret


          ; If no argument, then call O_CHDIR with null string to get the
          ; currently set path.

display:    ldi   buffer.1              ; pointer to pre-terminated buffer
            phi   rf
            ldi   buffer.0
            plo   rf

            sep   scall                 ; get current working directory
            dw    o_chdir

            sep   scall                 ; display the pathname
            dw    o_msg

            sep   scall                 ; output end of line
            dw    o_inmsg
            db    13,10,0

return:     ldi   0                     ; return success
            sep   sret

buffer:     db    0                     ; buffer to retrieve path
            ds    256

end:        end   begin

