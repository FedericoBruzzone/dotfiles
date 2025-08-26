" Vim syntax file
" Language: Gaetano D'Agostino
"
if exists("b:current_syntax")
  finish
endif

syn keyword slKeywords state machine
syn keyword slOperators  on 
syn keyword slStorageModifiers if else
syn match slOperators '=>'


let b:current_syntax = "sl"

hi def link slKeywords Statement
hi def link slOperators Operator
hi def link slStorageModifiers StorageClass