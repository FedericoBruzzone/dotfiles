" " Vim syntax file
" if exists("b:current_syntax")
"   finish
" endif
"
" let b:current_syntax = "sl"
"
" syn keyword slKeywords function
" syn keyword slOtherKeywords  return
" syn keyword slConditionalStatements if else
" syn region slComment start="/\*" end="\*/"
" syn match slComment "//.*$"
" " String
"
" hi def link slKeywords Statement
" hi def link slOtherKeywords Keyword
" hi def link slConditionalStatements Conditional
" hi def link slComment Comment
if exists("b:current_syntax")
  finish
endif

syntax clear

" Keywords
syn keyword simplelangControl function return

" Operators
syn keyword simplelangOperator + - * / ==

" Constants
syn keyword simplelangConstant true false

" Comments
syn match simplelangComment "//.*$"
syn region simplelangComment start="/\*" end="\*/"

" String
syn match simplelangString /".*"/

" Highlighting
hi def link simplelangControl Keyword
hi def link simplelangOperator Operator
hi def link simplelangConstant Constant
hi def link simplelangComment Comment
hi def link simplelangString String

let b:current_syntax = "simplelang"
