// Copyright 2021 Teodora Stroe
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "commands.h"
#include "extra_functions.h"
#include "messages.h"
#include "utils.h"

//  creates a new file
/// @parent: the directory where the newly created file is located
/// @name  : the name of the newly created file
void touch(Dir* parent, char* name)
{
	int err = 0;
	File *last_existing_file;
	
	// checks if there is already a file with the same name
	// the last file in the parent directory's file list is retained
	last_existing_file = check_files(parent, name, &err, file_exists);

	if (err) {
		return;
	}

	// checks if there is already a directory with the same name
	check_dirs(parent, name, &err, file_exists);

	if (err) {
		return;
	}

	File *new_file = create_file(parent, name);

	// the new file is added to the parent directory's file list
	add_file(parent, new_file, last_existing_file);
}

//  creates a new file
/// @parent: the directory where the newly created directory is located
/// @name  : the name of the newly created directory
void mkdir(Dir* parent, char* name)
{
	int err = 0;
	Dir *last_existing_dir;

	// checks if there is already a file with the same name
	check_files(parent, name, &err, directory_exists);

	if (err) {
		return;
	}

	// checks if there is already a directory with the same name
	// the last folder in the parent's directory list is retained
	last_existing_dir = check_dirs(parent, name, &err, directory_exists);

	if (err) {
		return;
	}

	Dir *new_dir = create_dir(parent, name);

	// the new directory is added to the parent's directory list
	add_dir(parent, new_dir, last_existing_dir);
}

//  displays the directories/files in the current directory
/// @parent: the current working directory
void ls(Dir* parent)
{
	File *file = parent->head_children_files;
	Dir *dir = parent->head_children_dirs;

	for (int i = 0; i < parent->size_children_dirs; i++) {
		printf("%s\n", dir->name);
		dir = dir->next;
	}

	for (int i = 0; i < parent->size_children_files; i++) {
		printf("%s\n", file->name);
		file = file->next;
	}
}

//  deletes a file
/// @parent: the directory from which the deletion is performed
/// @name  : the name of the file being deleted
void rm(Dir* parent, char* name)
{	
	if (!parent->head_children_files) {
		file_not_found();
		return;
	}

	// if it exists, the given file is removed from the parent's file list
	// the deleted file is retained
	int err = 1;
	File *removed_file = eliminate_file(parent, name, &err);

	if (!err) {
		parent->size_children_files--;
		free_file(&removed_file);
	} else {
		file_not_found();
	}
}

//  deletes a directory
/// @parent: the directory from which the deletion is performed
/// @name  : the name of the directory being deleted
void rmdir(Dir* parent, char* name)
{
	if (!parent->head_children_dirs) {
		dir_not_found();
		return;
	}

	// if it exists, the folder is removed from the parent's directory list
	// the deleted directory is retained 
	int err = 1;
	Dir *removed_dir = eliminate_dir(parent, name, &err);

	if (!err) {
		// all files in the removed directory are deleted
		for (int i = 0; i < removed_dir->size_children_files; i++) {
			rm(removed_dir, removed_dir->head_children_files->name);
		}

		// all directories in the removed directory are recursively deleted
		for (int i = 0; i < removed_dir->size_children_dirs; i++) {
			rmdir(removed_dir, removed_dir->head_children_dirs->name);
		}

		parent->size_children_dirs--;
		free_dir(&removed_dir);
	} else {
		dir_not_found();
	}
}

//  changes the working directory
/// @target: the address of the current directory
/// @name  : the name of the new working directory
void cd(Dir** target, char *name)
{
	if (!(*target)) {
		return;
	}

	// the working directory becomes the parent directory of the current folder
	// if the current folder is HOME, the working directory remains unchanged
	if (!strcmp(name, "..")) {
		if (!strcmp((*target)->name, "home")) {
			return;
		}
		*target = (*target)->parent;
		return;
	}

	// if found, retain the folder with the given name from the directory list
	int err = 0;
	Dir *dir = check_dirs(*target, name, &err, no_message);

	// if found, new working directory is saved in the corresponding variable
	if (err) {
		*target = dir;
	} else {
		no_dirs_found();
	}
}

//  produces a depth indented listing of files and directories
/// @target: the current working directory
/// @level:  the level on which the current directory is
void tree(Dir* target, int level)
{
	int lvl = level;
	File *file = target->head_children_files;
	Dir *dir = target->head_children_dirs;

	// the directories are displayed recursively and indented
	for (int i = 0; i < target->size_children_dirs; i++) {
		lvl_identation(lvl);
		printf("%s\n", dir->name);
		tree(dir, lvl + 1);
		dir = dir->next;
	}

	// the files are displayed indented
	for (int i = 0; i < target->size_children_files; i++) {
		lvl_identation(lvl);
		printf("%s\n", file->name);
		file = file->next;
	}
}

//  displays the full path of the current working directory
/// @target: the current working directory
char *pwd(Dir* target)
{
	// retains the full path of the directory: /home/d1
	char *path = malloc(MAX_PATH * sizeof(*path));
	DIE(!path, "failed malloc()");

	// retains the reversed path of the directory: d1/home
	char *reversed_path = malloc(MAX_PATH * sizeof(*reversed_path));
	DIE(!reversed_path, "failed malloc()");

	create_reversed_path(target, &reversed_path);

	create_path(&reversed_path, &path);

	return path;
}

//  stops the program and frees up the memory allocated for files and folders
/// @target: the home directory
void stop(Dir* target)
{
	while (target->size_children_dirs) {
		rmdir(target, target->head_children_dirs->name);
	}

	while (target->size_children_files) {
		rm(target, target->head_children_files->name);
	}
}

//  renames file/directory
/// @parent:  the current working directory, the parent of the file/folder 
/// @oldname: current name of the file/directory to be renamed
/// @newname: the new name of the file/directory
void mv(Dir* parent, char *oldname, char *newname)
{
	int err = 0;
	File *file = NULL;
	Dir *dir = NULL; 
	
	// checks if the file/directory exists
	// the last file/directory in the parent's element list is retained
	file = check_files(parent, oldname, &err, no_message);
	dir = check_dirs(parent, oldname, &err, no_message);	

	if (!err) {
		element_not_found();
		return;
	}

	err = 0;

	// checks if there is already a file with the new name
	check_files(parent, newname, &err, element_exists);

	if (err) {
		return;
	}

	// checks if there is already a directory with the new name
	check_dirs(parent, newname, &err, element_exists);

	if (err) {
		return;
	}

	if (file) {
		// a copy of the file is retained and given the new name 
		// the original file is removed
		File *new_file = make_copy_file(file, newname);
		rm(parent, oldname);		

		// the last file in the parent directory's file list is retained
		// the copy of the file is added to the parent directory's file list
		File *last_existing_file;
		last_existing_file = check_files(parent, oldname, &err, no_message);
		add_file(parent, new_file, last_existing_file);
	} else {
		// a copy of the directory is retained and given the new name
		// the original folder is removed from the parent's directory list
		int err;
		Dir *new_dir = make_copy_dir(dir, newname);
		Dir *removed_dir = eliminate_dir(parent, oldname, &err);
		parent->size_children_dirs--;
		free_dir(&removed_dir);

		// the last folder in the parent's directory list is retained
		// the copy of the folder is added to the parent's directory list
		Dir *last_existing_dir;
		last_existing_dir = check_dirs(parent, oldname, &err, no_message);
		add_dir(parent, new_dir, last_existing_dir);
	}
}