# rocq-lsp-client

An OCaml library for programmatic communication with the [rocq-lsp](https://github.com/ejgallego/rocq-lsp) language server.

`rocq-lsp-client` lets you start a `coq-lsp` process from OCaml code, send LSP commands (e.g. `textDocument/hover`, `textDocument/didOpen`), and receive structured responses.

---

## 🚀 Overview

This library provides a lightweight **LSP client** implementation specialized for **rocq-lsp** (the Coq language server).
It is intended for tools or research projects that need to interact with Coq via LSP without relying on an editor.

Internally, it:
- spawns a `rocq-lsp` process,
- communicates using JSON-RPC 2.0 via stdin/stdout,
- and provides OCaml functions for sending requests and parsing responses.

---

## ⚙️ Requirements

Before using this library, make sure that:

- The `rocq-lsp` executable is installed and accessible in your `$PATH`.

You can verify this with:

```bash
$ rocq-lsp --version
```

If the command is not found, install it from the [rocq-lsp repository](https://github.com/ejgallego/rocq-lsp)

## 🛠️ Installation

You can build and install this library using [Dune](https://dune.build/)

```bash
$ dune build
$ dune install
```

## 🧩 Usage Example

see [sample/main.ml]

