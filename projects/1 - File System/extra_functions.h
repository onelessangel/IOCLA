// Copyright 2021 Teodora Stroe
#ifndef __EXTRA_FUNCTIONS_H_
#define __EXTRA_FUNCTIONS_H_

#include "tema1.h"

#define MAX_PATH 			300

#define MIN(a, b) a < b ? a : b

void get_command(char **line, char **cmd, char **arg1, char **arg2);

File *create_file(Dir* parent, char* name);

Dir *create_dir(Dir *parent, char *name);

File *check_files(Dir *parent, char *name, int *err, void msg());

Dir *check_dirs(Dir *parent, char *name, int *err, void msg());

void add_file(Dir *parent, File *new_file, File *last_existing_file);

void add_dir(Dir *parent, Dir *new_dir, Dir *last_existing_dir);

File *get_nth_file(Dir *parent, int n);

File *eliminate_file(Dir *parent, char *name, int *err);

Dir *get_nth_dir(Dir *parent, int n);

Dir *eliminate_dir(Dir *parent, char *name, int *err);

void lvl_identation(int n);

void create_reversed_path(Dir *target, char **reversed_path);

void create_path(char **reversed_path, char **path);

File *make_copy_file(File *file, char *newname);

Dir *make_copy_dir(Dir *dir, char *newname);

void free_file(File **file);

void free_dir(Dir **dir);

#endif // __EXTRA_FUNCTIONS_H_