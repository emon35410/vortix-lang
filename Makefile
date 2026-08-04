# Compiler and tools
CC = gcc
FLEX = flex
BISON = bison

# Output binary name
TARGET = vortix

# Source files
LEX_SRC = src/lexer.l
BISON_SRC = src/parser.y

# Generated C files
LEX_OUT = src/lex.yy.c
BISON_OUT = src/parser.tab.c
BISON_HDR = src/parser.tab.h

# Build target
all: $(TARGET)

$(TARGET): $(BISON_OUT) $(LEX_OUT)
	$(CC) $(BISON_OUT) $(LEX_OUT) -o $(TARGET)

$(BISON_OUT) $(BISON_HDR): $(BISON_SRC)
	$(BISON) -d -o $(BISON_OUT) $(BISON_SRC)

$(LEX_OUT): $(LEX_SRC) $(BISON_HDR)
	$(FLEX) -o $(LEX_OUT) $(LEX_SRC)

# Clean generated files
clean:
	rm -f $(TARGET) $(LEX_OUT) $(BISON_OUT) $(BISON_HDR)

# Run the demo script
run: $(TARGET)
	./$(TARGET) demo.vtx