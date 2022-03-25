// Copyright 2021 Teodora Stroe
#ifndef __COMMANDS_H_
#define __COMMANDS_H_

#include "tema1.h"

#define MAX_INPUT_LINE_SIZE 300
#define MAX_PATH			300

void touch(Dir* parent, char* name);

void mkdir(Dir* parent, char* name);

void ls(Dir* parent);

void rm(Dir* parent, char* name);

void rmdir(Dir* parent, char* name);

void cd(Dir** target, char *name);

char *pwd(Dir* target);

void stop(Dir* target);

void tree(Dir* target, int level);

void mv(Dir* parent, char *oldname, char *newname);

#endif // __COMMANDS_H_