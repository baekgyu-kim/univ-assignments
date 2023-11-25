(* Do not open any module *)

(***********************)
(*  Library functions  *)
(***********************)

let rec fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
= fun f accu lst ->
  match lst with
  | [] -> accu
  | hd::tl -> fold_left f (f accu hd) tl

let rec map : ('a -> 'b) -> 'a list -> 'b list
= fun f lst ->
  match lst with
  | [] -> []
  | hd::tl -> (f hd)::(map f tl)

(***********************)
(******  Syntax  *******)
(***********************)

type program = exp
and exp = 
  | UNIT
  | TRUE
  | FALSE
  | CONST of int
  | VAR of var
  | ADD of exp * exp
  | SUB of exp * exp
  | MUL of exp * exp
  | DIV of exp * exp
  | EQUAL of exp * exp
  | LESS of exp * exp
  | NOT of exp
  | NIL
  | CONS of exp * exp      
  | APPEND of exp * exp
  | HEAD of exp
  | TAIL of exp
  | ISNIL of exp
  | IF of exp * exp * exp
  | LET of var * exp * exp
  | LETREC of var * var * exp * exp
  | LETMREC of (var * var * exp) * (var * var * exp) * exp
  | PROC of var * exp
  | CALL of exp * exp
  | PRINT of exp
  | SEQ of exp * exp
and var = string

(***********************)
(**  Example programs **)
(***********************)

(*
  let f = proc (x) (x - 11)
  in (f (f 77))
*)
let proc1 = 
  LET ("f", PROC ("x", SUB (VAR "x", CONST 11)),
    CALL (VAR "f", CALL (VAR "f", CONST 77)))

(*
  ((proc (f) (f (f 77))) (proc (x) (x-11)))
*)
let proc2 = 
  CALL (PROC ("f", CALL (VAR "f", CALL (VAR "f", CONST 77))), 
        PROC ("x", SUB (VAR "x", CONST 11)))

(*
  let x = 1
  in let f = proc (y) (x + y)
     in let x = 2
        in let g = proc (y) (x + y)
        in  (f 1) + (g 1)
*)
let let1 = 
  LET ("x", CONST 1, 
    LET ("f", PROC ("y", ADD (VAR "x", VAR "y")),
      LET ("x", CONST 2, 
         LET ("g", PROC ("y", ADD (VAR "x", VAR "y")), 
            (ADD (CALL (VAR "f", CONST 1), 
                  CALL (VAR "g", CONST 1)))))))

(*
  letrec even(x) = if (x = 0) then true else odd(x-1)
         odd(x) = if (x = 0) then false else even(x-1)
  in (even 13)
*)
let evenodd = 
  LETMREC (("even", "x", IF (EQUAL (VAR "x", CONST 0), TRUE, CALL (VAR "odd",  SUB (VAR "x", CONST 1)))),
           ("odd" , "x", IF (EQUAL (VAR "x", CONST 0), FALSE, CALL (VAR "even", SUB (VAR "x", CONST 1)))),
  CALL (VAR "odd", CONST 13))


