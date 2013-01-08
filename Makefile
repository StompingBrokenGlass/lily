CC=gcc
CFLAGS=-c -g3 -Wall
AFT_CFLAGS=$(CFLAGS) -DAFT_ALLOC

BINDIR=bin
OBJDIR=objdir
AFT_DIR=aft

# todo: Look into making this autogenerated, instead of pretending that the deps
#       are correct.
CORE_OBJECTS=$(OBJDIR)/lily_parser.o \
			$(OBJDIR)/lily_lexer.o \
			$(OBJDIR)/lily_ast.o \
			$(OBJDIR)/lily_emitter.o \
			$(OBJDIR)/lily_symtab.o \
			$(OBJDIR)/lily_vm.o \
			$(OBJDIR)/lily_debug.o \
			$(OBJDIR)/lily_raiser.o \
			$(OBJDIR)/lily_msgbuf.o \
			$(OBJDIR)/lily_pkg_str.o

AFT_OBJECTS=$(AFT_DIR)/lily_aft_parser.o \
			$(AFT_DIR)/lily_aft_lexer.o \
			$(AFT_DIR)/lily_aft_ast.o \
			$(AFT_DIR)/lily_aft_emitter.o \
			$(AFT_DIR)/lily_aft_symtab.o \
			$(AFT_DIR)/lily_aft_vm.o \
			$(AFT_DIR)/lily_aft_debug.o \
			$(AFT_DIR)/lily_aft_raiser.o \
			$(AFT_DIR)/lily_aft_msgbuf.o \
			$(AFT_DIR)/lily_aft_pkg_str.o \
			$(AFT_DIR)/aft_main.o

FS_OBJECTS=$(CORE_OBJECTS) \
			$(OBJDIR)/fs_main.o

STRLOAD_OBJECTS=$(CORE_OBJECTS) \
				$(OBJDIR)/strload_main.o

FAILTEST_OBJECTS=$(CORE_OBJECTS) \
					$(OBJDIR)/failtest_main.o

all: lily_fs lily_strload lily_failtest lily_aft 

