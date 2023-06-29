CCFLAGS_DEBUG=-Wall -Wpedantic -Wextra -lm -g
CCFLAGS=-Wall -Wpedantic -Wextra -lm -O3 -DRELEASE -flto

.PHONY: all
all: bin/rlplot_debug bin/rlplot
	echo "Everything built"

.PHONY: install
install: bin/rlplot
	install bin/rlplot /bin/rlplot

bin/rlplot_debug: build/read_input_debug.o build/main_debug.o build/graph_debug.o build/refresh_shaders_debug.o build/points_group_debug.o build/smol_mesh_debug.o
	gcc $(CCFLAGS_DEBUG) -pthread -lraylib -o bin/rlplot_debug build/read_input_debug.o build/main_debug.o build/graph_debug.o build/refresh_shaders_debug.o build/points_group_debug.o build/smol_mesh_debug.o

build/read_input_debug.o: read_input.c plotter.h
	gcc $(CCFLAGS_DEBUG) -c -o build/read_input_debug.o read_input.c

build/main_debug.o: main.c plotter.h
	gcc $(CCFLAGS_DEBUG) -c -o build/main_debug.o main.c

build/graph_debug.o: graph.c plotter.h
	gcc $(CCFLAGS_DEBUG) -c -o build/graph_debug.o graph.c

build/refresh_shaders_debug.o: refresh_shaders.c plotter.h
	gcc $(CCFLAGS_DEBUG) -c -o build/refresh_shaders_debug.o refresh_shaders.c

build/points_group_debug.o: points_group.c plotter.h
	gcc $(CCFLAGS_DEBUG) -c -o build/points_group_debug.o points_group.c

build/smol_mesh_debug.o: smol_mesh.c plotter.h
	gcc $(CCFLAGS_DEBUG) -c -o build/smol_mesh_debug.o smol_mesh.c

bin/rlplot: build/read_input.o build/main.o build/graph.o build/points_group.o build/smol_mesh.o
	gcc $(CCFLAGS) -pthread -lraylib -o bin/rlplot build/read_input.o build/main.o build/graph.o build/points_group.o build/smol_mesh.o

build/read_input.o: read_input.c plotter.h
	gcc $(CCFLAGS) -c -o build/read_input.o read_input.c

build/main.o: main.c plotter.h
	gcc $(CCFLAGS) -c -o build/main.o main.c

build/graph.o: graph.c plotter.h shaders.h
	gcc $(CCFLAGS) -c -o build/graph.o graph.c

build/points_group.o: points_group.c plotter.h
	gcc $(CCFLAGS) -c -o build/points_group.o points_group.c

build/smol_mesh.o: smol_mesh.c plotter.h
	gcc $(CCFLAGS) -c -o build/smol_mesh.o smol_mesh.c

shaders.h: shaders/grid.fs shaders/line.fs shaders/line.vs
	# This will break if there are `"` characters in shaders
	echo "#define SHADER_GRID_FS \\" > shaders.h
	cat shaders/grid.fs | sed 's/\(.*\)/"\1\\n"\\/' >> shaders.h
	echo "" >> shaders.h
	echo "#define SHADER_LINE_FS \\" >> shaders.h
	cat shaders/line.fs | sed 's/\(.*\)/"\1\\n"\\/' >> shaders.h
	echo "" >> shaders.h
	echo "#define SHADER_LINE_VS \\" >> shaders.h
	cat shaders/line.vs | sed 's/\(.*\)/"\1\\n"\\/' >> shaders.h
	echo "" >> shaders.h

.PHONY: clean
clean:
	rm build/*
	rm bin/*

