" Put this file in ~/.config/nvim/syntax/ in order to enable syntax highlighting
if exists("b:current_syntax")
  finish
endif

syntax clear

" Keywords
syn keyword ql.questionnarielanguageControl form boolean int long float double char string money date

" Operators
syn keyword ql.questionnarielanguageOperator ! + - * / == != > < >= <= && || ? <|

" Constants
syn keyword ql.questionnarielanguageConstant true false

" Comments
syn match ql.questionnarielanguageComment "//.*$"
syn region ql.questionnarielanguageComment start="/\\*" end="\\*/"

" String
syn match ql.questionnarielanguageString /".*"/

" Highlighting
hi def link ql.questionnarielanguageControl Keyword
hi def link ql.questionnarielanguageOperator Operator
hi def link ql.questionnarielanguageConstant Constant
hi def link ql.questionnarielanguageComment Comment
hi def link ql.questionnarielanguageString String

let b:current_syntax = "ql.questionnarielanguage"


