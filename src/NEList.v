Require Import Coq.Lists.List.

Record NEList (A : Type) : Type :=
  MkNEList { head : A
           ; tail : list A
           }.

Arguments MkNEList {_}.
Arguments head {_}.
Arguments tail {_}.

Section NEList.

Context {A B : Type}.

Definition toList (xxs : NEList A) : list A := cons (head xxs) (tail xxs).
Definition fromList (xs : list A) : option (NEList A) :=
match xs with
 | nil       => None
 | cons x xs => Some (MkNEList x xs)
end.

Definition map (f : A -> B) (xxs : NEList A) : NEList B :=
  MkNEList (f (head xxs)) (List.map f (tail xxs)).

Definition cons (hd : A) (tl : NEList A) : NEList A := MkNEList hd (toList tl).
Definition singleton (x : A) : NEList A := MkNEList x nil.

Definition foldl (c : B -> A -> B) (xxs : NEList A) (n : B) : B := List.fold_left c (toList xxs) n.
Definition foldr (c : A -> B -> B) (n : B) (xxs : NEList A) : B := List.fold_right c n (toList xxs).

Definition foldl1 (c : A -> A -> A) (xxs : NEList A) : A := List.fold_left c (tail xxs) (head xxs).
Definition foldr1 (c : A -> A -> A) (xxs : NEList A) : A :=
  (fix rec (x : A) (xs : list A) := match xs with
                    | nil            => x
                    | List.cons y ys => c x (rec y ys)
                   end)
  (head xxs) (tail xxs).

End NEList.

Definition append {A} (xxs : NEList A) (yys : NEList A) : NEList A :=
  foldr cons yys xxs.