(*
  letrec double(x) = if (x = 0) then 0 else (double (x-1) + 2
  in (double 6)
*)
let double = 
  LETREC ("double", "x", IF (EQUAL (VAR "x", CONST 0), 
                            CONST 0, 
                            ADD (CALL (VAR "double", SUB (VAR "x", CONST 1)) , 
                                 CONST 2)), 
    CALL (VAR "double", CONST 6))

(*
letrec factorial(x) = 
         if (x = 0) then 1 
         else factorial(x-1) * x
in letrec loop n = 
     if (n = 0) then ()
     else (print (factorial n); loop (n-1))
   in (loop 10)
*)
let fact = 
LETREC ("factorial", "x", 
          IF (EQUAL (VAR "x", CONST 0), CONST 1, 
              MUL (CALL (VAR "factorial", SUB (VAR "x", CONST 1)), VAR "x")), 
  LETREC ("loop", "n", 
    IF (EQUAL (VAR "n", CONST 0), UNIT, 
        SEQ (PRINT (CALL (VAR "factorial", VAR "n")), 
             CALL (VAR "loop", SUB(VAR "n", CONST 1)))), 
      CALL (VAR "loop", CONST 10)))
           
(*
in letrec range(n) = 
      if (n = 1) then (cons 1 nil)
      else n::(range (n-1))
in (range 10)
*)
let range = 
LETREC ("range", "n", 
            IF (EQUAL (VAR "n", CONST 1), CONS (CONST 1, NIL),
                CONS (VAR "n", CALL (VAR "range", SUB (VAR "n", CONST 1)))), 
     CALL (VAR "range", CONST 10))

(*
letrec reverse(l) = 
  if (isnil l) then []
  else (reverse (tl l)) @ (cons hd l)
in (reverse (cons (1, cons (2, cons (3, nil)))))
*)
let reverse = 
LETREC ("reverse", "l", 
          IF (ISNIL (VAR "l"), NIL, 
              APPEND (CALL (VAR "reverse", TAIL (VAR "l")), 
                      CONS (HEAD (VAR "l"), NIL))), 
     CALL (VAR "reverse", 
           CONS (CONST 1, CONS (CONST 2, CONS (CONST 3, NIL)))))

let reverse2 = 
LETREC ("reverse", "l", 
          IF (ISNIL (VAR "l"), NIL, 
              APPEND (CALL (VAR "reverse", TAIL (VAR "l")), 
                      CONS (HEAD (VAR "l"), NIL))), 
     CALL (VAR "reverse", 
           CONS (CONS (CONST 1, NIL), CONS (CONS (CONST 2, NIL), CONS (CONS (CONST 3, NIL), NIL)))))


let zfact = 
  LET ("fix", 
    PROC ("f", 
      CALL (PROC ("x", CALL (VAR "f", PROC ("y", CALL (CALL (VAR "x", VAR "x"), VAR "y")))), 
            PROC ("x", CALL (VAR "f", PROC ("y", CALL (CALL (VAR "x", VAR "x"), VAR "y")))))),
    LET ("f", CALL (VAR "fix", 
            PROC ("f", PROC ("x", 
          IF (EQUAL (VAR "x", CONST 0), CONST 1, 
              MUL (CALL (VAR "f", SUB (VAR "x", CONST 1)), VAR "x"))))), 
           CALL (VAR "f", CONST 10)))

let zrange = 
  LET ("fix", 
    PROC ("f", 
      CALL (PROC ("x", CALL (VAR "f", PROC ("y", CALL (CALL (VAR "x", VAR "x"), VAR "y")))), 
            PROC ("x", CALL (VAR "f", PROC ("y", CALL (CALL (VAR "x", VAR "x"), VAR "y")))))),


    LET ("f", CALL (VAR "fix", 
            PROC ("range", PROC ("n", 
               IF (EQUAL (VAR "n", CONST 1), CONS (CONST 1, NIL),
                 CONS (VAR "n", CALL (VAR "range", SUB (VAR "n", CONST 1))))))), 
           CALL (VAR "f", CONST 10)))

let poly = 
    LET ("f", PROC("x", VAR "x"), 
      IF(CALL (VAR "f", TRUE), CALL (VAR "f", CONST 1), CALL (VAR "f", CONST 2)))

let lst =
    CONS (CONST 1, CONS (CONST 2, CONS (TRUE, NIL)))

(***********************)
(*****  Problem 1  *****)
(***********************)

type value = 
  | Unit 
  | Int of int 
  | Bool of bool 
  | List of value list
  | Procedure of var * exp * env 
  | RecProcedure of var * var * exp * env
  | MRecProcedure of var * var * exp *
                     var * var * exp * env
and env = (var * value) list

exception UndefinedSemantics

let rec string_of_value v = 
  match v with
  | Int n -> string_of_int n
  | Bool b -> string_of_bool b
  | List lst -> "[" ^ fold_left (fun s x -> s ^ ", " ^ x) "" (map string_of_value lst) ^ "]"
  | _ -> "(functional value)"

let empty_env = []
let extend_env (x,v) e = (x,v)::e
let rec lookup_env x e = 
  match e with
  | [] -> raise (Failure ("variable " ^ x ^ " is not bound in env")) 
  | (y,v)::tl -> if x = y then v else lookup_env x tl
  
let rec eval : exp -> env -> value 
=fun exp env ->
  match exp with
  (* () *)
  | UNIT -> Unit
  (* true *)
  | TRUE -> Bool true
  (* false *)
  | FALSE -> Bool false
  (* n *)
  | CONST n -> Int n
  (* x *)
  | VAR x -> lookup_env x env
  (* e1 + e2 *)
  | ADD (e1, e2) ->
    let e1_v = eval e1 env in
    let e2_v = eval e2 env in
      (match (e1_v, e2_v) with
      | (Int e1_v_int, Int e2_v_int) -> Int (e1_v_int + e2_v_int)
      | _ -> raise (UndefinedSemantics))
  (* e1 - e2 *)
  | SUB (e1, e2) ->
    let e1_v = eval e1 env in
    let e2_v = eval e2 env in
      (match (e1_v, e2_v) with
      | (Int e1_v_int, Int e2_v_int) -> Int (e1_v_int - e2_v_int)
      | _ -> raise (UndefinedSemantics))
  (* e1 * e2 *)
  | MUL (e1, e2) ->
    let e1_v = eval e1 env in
    let e2_v = eval e2 env in
      (match (e1_v, e2_v) with
      | (Int e1_v_int, Int e2_v_int) -> Int (e1_v_int * e2_v_int)
      | _ -> raise (UndefinedSemantics))
  (* e1 / e2 *)
  | DIV (e1, e2) ->
    let e1_v = eval e1 env in
    let e2_v = eval e2 env in
      (match (e1_v, e2_v) with
      | (Int e1_v_int, Int e2_v_int) -> 
        if e2_v_int = 0 then raise (UndefinedSemantics)
        else Int (e1_v_int / e2_v_int)
      | _ -> raise (UndefinedSemantics))
  (* e1 = e2 *)
  | EQUAL (e1, e2) ->
    let e1_v = eval e1 env in
    let e2_v = eval e2 env in
      (match (e1_v, e2_v) with
      | (Int e1_v_int, Int e2_v_int) -> Bool (e1_v_int = e2_v_int)
      | (Bool e1_v_bool, Bool e2_v_bool) -> Bool (e1_v_bool = e2_v_bool)
      | (List e1_v_list, List e2_v_list) -> Bool (e1_v_list = e2_v_list)
      | _ -> raise (UndefinedSemantics))
  (* e1 < e2 *)
  | LESS (e1, e2) ->
    let e1_v = eval e1 env in
    let e2_v = eval e2 env in
      (match (e1_v, e2_v) with
      | (Int e1_v_int, Int e2_v_int) -> Bool (e1_v_int < e2_v_int)
      | _ -> raise (UndefinedSemantics))
  (* NOT e *)
  | NOT e ->
    let e_val = eval e env in
      (match e_val with
      | Bool e_val_bool -> Bool (not e_val_bool)
      | _ -> raise (UndefinedSemantics))
  (* nil *)
  | NIL -> List []
  (* e1 :: e2 *)
  | CONS (e1, e2) ->  
    let e1_v = eval e1 env in
    let e2_v = eval e2 env in
      (match e2_v with
      | List e2_v_list -> List (e1_v::e2_v_list)
      | _ -> raise (UndefinedSemantics))  
  (* e1 @ e2 *)   
  | APPEND (e1, e2) ->
    let e1_v = eval e1 env in
    let e2_v = eval e2 env in
      (match (e1_v, e2_v) with
      | (List e1_v_list, List e2_v_list) -> List (e1_v_list @ e2_v_list)
      | _ -> raise (UndefinedSemantics))
  (* head e *)
  | HEAD e ->
    let e_val = eval e env in
      (match e_val with
      | List (hd::tl) -> hd
      | _ -> raise (UndefinedSemantics))
  (* tail e *)
  | TAIL e ->
    let e_val = eval e env in
      (match e_val with
      | List (hd::tl) -> List tl
      | _ -> raise (UndefinedSemantics))
  (* isnil e *)
  | ISNIL e ->
    let e_val = eval e env in
      (match e_val with
      | List [] -> Bool true
      | List _ -> Bool false
      | _ -> raise (UndefinedSemantics))
  (* if e1 then e2 else e3 *)
  | IF (e1, e2, e3) ->
    let e1_v = eval e1 env in
      (match e1_v with
      | Bool true -> eval e2 env
      | Bool false -> eval e3 env
      | _ -> raise (UndefinedSemantics))
  (* let x = e1 in e2 *)
  | LET (x, e1, e2) ->
    let e1_v = eval e1 env in
    eval e2 (extend_env (x, e1_v) env)
  (* letrec f(x) = e1 in e2 *)
  | LETREC (f, x, e1, e2) ->
    let f_added_env = extend_env (f, RecProcedure (f, x, e1, env)) env in
    eval e2 f_added_env 
  (* letrec f(x) = e1 and g(y) = e2 in e3 *)
  | LETMREC ((f, x, e1), (g, y, e2), e3) ->
    let f_added_env = extend_env (f, MRecProcedure (f, x, e1, g, y, e2, env)) env in
    let f_and_g_added_env = extend_env (g, MRecProcedure (g, y, e2, f, x, e1, env)) f_added_env in
    eval e3 f_and_g_added_env
  (* proc x e *)
  | PROC (x, e) ->
    Procedure (x, e, env)
  (* e1: 함수이름 e2: 인자 *)
  | CALL (e1, e2) ->
    let e1_v_proc = eval e1 env in
    let e2_v_param = eval e2 env in
    (match e1_v_proc with
    (* e1_val_proc이 일반 함수의 closure인 경우 *)
    | Procedure (x, e, env') ->
      let x_added_env' = extend_env (x, e2_v_param) env' in
      eval e x_added_env'
    (* e1_val_proc이 recursive procedure의 closure인 경우 *)
    | RecProcedure (f, x, e, env') ->
      let x_added_env' = extend_env (x, e2_v_param) env' in
      let x_and_f_added_env' = extend_env (f, RecProcedure (f, x, e, env')) x_added_env' in
      eval e x_and_f_added_env'
    (* e1_val_proc이 mutually recursive procedure의 closure인 경우 *)
    | MRecProcedure (f, x, ef, g, y, eg, env') ->
      let x_added_env' = extend_env (x, e2_v_param) env' in
      let x_and_f_added_env' = extend_env (f, MRecProcedure (f, x, ef, g, y, eg, env')) x_added_env' in
      let x_and_f_and_g_added_env' = extend_env (g, MRecProcedure (g, y, eg, f, x, ef, env')) x_and_f_added_env' in
      eval ef x_and_f_and_g_added_env'
    | _ -> raise (UndefinedSemantics))
  (* print e *)
  | PRINT e -> (print_endline (string_of_value (eval e env)); Unit)
  (* e1; e2 *)
  | SEQ (e1, e2) ->
    let _ = eval e1 env in
    eval e2 env
  |_ -> raise (Failure "Not implemented")

