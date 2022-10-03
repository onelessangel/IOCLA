// Copyright 2021 Teodora Stroe
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "extra_functions.h"
#include "utils.h"

//  breaks input line into command and arguments
/// @line: input line
/// @cmd:  variable which will retain the command part of the input
/// @arg: variables whoch wil retain the first/second arguments of the command
void get_command(char **line, char **cmd, char **arg1, char **arg2)
{
	*cmd = strtok(*line, " ");
	*arg1 = strtok(NULL, " ");
	if (*arg1) {
		*arg2 = strtok(NULL, " ");
	}
}

//  allocates memory for a new file and sets its parent direcory and name
/// @parent: the directory where the newly created file is located
/// @name  : the name of the newly created file
/// @return: the newly created file
File *create_file(Dir* parent, char* name)
{
	int name_size = strlen(name) + 1;
	
	File *new_file = malloc(sizeof(*new_file));
	DIE(!new_file, "failed malloc()");

	new_file->name = malloc(name_size);
	DIE(!new_file->name, "failed malloc()");

	memcpy(new_file->name, name, name_size);
	new_file->parent = parent;
	new_file->next = NULL;

	return new_file;
}

//  allocates memory for a new directory and sets its parent directory and name
/// @parent: the directory where the newly created folder is located
/// @name  : the name of the newly created directory
/// @return: the newly created directory
Dir *create_dir(Dir *parent, char *name)
{
	int name_size = strlen(name) + 1;

	Dir *new_dir = malloc(sizeof(*new_dir));
	DIE(!new_dir, "failed malloc()");

	new_dir->name = malloc(name_size);
	DIE(!new_dir->name, "failed malloc()");

	memcpy(new_dir->name, name, name_size);
	new_dir->parent = parent;
	new_dir->size_children_files = 0;
	new_dir->head_children_files = NULL;
	new_dir->size_children_dirs = 0;
	new_dir->head_children_dirs = NULL;
	new_dir->next = NULL;

	return new_dir;
}

//  checks if the name given is found in the parent directory's file list
/// @parent: the directory in which the search takes place
/// @name: the name searched for in the file list
/// @err: variable which changes value if the name is found in the file list
/// @msg: message to be displayed if name is found in the file list
/// @return: the last file in the parent directory's file list
File *check_files(Dir *parent, char *name, int *err, void msg())
{
	File *file = parent->head_children_files;
	File *last_existing_file = NULL;

	for (int i = 0; i < parent->size_children_files; i++) {
		last_existing_file = file;
		if (!strcmp(file->name, name)) {
			msg();
			*err = 1;
			break;
		}
		file = file->next;
	}

	return last_existing_file;
}

//  checks if the name given is found in the parent's directory list
/// @parent: the directory in which the search takes place
/// @name: the name searched for in the directory list
/// @err: variable which changes value if the name is found in the folder list
/// @msg: message to be displayed if name is found in the directory list
/// @return: the last directory in the parent's directory list
Dir *check_dirs(Dir *parent, char *name, int *err, void msg())
{
	Dir *dir = parent->head_children_dirs;
	Dir *last_existing_dir = NULL;

	for (int i = 0; i < parent->size_children_dirs; i++) {
		last_existing_dir = dir;
		if (!strcmp(dir->name, name)) {
			msg();
			*err = 1;
			break;
		}
		dir = dir->next;
	}

	return last_existing_dir;
}

//  adds a new file to the parent's file list, on the last position
/// @parent: the directory in which the new file is added
/// @new_file: the new file to be added to the file list
/// @last_existing_file: the last file in the parent directory's file list
void add_file(Dir *parent, File *new_file, File *last_existing_file)
{
	if (!parent->size_children_files) {
		parent->head_children_files = new_file;
	} else {
		last_existing_file->next = new_file;
	}

	parent->size_children_files++;
}

//  adds a new folder to the parent's directory list, on the last position
/// @parent: the directory in which the new folder is added
/// @new_dir: the new directory to be added to the file list
/// @last_existing_dir: the last directory in the parent's directory list
void add_dir(Dir *parent, Dir *new_dir, Dir *last_existing_dir)
{
	if (!parent->size_children_dirs) {
		parent->head_children_dirs = new_dir;
	} else {
		last_existing_dir->next = new_dir;
	}

	parent->size_children_dirs++;
}

//  returns the file on the Nth position from the parent directory's file list
/// @parent: the directory in which the file is
/// @n     : the position of the file in the file list
/// @return: the file on the Nth position in the file list
File *get_nth_file(Dir *parent, int n)
{
	File *file = parent->head_children_files;

	n = MIN(n, parent->size_children_files - 1);

	for (int i = 0; i < n; i++) {
		file = file->next;
	}

	return file;
}