clean:
	rm -f $(OBJDIR)/* $(AFT_DIR)/* lily_fs lily_strload lily_failtest lily_aft

passfailcheck:
	./lily_fs sanity.ly 2>/dev/null | grep "Tests passed"
	./lily_failtest 2>/dev/stdout | grep "Tests failed"

lily_strload: $(STRLOAD_OBJECTS)
	$(CC) $(STRLOAD_OBJECTS) -o lily_strload

lily_fs: $(FS_OBJECTS)
	$(CC) $(FS_OBJECTS) -o lily_fs

lily_aft: $(AFT_OBJECTS)
	$(CC) $(AFT_OBJECTS) -o lily_aft

lily_failtest: $(FAILTEST_OBJECTS)
	$(CC) $(FAILTEST_OBJECTS) -o lily_failtest

# Becomes an executable
$(OBJDIR)/fs_main.o: fs_main.c lily_lexer.h lily_parser.h lily_emitter.h \
					 lily_symtab.h
	$(CC) $(CFLAGS) fs_main.c -o $(OBJDIR)/fs_main.o

$(OBJDIR)/strload_main.o: strload_main.c lily_parser.h
	$(CC) $(CFLAGS) strload_main.c -o $(OBJDIR)/strload_main.o

$(OBJDIR)/failtest_main.o: failtest_main.c lily_parser.h
	$(CC) $(CFLAGS) failtest_main.c -o $(OBJDIR)/failtest_main.o

$(AFT_DIR)/aft_main.o: aft_main.c lily_parser.h
	$(CC) $(AFT_CFLAGS) aft_main.c -o $(AFT_DIR)/aft_main.o

# Standard (non-debug) core
$(OBJDIR)/lily_lexer.o: lily_lexer.c lily_lexer.h lily_impl.h
	$(CC) $(CFLAGS) lily_lexer.c -o $(OBJDIR)/lily_lexer.o

$(OBJDIR)/lily_parser.o: lily_parser.c lily_lexer.h lily_impl.h lily_symtab.h \
						 lily_ast.h lily_vm.h lily_expr_op.h
	$(CC) $(CFLAGS) lily_parser.c -o $(OBJDIR)/lily_parser.o

$(OBJDIR)/lily_ast.o: lily_ast.c lily_ast.h lily_symtab.h lily_impl.h \
					  lily_expr_op.h
	$(CC) $(CFLAGS) lily_ast.c -o $(OBJDIR)/lily_ast.o

$(OBJDIR)/lily_emitter.o: lily_emitter.c lily_opcode.h lily_impl.h \
						  lily_emit_table.h
	$(CC) $(CFLAGS) lily_emitter.c -o $(OBJDIR)/lily_emitter.o

$(OBJDIR)/lily_symtab.o: lily_symtab.c lily_symtab.h lily_seed_symtab.h
	$(CC) $(CFLAGS) lily_symtab.c -o $(OBJDIR)/lily_symtab.o

$(OBJDIR)/lily_vm.o: lily_vm.c lily_vm.h
	$(CC) $(CFLAGS) lily_vm.c -o $(OBJDIR)/lily_vm.o

$(OBJDIR)/lily_debug.o: lily_debug.c lily_debug.h
	$(CC) $(CFLAGS) lily_debug.c -o $(OBJDIR)/lily_debug.o

$(OBJDIR)/lily_raiser.o: lily_raiser.c lily_raiser.h
	$(CC) $(CFLAGS) lily_raiser.c -o $(OBJDIR)/lily_raiser.o

$(OBJDIR)/lily_msgbuf.o: lily_msgbuf.c lily_msgbuf.h
	$(CC) $(CFLAGS) lily_msgbuf.c -o $(OBJDIR)/lily_msgbuf.o

$(OBJDIR)/lily_pkg_str.o: lily_pkg_str.c lily_pkg_str.h
	$(CC) $(CFLAGS) lily_pkg_str.c -o $(OBJDIR)/lily_pkg_str.o

# These are the aft's version of core files. These cannot be mixed with the
# standard core files because they use aft_main.c's replacements for malloc,
# realloc, and free. 
$(AFT_DIR)/lily_aft_lexer.o: lily_lexer.c lily_lexer.h lily_impl.h
	$(CC) $(AFT_CFLAGS) lily_lexer.c -o $(AFT_DIR)/lily_aft_lexer.o

$(AFT_DIR)/lily_aft_parser.o: lily_parser.c lily_lexer.h lily_impl.h \
                                 lily_symtab.h lily_ast.h lily_vm.h \
                                 lily_expr_op.h
	$(CC) $(AFT_CFLAGS) lily_parser.c -o $(AFT_DIR)/lily_aft_parser.o

$(AFT_DIR)/lily_aft_ast.o: lily_ast.c lily_ast.h lily_symtab.h lily_impl.h \
					  lily_expr_op.h
	$(CC) $(AFT_CFLAGS) lily_ast.c -o $(AFT_DIR)/lily_aft_ast.o

$(AFT_DIR)/lily_aft_emitter.o: lily_emitter.c lily_opcode.h lily_impl.h \
						  lily_emit_table.h
	$(CC) $(AFT_CFLAGS) lily_emitter.c -o $(AFT_DIR)/lily_aft_emitter.o

$(AFT_DIR)/lily_aft_symtab.o: lily_symtab.c lily_symtab.h lily_seed_symtab.h
	$(CC) $(AFT_CFLAGS) lily_symtab.c -o $(AFT_DIR)/lily_aft_symtab.o

$(AFT_DIR)/lily_aft_vm.o: lily_vm.c lily_vm.h
	$(CC) $(AFT_CFLAGS) lily_vm.c -o $(AFT_DIR)/lily_aft_vm.o

$(AFT_DIR)/lily_aft_debug.o: lily_debug.c lily_debug.h
	$(CC) $(AFT_CFLAGS) lily_debug.c -o $(AFT_DIR)/lily_aft_debug.o

$(AFT_DIR)/lily_aft_raiser.o: lily_raiser.c lily_raiser.h
	$(CC) $(AFT_CFLAGS) lily_raiser.c -o $(AFT_DIR)/lily_aft_raiser.o

$(AFT_DIR)/lily_aft_msgbuf.o: lily_msgbuf.c lily_msgbuf.h
	$(CC) $(AFT_CFLAGS) lily_msgbuf.c -o $(AFT_DIR)/lily_aft_msgbuf.o

$(AFT_DIR)/lily_aft_pkg_str.o: lily_pkg_str.c lily_pkg_str.h
	$(CC) $(AFT_CFLAGS) lily_pkg_str.c -o $(AFT_DIR)/lily_aft_pkg_str.o

.PHONY: clean all