let runml : program -> value 
= fun pgm -> eval pgm empty_env


(***********************)
(*****  Problem 2  *****)
(***********************)

type typ = 
    TyUnit 
  | TyInt 
  | TyBool 
  | TyFun of typ * typ 
  | TyList of typ
  | TyVar of tyvar
and tyvar = string
and tyenv = (tyvar * typ) list

exception TypeError

(* You can invoke "fresh_tyvar()" to generate a fresh type variable *)
let tyvar_num = ref 0
let fresh_tyvar () = (tyvar_num := !tyvar_num + 1; (TyVar ("t" ^ string_of_int !tyvar_num)))

(* 타입 환경 *)
let empty_tyenv = []
let extend_tyenv (x,v) e = (x,v)::e
let rec lookup_tyenv e x = 
  match e with
  | [] -> raise (Failure ("type_variable " ^ x ^ " is not bound in tyenv")) 
  | (y,v)::tl -> if x = y then v else lookup_tyenv tl x


(* Substitution *)
type subst = (tyvar * typ) list
let empty_subst = []

let rec find_subst x = function
  | [] -> raise (Failure "Substitution Not found")
  | (key, value)::rest ->
    if key = x then value
    else find_subst x rest

let rec apply_subst : typ -> subst -> typ
=fun typ subst ->
  match typ with
  | TyUnit -> TyUnit
  | TyInt -> TyInt
  | TyBool -> TyBool
  | TyList t -> TyList (apply_subst t subst)
  | TyFun (t1,t2) -> TyFun (apply_subst t1 subst, apply_subst t2 subst)
  | TyVar x -> try find_subst x subst with _ -> typ