//  eliminates file from the parent directory's file list
/// @parent: the directory from which the file is eliminated
/// @name: the name of the file to be eliminated
/// @err: variable which changes value if the name is found in the file list
/// @return: the eliminated file
File *eliminate_file(Dir *parent, char *name, int *err)
{
	File *file = parent->head_children_files;
	File *removed_file;

	for (int i = 0; i < parent->size_children_files; i++) {
		if (!strcmp(file->name, name)) {
			if (!i) {
				removed_file = parent->head_children_files;
				parent->head_children_files = parent->head_children_files->next;
			} else {
				File *prev = get_nth_file(parent, i - 1);
				removed_file = prev->next;
				prev->next = removed_file->next;
			}
			*err = 0;
			break;
		}
		file = file->next;
	}

	return removed_file;
}

//  returns the folder on the Nth position from the parent's directory list
/// @parent: the directory in which the folder is
/// @n     : the position of the directory in the directory list
/// @return: the directory on the Nth position in the directory list
Dir *get_nth_dir(Dir *parent, int n)
{
	Dir *dir = parent->head_children_dirs;

	n = MIN(n, parent->size_children_dirs - 1);

	for (int i = 0; i < n; i++) {
		dir = dir->next;
	}

	return dir;
}

//  eliminates directory from the parent's directory list
/// @parent: the directory from which the folder is eliminated
/// @name: the name of the directory to be eliminated
/// @err: variable which changes value if the name is found in the folder list
/// @return: the eliminated directory
Dir *eliminate_dir(Dir *parent, char *name, int *err)
{
	Dir *dir = parent->head_children_dirs;
	Dir *removed_dir;

	for (int i = 0; i < parent->size_children_dirs; i++) {
		if (!strcmp(dir->name, name)) {
			if (!i) {
				removed_dir = parent->head_children_dirs;
				parent->head_children_dirs = parent->head_children_dirs->next;
			} else {
				Dir *prev = get_nth_dir(parent, i - 1);
				removed_dir = prev->next;
				prev->next = removed_dir->next;
			}
			*err = 0;
			break;
		}
		dir = dir->next;
	}

	return removed_dir;
}

//  prints the number of spaces corresponding to the level
/// @n: the number of the level
void lvl_identation(int n)
{
	for (int i = 0; i < n; i++) {
		printf("    ");
	}
}

//  creates reversed path for current working directory
/// @target: the current working directory
/// @reversed_path: variable which retains the reversed path: cur_dir/.../home
void create_reversed_path(Dir *target, char **reversed_path)
{
	strcpy(*reversed_path, "");

	// the current directory name and de "/" concatenates to the string
	while (target->parent) {
		strcat(*reversed_path, target->name);
		strcat(*reversed_path, "/");

		target = target->parent;
	}

	// the name of the HOME directory is concatenated to the string
	strcat(*reversed_path, target->name);
}

//  creates path for current working directory 
/// @reversed_path: the reversed path o the current working directory
/// @path: variable which retains the current path: /home/.../cur_dir
void create_path(char **reversed_path, char **path)
{
	char *ptr = strtok(*reversed_path, "/");

	strcpy(*path, "");

	while (ptr) {
		char *tmp = malloc(MAX_PATH * sizeof(*tmp));
		DIE(!tmp, "failed malloc()");

		// "/" is added before the current path
		strcpy(tmp, "/");
		strcat(tmp, *path);

		// the parent directory is added before the current path
		strcpy(*path, ptr);
		strcat(*path, tmp);

		free(tmp);

		// the new directory name is retained 
		ptr = strtok(NULL, "/");
	}

	(*path)[strlen(*path) - 1] = '\0';

	char *tmp = malloc(MAX_PATH * sizeof(*tmp));
	DIE(!tmp, "failed malloc()");

	// "/home" is added before the current path
	strcpy(tmp, "/");
	strcat(tmp, *path);
	strcpy(*path, tmp);

	free(tmp);
	free(*reversed_path);
}

//  creates a file with the same parent as the given file, but with a new name
/// @file   : the file to be copied
/// @newname: the name to be given to the new file
/// @return : the copy of the file
File *make_copy_file(File *file, char *newname)
{
	File *new_file = create_file(file->parent, newname);

	return new_file;
}

//  creates a folder with the same attributes, but with a new name
/// @dir    : the directory to be copied
/// @newname: the name to be given to the new directory
/// @return : the copy of the directory
Dir *make_copy_dir(Dir *dir, char *newname)
{
	Dir *new_dir = create_dir(dir->parent, newname);

	new_dir->size_children_files = dir->size_children_files;
	new_dir->head_children_files = dir->head_children_files;
	new_dir->size_children_dirs = dir->size_children_dirs;
	new_dir->head_children_dirs = dir->head_children_dirs;

	return new_dir;
}

//  frees memory allocated for the given file
/// @file: the file to be freed
void free_file(File **file)
{
	free((*file)->name);
	free(*file);
}

//  frees the memory allocated for the given directory
/// @dir: the directory to be freed
void free_dir(Dir **dir)
{
	free((*dir)->name);
	free(*dir);
}