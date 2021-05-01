######################################################################
# 
#
#                          
#             Integracio de les eines flex, bison i gcc
#
#                           Tere Alsinet
#
#                        
#		         
#  
######################################################################

# General defines
CC = gcc
LEX = flex
YACC = bison
TARGET=calculadora_registres
CFLAGS = -Wall

######################################################################

$(TARGET) : $(TARGET).tab.c  lex.yy.c
	gcc $(CFLAGS) $(TARGET).tab.c lex.yy.c -o $(TARGET)

	
$(TARGET).tab.c: $(TARGET).y
	$(YACC) -d -v $(TARGET).y -o $(TARGET).tab.c

lex.yy.c : $(TARGET).l
	flex $(TARGET).l
	
clean : 
	rm -f $(TARGET) $(TARGET).tab.c $(TARGET).tab.h lex.yy.c $(TARGET).output