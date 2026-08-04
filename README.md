# Vortix Programming Language 🚀

Vortix is a dynamic, minimalistic, and procedural interpreted programming language built from scratch using **C, Flex, and Bison**. It features an Abstract Syntax Tree (AST) based execution model and uses intuitive, futuristic keywords for a unique, action-oriented coding experience.

---

## 🧠 Under the Hood (Architecture)

Unlike simple interpreters that execute code line-by-line instantly, Vortix follows a modern compiler design pipeline:

1. **Lexical Analysis (Flex):** Reads the `.vtx` source code and converts raw text into meaningful tokens (e.g., matching `flux` to the `FLUX` token).
2. **Syntax Analysis (Bison):** Verifies that the sequence of tokens follows the Vortix grammar rules.
3. **AST Construction:** Instead of executing immediately, the parser builds an **Abstract Syntax Tree (AST)** in memory. This hierarchical tree represents the logical structure of the program.
4. **Execution Phase (C):** A recursive evaluation function traverses the AST root node, handling logic loops, resolving variable scopes via a **Symbol Table**, and executing the final operations.

---

## ✨ Core Features

- **Custom Lexer & Parser:** Robust tokenization and grammar handling.
- **AST Execution:** Stable logic handling, allowing for complex nested loops and conditional branches.
- **Dynamic Variables:** Dynamically assigned integers safely stored and updated in a memory Symbol Table.
- **Control Flow:** Full support for conditional statements (`if-else`) and iterators (`while`, `for`).
- **I/O Operations:** Read inputs dynamically from the terminal and print outputs seamlessly.
- **Safety First:** Built-in error handling for mathematical impossibilities (e.g., graceful fallbacks for Division/Modulo by zero).

---

## 📖 Keyword Dictionary

Vortix replaces traditional programming keywords with futuristic, action-oriented terms:

| Vortix Keyword | Traditional Equivalent | Purpose |
| :--- | :--- | :--- |
| `flux` | `let` / `var` | Variable declaration and assignment. |
| `path` | `if` | Conditional statement (True branch). |
| `divert` | `else` | Conditional statement (False branch). |
| `orbit` | `while` | Loop statement based on a continuous condition. |
| `spin` | `for` | Iterative loop statement with initialization and steps. |
| `beam` | `print` | Output data (strings, variables, or expressions) to the console. |
| `absorb` | `input` | Take integer input from the user at runtime. |

---

## 🧮 Supported Operators

| Type | Operators | Example |
| :--- | :--- | :--- |
| **Arithmetic** | `+`, `-`, `*`, `/`, `%` | `flux x = 10 % 3` |
| **Relational** | `==`, `!=`, `<`, `>` | `path (x > 5)` |
| **Assignment** | `=` | `x = 20` |

---

## 💻 Example Program

Create a file named `demo.vtx` and write your first Vortix code:

```text
beam("--- Vortix Operations Test ---")
flux userValue = 0
beam("Please enter a number:")
absorb(userValue)
path (userValue % 2 == 0) {
    beam("You entered an EVEN number!")
} divert {
    beam("You entered an ODD number!")
}
beam("--- Spin (For) Loop Execution ---")
spin (flux i = 1; i < 4; i = i + 1) {
    beam("Spinning...")
    beam(i)
}
```

---

## 🛠️ Prerequisites

To compile and run Vortix, you need the following tools installed on your Linux/WSL environment:

- GCC (GNU Compiler Collection)
- Flex (Fast Lexical Analyzer)
- Bison (GNU Parser Generator)
- Make (Build automation tool)

---

## 🚀 Build & Run (Usage)

Thanks to the included Makefile, compiling the language is just one command away.

**1. Compile the project:**

```bash
make
```

**2. Run a Vortix script:**

```bash
./vortix demo.vtx
```

*(Alternatively, you can use `make run` to instantly compile and execute the default `demo.vtx` script).*

**3. Clean auto-generated files:**

```bash
make clean
```

---

Developed by **Mahmudul Hasan Emon**