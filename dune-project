(lang dune 3.19)

(name rocq-lsp-client)

(generate_opam_files true)

(source
 (github proof-ninja/rocq-lsp-client))

(authors "Yoshihiro Imai <y.imai@aist.go.jp>")

(maintainers "Yoshihiro Imai <y.imai@aist.go.jp>")

(license LICENSE)

(documentation https://github.com/proof-ninja/rocq-lsp-client)

(package
 (name rocq-lsp-client)
 (synopsis "A client of Rocq LSP")
 (description "A longer description")
 (depends ocaml dune coq-lsp yojson)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
