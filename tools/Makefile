NAME =	compressor

SRC =	compressor.c

OBJ =	$(SRC:%.c=%.o)

INC =

LDFLAGS =

CFLAGS= $(INC)	\
		-W		\
		-Wall	\
		-Wextra	\

CC =	gcc

LIBS =

all:	$(LIBS) $(NAME)

$(NAME):$(OBJ)
	$(CC) -o $(NAME) $(OBJ) $(LDFLAGS)

fixObjPals:fixObjPals.o
	$(CC) -o fixObjPals fixObjPals.o $(LDFLAGS)

gbc_converter:gbc_converter.o
	$(CC) -o gbc_converter gbc_converter.o $(LDFLAGS) -lpng

clean:
	$(RM) $(OBJ) fixObjPals.o gbc_converter.o

fclean:	clean
	$(RM) $(NAME) $(NAME).exe fixObjPals fixObjPals.exe gbc_converter gbc_converter.exe

ffclean:fclean

re:	fclean all

dbg:	CFLAGS += -g -O0
dbg:	ffclean all
