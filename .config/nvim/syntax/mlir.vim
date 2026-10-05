" Vim syntax file
" Language:   mlir
" Maintainer: The MLIR team, http://github.com/tensorflow/mlir/
" Version:      $Revision$
" Some parts adapted from the LLVM vim syntax file.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match

" Types.
syn keyword mlirType index f16 f32 f64 bf16 f80 f128 tf32 none
" Signless integer types.
syn match mlirType /\<i\d\+\>/
" Unsigned integer types.
syn match mlirType /\<ui\d\+\>/
" Signed integer types.
syn match mlirType /\<si\d\+\>/
" Float8 types.
syn match mlirType /\<f8E[0-9A-Za-z]\+\>/

" Elemental types inside memref, tensor, or vector types (fixed: | → \|).
syn match mlirType /x\s*\zs\(bf16\|f16\|f32\|f64\|f80\|f128\|i\d\+\|ui\d\+\|si\d\+\)/

" Shaped types.
syn match mlirType /\<memref\ze\s*<[^>]*>/
syn match mlirType /\<tensor\ze\s*<[^>]*>/
syn match mlirType /\<vector\ze\s*<[^>]*>/
syn match mlirType /\<complex\ze\s*<[^>]*>/
syn match mlirType /\<tuple\ze\s*<[^>]*>/

" vector types inside memref or tensor.
syn match mlirType /x\s*\zsvector/

" General dialect-prefixed operations: linalg.fill, tensor.empty, func.func, arith.addi ...
syn match mlirDialectOp /\<[a-z][a-z0-9_]*\.[a-z_][a-z0-9_.]*\>/

" Operations (legacy flat names, kept for compatibility).
syn keyword mlirOps alloc alloca addf addi and call call_indirect cmpf cmpi
syn keyword mlirOps constant dealloc divf dma_start dma_wait dim exp
syn keyword mlirOps getTensor index_cast load log memref_cast
syn keyword mlirOps memref_shape_cast mulf muli negf powf prefetch rsqrt sitofp
syn keyword mlirOps splat store select sqrt subf subi subview tanh
syn keyword mlirOps view

" Keywords.
syn keyword mlirKeyword
      \ affine_map
      \ affine_set
      \ attributes
      \ dense
      \ else
      \ for
      \ func
      \ if
      \ loc
      \ module
      \ opaqueelements
      \ region
      \ return
      \ step
      \ to
      \ type
      \ value

" Misc syntax.
syn match   mlirNumber /-\?\<\d\+\>/
syn match   mlirNumber /-\?\<\d\+\ze\s*x/
syn match   mlirNumber /x\s*\zs-\?\d\+\ze\s*x/

syn match   mlirFloat  /-\?\<\d\+\.\d*\(e[+-]\d\+\)\?\>/
syn match   mlirFloat  /\<0x\x\+\>/
syn keyword mlirBoolean true false
syn match   mlirComment /\/\/.*$/ contains=@Spell
syn region  mlirString start=/"/ skip=/\\"/ end=/"/
syn match   mlirLabel /[-a-zA-Z$._][-a-zA-Z$._0-9]*:/
syn match   mlirIdentifier /[%@][a-zA-Z$._-][a-zA-Z0-9$._-]*/
syn match   mlirIdentifier /[%@]\d\+\>/
syn match   mlirBlockIdentifier /\^[a-zA-Z$._-][a-zA-Z0-9$._-]*/
syn match   mlirBlockIdentifier /\^\d\+\>/
syn match   mlirTypeIdentifier /![a-zA-Z$._-][a-zA-Z0-9$._-]*/
syn match   mlirTypeIdentifier /!\d\+\>/
syn match   mlirAttrIdentifier /#[a-zA-Z$._-][a-zA-Z0-9$._-]*/
syn match   mlirAttrIdentifier /#\d\+\>/

" Lit test commands.
syn match  mlirSpecialComment /\/\/\s*RUN:.*$/
syn match  mlirSpecialComment /\/\/\s*CHECK:.*$/
syn match  mlirSpecialComment "\v\/\/\s*CHECK-(NEXT|NOT|DAG|SAME|LABEL):.*$"
syn match  mlirSpecialComment /\/\/\s*expected-error.*$/
syn match  mlirSpecialComment /\/\/\s*expected-remark.*$/
syn match  mlirSpecialComment /;\s*XFAIL:.*$/
syn match  mlirSpecialComment /\/\/\s*PR\d*\s*$/
syn match  mlirSpecialComment /\/\/\s*REQUIRES:.*$/

if version >= 508 || !exists("did_c_syn_inits")
  if version < 508
    let did_c_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink mlirType         Type
  HiLink mlirOps          Statement
  HiLink mlirDialectOp    Statement
  HiLink mlirNumber       Number
  HiLink mlirComment      Comment
  HiLink mlirString       String
  HiLink mlirLabel        Label
  HiLink mlirKeyword      Keyword
  HiLink mlirBoolean      Boolean
  HiLink mlirFloat        Float
  HiLink mlirConstant     Constant
  HiLink mlirSpecialComment SpecialComment
  HiLink mlirIdentifier   Identifier
  HiLink mlirBlockIdentifier Label
  HiLink mlirTypeIdentifier Type
  HiLink mlirAttrIdentifier PreProc

  delcommand HiLink
endif

let b:current_syntax = "mlir"
