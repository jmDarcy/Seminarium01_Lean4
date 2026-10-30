import Lake
open Lake DSL

package lean_econ_seminar where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @
  "88126f75a3ddb644aad4808bd1381ee4e3242c62"

@[default_target]
lean_lib Seminarium01 where
