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
  (* e1 < d2 *)
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

let test_result = runml double

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

exception TypeError

(* You can invoke "fresh_tyvar()" to generate a fresh type variable *)
let tyvar_num = ref 0
let fresh_tyvar () = (tyvar_num := !tyvar_num + 1; (TyVar ("t" ^ string_of_int !tyvar_num)))

let typecheck : program -> typ 
=fun exp -> raise TypeError (* TODO *)