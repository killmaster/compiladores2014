PROG=bee
EXT=.bee

.SUFFIXES: $(EXT) .asm
CC=gcc
CXXFLAGS=-g
LEX=flex
YACC=byacc
YFLAGS=-dv
NASM=yasm -felf
MV=mv
PFLAGS=-lutil -lfl
#LIBDIR=
LIBS=libbee.a

.PHONY:	iter recurs all

all: objects
	$(CC) -o $(PROG) y.tab.o lex.yy.o -Llib $(PFLAGS)
	iter
	recurs

objects: y.tab.c lex.yy.c
	$(CC) -g -c -DYYDEBUG -Ilib y.tab.c lex.yy.c

lex.yy.c:
	$(LEX) -l $(PROG).l

y.tab.c:
	$(YACC) $(YFLAGS) $(PROG).y

.bee.asm:
	$(PROG) $(PFLAGS) $< $@

.asm.o:
	$(NASM) $(NFLAGS) $(FMT) $<

%: %.o
	ld -o $@ $< $(LIBS)

clean:
	rm -f *.o $(PROG) lex.yy.c y.tab.c y.tab.h y.output

iter:
	./bee iter.bee
	nasm -felf32 iter.asm
	./bee fact.bee
	nasm -felf32 fact.asm
	ld -o iter iter.o fact.o libbee.a

recurs:
	./bee recurs.bee
	nasm -felf32 recurs.asm
	./bee fact.bee
	nasm -felf32 fact.asm
	ld -o iter recurs.o fact.o libbee.a