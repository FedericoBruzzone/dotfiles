" SmallerBasic syntax highlighting

if exists("b:current_syntax")
  finish
endif

syntax clear

" Keywords
syn keyword smallerbasicControl If Then Else EndIf While EndWhile For To Step EndFor Goto Sub EndSub And Or

" Operators
syn keyword smallerbasicOperator = < > >= <= <> + - * /

" Constants
syn keyword smallerbasicConstant true false

" Comments
syn match smallerbasicComment "'.*$" contains=smallerbasicTodo,@Spell
syn region smallerbasicComment start="'\*" end="\*'" contains=smallerbasicTodo,@Spell

" Labels
syn match smallerbasicLabel /^\s*\w\+\s*:/ contains=smallerbasicTodo,@Spell

" Function Calls
syn match smallerbasicFunctionCall /\w\+\s*\(.\{-}\)\@=/ contains=smallerbasicTodo,@Spell

" Variables
syn match smallerbasicVariable /\w\+/ contained

" String
syn match smallerbasicString /".*"/ contains=smallerbasicTodo,@Spell

" Numbers
" syn match smallerbasicNumber /\v\d+(\.\d+)?([Ee]\d+)?/
syn match smallerbasicNumber /\v\d+(\.\d+)?([Ee][+-]?\d+)?/

" Highlighting
" hi def link smallerbasicStatement Statement
" hi def link smallerbasicExpression Statement
hi def link smallerbasicControl Keyword
hi def link smallerbasicConstant Constant
hi def link smallerbasicOperator Operator
hi def link smallerbasicComment Comment
hi def link smallerbasicLabel Label
hi def link smallerbasicFunctionCall Function
hi def link smallerbasicVariable Identifier
hi def link smallerbasicString String
hi def link smallerbasicNumber Number

let b:current_syntax = "smallerbasic"
