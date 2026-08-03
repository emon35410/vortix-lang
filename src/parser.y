%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;

void yyerror(const char *s);

/* ভেরিয়েবল সংরক্ষণের জন্য Symbol Table */
struct Var {
    char name[50];
    int value;
} sym_table[100];

int sym_count = 0;

void set_var(char *name, int val) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(sym_table[i].name, name) == 0) {
            sym_table[i].value = val;
            return;
        }
    }
    strcpy(sym_table[sym_count].name, name);
    sym_table[sym_count].value = val;
    sym_count++;
}

int get_var(char *name) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(sym_table[i].name, name) == 0) {
            return sym_table[i].value;
        }
    }
    return 0; 
}

/* Abstract Syntax Tree (AST) নোডের ধরন */
typedef enum { 
    N_NUM, N_ID, N_OP, N_ASSIGN, N_IF, N_WHILE, N_FOR, N_PRINT, N_SEQ 
} NodeType;

/* AST নোডের স্ট্রাকচার */
typedef struct ASTNode {
    NodeType type;
    int num;
    char *str;
    int op;
    struct ASTNode *left, *right, *cond, *if_branch, *else_branch;
} ASTNode;

/* নতুন নোড তৈরি করার ফাংশন */
ASTNode* new_node(NodeType type) {
    ASTNode* n = (ASTNode*)malloc(sizeof(ASTNode));
    n->left = n->right = n->cond = n->if_branch = n->else_branch = NULL;
    n->str = NULL;
    n->type = type;
    return n;
}

/* বিভিন্ন কাজের জন্য ট্রি-নোড জেনারেটর */
ASTNode* m_num(int v) { ASTNode* n = new_node(N_NUM); n->num = v; return n; }
ASTNode* m_id(char* s) { ASTNode* n = new_node(N_ID); n->str = strdup(s); return n; }
ASTNode* m_op(int op, ASTNode* l, ASTNode* r) { ASTNode* n = new_node(N_OP); n->op = op; n->left = l; n->right = r; return n; }
ASTNode* m_assign(char* s, ASTNode* v) { ASTNode* n = new_node(N_ASSIGN); n->str = strdup(s); n->left = v; return n; }
ASTNode* m_if(ASTNode* c, ASTNode* i, ASTNode* e) { ASTNode* n = new_node(N_IF); n->cond = c; n->if_branch = i; n->else_branch = e; return n; }
ASTNode* m_while(ASTNode* c, ASTNode* b) { ASTNode* n = new_node(N_WHILE); n->cond = c; n->if_branch = b; return n; }
ASTNode* m_for(ASTNode* init, ASTNode* cond, ASTNode* inc, ASTNode* body) { 
    ASTNode* n = new_node(N_FOR); 
    n->left = init; n->cond = cond; n->right = inc; n->if_branch = body; 
    return n; 
}
ASTNode* m_print_expr(ASTNode* e) { ASTNode* n = new_node(N_PRINT); n->left = e; return n; }
ASTNode* m_print_str(char* s) {
    ASTNode* n = new_node(N_PRINT);
    s[strlen(s)-1] = '\0'; /* শেষের কোটেশন (") বাদ দেওয়া */
    n->str = strdup(s+1);  /* শুরুর কোটেশন (") বাদ দেওয়া */
    return n;
}
ASTNode* m_seq(ASTNode* s1, ASTNode* s2) { ASTNode* n = new_node(N_SEQ); n->left = s1; n->right = s2; return n; }

ASTNode* root = NULL; /* ট্রির মূল (Root) */
int eval(ASTNode* n); /* এক্সিকিউট ফাংশন ডিক্লারেশন */

%}

%union {
    int num;
    char *str;
    struct ASTNode* ast;
}

%token <str> ID STRING
%token <num> NUMBER
%token FLUX PATH DIVERT ORBIT SPIN BEAM ABSORB
%token EQ NEQ GT LT

%type <ast> program statements statement declaration assignment if_statement loop_statement for_statement for_init print_statement condition expression

%left '+' '-'
%left '*' '/' '%'

%%

program:
    statements { root = $1; }
    ;

statements:
    statement { $$ = $1; }
    | statements statement { $$ = m_seq($1, $2); }
    ;

