// Copyright 2021 Teodora Stroe
#ifndef __TEMA1_H_
#define __TEMA1_H_

struct Dir;
struct File;

typedef struct Dir{
	char *name;
	struct Dir* parent;
	int size_children_files;
	struct File* head_children_files;
	int size_children_dirs;
	struct Dir* head_children_dirs;
	struct Dir* next;
} Dir;

typedef struct File {
	char *name;
	struct Dir* parent;
	struct File* next;
} File;

#endif // __TEMA1_H_