let rec map f lst =
  match lst with
  | [] -> []
  | x :: xs -> f x :: map f xs

let extend_subst tv ty subst =
  (tv, ty) :: (map (fun (x, t) -> (x, apply_subst t [(tv, ty)])) subst)

type typ_eqn = (typ * typ) list

let rec gen_equations : tyenv -> exp -> typ -> typ_eqn
=fun tenv e ty -> 
  match e with
  | UNIT -> [(ty, TyUnit)]
  | TRUE -> [(ty, TyBool)]
  | FALSE -> [(ty, TyBool)]
  | CONST n -> [(ty, TyInt)]
  | VAR x -> [(ty, lookup_tyenv tenv x)]
  | ADD (e1, e2) -> [(ty, TyInt)] @ (gen_equations tenv e1 TyInt) @ (gen_equations tenv e2 TyInt)
  | SUB (e1, e2) -> [(ty, TyInt)] @ (gen_equations tenv e1 TyInt) @ (gen_equations tenv e2 TyInt)
  | MUL (e1, e2) -> [(ty, TyInt)] @ (gen_equations tenv e1 TyInt) @ (gen_equations tenv e2 TyInt)
  | DIV (e1, e2) -> [(ty, TyInt)] @ (gen_equations tenv e1 TyInt) @ (gen_equations tenv e2 TyInt)
  | EQUAL (e1, e2) -> [(ty, TyBool)] @ (gen_equations tenv e1 TyInt) @ (gen_equations tenv e2 TyInt)
  | LESS (e1, e2) -> [(ty, TyBool)] @ (gen_equations tenv e1 TyInt) @ (gen_equations tenv e2 TyInt)
  | NOT e -> [(ty, TyBool)] @ (gen_equations tenv e TyBool)
  | NIL -> [(ty, TyList (fresh_tyvar ()))]
  | CONS (e1, e2) -> 
    let t = fresh_tyvar () in
    [(ty, TyList t)] @ (gen_equations tenv e1 t) @ (gen_equations tenv e2 (TyList t))
  | APPEND (e1, e2) ->
    let t = fresh_tyvar () in
    [(ty, TyList t)] @ (gen_equations tenv e1 (TyList t)) @ (gen_equations tenv e2 (TyList t))
  | HEAD e ->
    let t = fresh_tyvar () in
    [(ty, t)] @ (gen_equations tenv e (TyList t))
  | TAIL e ->
    let t = fresh_tyvar () in
    [(ty, TyList t)] @ (gen_equations tenv e (TyList t))
  | ISNIL e -> [(ty, TyBool)] @ (gen_equations tenv e (TyList (fresh_tyvar ())))
  | IF (e1, e2, e3) -> (gen_equations tenv e1 TyBool) @ (gen_equations tenv e2 ty) @ (gen_equations tenv e3 ty)
  | LET (x, e1, e2) -> 
    let t = fresh_tyvar () in
    let x_added_tyenv = extend_tyenv (x, t) tenv in
    (gen_equations tenv e1 t) @ (gen_equations x_added_tyenv e2 ty)
  | LETREC (f, x, e1, e2) ->
    let tx = fresh_tyvar () in
    let t1 = fresh_tyvar () in
    let f_added_tyenv = extend_tyenv (f, TyFun (tx, t1)) tenv in
    let f_x_added_tyenv = extend_tyenv (x, tx) f_added_tyenv in
    (gen_equations f_x_added_tyenv e1 t1) @ (gen_equations f_added_tyenv e2 ty)
  | LETMREC ((f, x1, e1), (g, x2, e2), e3) ->
    let tx1 = fresh_tyvar () in
    let t1 = fresh_tyvar () in
    let tx2 = fresh_tyvar () in
    let t2 = fresh_tyvar () in
    let f_added_tyenv = extend_tyenv (f, TyFun (tx1, t1)) tenv in
    let f_g_added_tyenv = extend_tyenv (g, TyFun (tx2, t2)) f_added_tyenv in
    let f_g_x1_added_tyen = extend_tyenv (x1, tx1) f_g_added_tyenv in
    let f_g_x2_added_tyenv = extend_tyenv (x2, tx2) f_g_added_tyenv in
    (gen_equations f_g_x1_added_tyen e1 t1) @ (gen_equations f_g_x2_added_tyenv e2 t2) @ (gen_equations f_g_added_tyenv e3 ty)
  | PROC (x, e) ->
    let t1 = fresh_tyvar () in
    let t2 = fresh_tyvar () in
    let x_added_tyenv = extend_tyenv (x, t1) tenv in
    [(ty, TyFun (t1, t2))] @ (gen_equations x_added_tyenv e t2)
  | CALL (e1, e2) ->
    let new_tyvar = fresh_tyvar () in
    (gen_equations tenv e1 (TyFun (new_tyvar, ty))) @ (gen_equations tenv e2 new_tyvar)
  | PRINT e -> (gen_equations tenv e TyInt) @ [(ty, TyUnit)]
  | SEQ (e1, e2) -> (gen_equations tenv e1 TyUnit) @ (gen_equations tenv e2 ty)
  |_ -> raise (Failure "Exception")