statement:
    declaration { $$ = $1; }
    | assignment { $$ = $1; }
    | if_statement { $$ = $1; }
    | loop_statement { $$ = $1; }
    | for_statement { $$ = $1; }
    | print_statement { $$ = $1; }
    | input_statement { $$ = NULL; /* আপাতত ইনপুট স্কিপ করা হলো */ }
    ;

declaration:
    FLUX ID '=' expression { $$ = m_assign($2, $4); free($2); }
    ;

assignment:
    ID '=' expression { $$ = m_assign($1, $3); free($1); }
    ;

if_statement:
    PATH '(' condition ')' '{' statements '}' { $$ = m_if($3, $6, NULL); }
    | PATH '(' condition ')' '{' statements '}' DIVERT '{' statements '}' { $$ = m_if($3, $6, $10); }
    ;

loop_statement:
    ORBIT '(' condition ')' '{' statements '}' { $$ = m_while($3, $6); }
    ;

for_init:
    declaration { $$ = $1; }
    | assignment { $$ = $1; }
    ;

for_statement:
    SPIN '(' for_init ';' condition ';' assignment ')' '{' statements '}' { $$ = m_for($3, $5, $7, $10); }
    ;

print_statement:
    BEAM '(' expression ')' { $$ = m_print_expr($3); }
    | BEAM '(' STRING ')' { $$ = m_print_str($3); free($3); }
    ;

input_statement:
    ABSORB '(' ID ')' { free($3); }
    ;

condition:
    expression EQ expression { $$ = m_op(EQ, $1, $3); }
    | expression NEQ expression { $$ = m_op(NEQ, $1, $3); }
    | expression GT expression { $$ = m_op(GT, $1, $3); }
    | expression LT expression { $$ = m_op(LT, $1, $3); }
    ;

expression:
    NUMBER { $$ = m_num($1); }
    | ID { $$ = m_id($1); free($1); }
    | expression '+' expression { $$ = m_op('+', $1, $3); }
    | expression '-' expression { $$ = m_op('-', $1, $3); }
    | expression '*' expression { $$ = m_op('*', $1, $3); }
    | expression '/' expression { $$ = m_op('/', $1, $3); }
    | expression '%' expression { $$ = m_op('%', $1, $3); }
    | '(' expression ')' { $$ = $2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

/* AST বা মেমোরি ট্রি এক্সিকিউট করার মূল লজিক */
int eval(ASTNode* n) {
    if (!n) return 0;
    switch (n->type) {
        case N_NUM: return n->num;
        case N_ID: return get_var(n->str);
        case N_OP: {
            int l = eval(n->left);
            int r = eval(n->right);
            if (n->op == '+') return l + r;
            if (n->op == '-') return l - r;
            if (n->op == '*') return l * r;
            if (n->op == '/') { if (r != 0) return l / r; else { printf("Error: Division by zero (Undefined)\n"); return 0; } }
            if (n->op == '%') { if (r != 0) return l % r; else { printf("Error: Modulo by zero (Undefined)\n"); return 0; } }
            if (n->op == GT) return l > r;
            if (n->op == LT) return l < r;
            if (n->op == EQ) return l == r;
            if (n->op == NEQ) return l != r;
            return 0;
        }
        case N_ASSIGN: {
            int v = eval(n->left);
            set_var(n->str, v);
            return v;
        }
        case N_IF: {
            if (eval(n->cond)) eval(n->if_branch);
            else if (n->else_branch) eval(n->else_branch);
            return 0;
        }
        case N_WHILE: {
            while (eval(n->cond)) {
                eval(n->if_branch);
            }
            return 0;
        }
        case N_FOR: {
            for (eval(n->left); eval(n->cond); eval(n->right)) {
                eval(n->if_branch);
            }
            return 0;
        }
        case N_PRINT: {
            if (n->str) printf("%s\n", n->str);
            else printf("%d\n", eval(n->left));
            return 0;
        }
        case N_SEQ: {
            eval(n->left);
            eval(n->right);
            return 0;
        }
    }
    return 0;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Error opening file");
            return 1;
        }
        yyin = file;
    }
    
    printf("Vortix Compiler Parsing...\n");
    yyparse();
    
    if (root) {
        printf("\n=== VORTIX EXECUTION OUTPUT ===\n");
        eval(root);
        printf("===============================\n");
    }
    
    return 0;
}