.SILENT:

# Tools
AS = ca65
LD = ld65

# Project configuration
CONFIG = memory.cfg
TARGET = cs6502.bin
OBJDIR = obj

# Flags
ASFLAGS =
LDFLAGS = -C $(CONFIG)

# Sources and Objects
SOURCES = hello_world.s wozmon.s reset_vectors.s
OBJECTS = $(addprefix $(OBJDIR)/, $(SOURCES:.s=.o))

# Default target
.PHONY: all
all: $(TARGET)

# Linker
$(TARGET): $(OBJECTS) $(CONFIG)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

# Assembler
$(OBJDIR)/%.o: %.s | $(OBJDIR)
	$(AS) $(ASFLAGS) -o $@ $<

$(OBJDIR):
	mkdir -p $(OBJDIR)

# Clean up
.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(TARGET)