let rec a_occurs_in_t a t = 
  match t with
  | TyUnit -> false
  | TyInt -> false
  | TyBool -> false
  | TyFun (t1, t2) -> (a_occurs_in_t a t1) || (a_occurs_in_t a t2)
  | TyList t' -> a_occurs_in_t a t'
  | TyVar a' -> a = a'

let rec unify : (typ * typ * subst) -> subst
=fun (t1,t2,subst) ->
  match (t1, t2) with
  | (TyUnit, TyUnit) -> subst
  | (TyInt, TyInt) -> subst
  | (TyBool, TyBool) -> subst
  | (TyVar a, TyVar y) -> if a = y then subst else extend_subst a (TyVar y) subst
  | (TyVar a, t) ->
    if a_occurs_in_t a t then raise (Failure "fail to unify")
    else extend_subst a t subst
  | (t, TyVar a) -> unify (TyVar a, t, subst)
  | (TyFun (t1, t2), TyFun (t1', t2')) -> 
    let s' = unify (t1, t1', subst) in
    unify (apply_subst t2 s', apply_subst t2' s', s')
  | (TyList t1, TyList t2) -> unify (t1, t2, subst)
  | (_, _) -> raise (Failure "fail to unify")
 
let rec unify_all : typ_eqn -> subst -> subst
= fun eqn subst ->
  match eqn with
  | [] -> subst
  | (t1, t2) :: rest -> 
    let s' = unify (apply_subst t1 subst, apply_subst t2 subst, subst) in
    unify_all rest s'


let solve : typ_eqn -> subst
=fun eqn -> unify_all eqn empty_subst


let typecheck : program -> typ 
=fun exp ->
let new_tv = fresh_tyvar () in
let eqns = gen_equations empty_tyenv exp new_tv in
let subst = solve eqns in
let ty = apply_subst new_tv subst in
ty


