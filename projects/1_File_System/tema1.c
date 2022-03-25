// Copyright 2021 Teodora Stroe
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "commands.h"
#include "extra_functions.h"
#include "utils.h"

int main()
{
	// creates HOME directory and sets it as current working directory
	Dir *home_dir = create_dir(NULL, "home");
	Dir *cur_dir = home_dir;

	do	{
		char *line = malloc(MAX_INPUT_LINE_SIZE);
		DIE(!line, "failed malloc()");

		line = fgets(line, MAX_INPUT_LINE_SIZE, stdin);
		line[strcspn(line, "\n")] = '\0';

		char *cmd, *arg1, *arg2;
		
		// retains the command and its arguments from the input
		get_command(&line, &cmd, &arg1, &arg2);

		if (!strcmp(cmd, "touch")) {
			touch(cur_dir, arg1);
		} else if (!strcmp(cmd, "mkdir")) {
			mkdir(cur_dir, arg1);
		} else if(!strcmp(cmd, "ls")) {
			ls(cur_dir);
		} else if(!strcmp(cmd, "rm")) {
			rm(cur_dir, arg1);
		} else if (!strcmp(cmd, "rmdir")) {
			rmdir(cur_dir, arg1);
		} else if (!strcmp(cmd, "cd")) {
			cd(&cur_dir, arg1);
		} else if (!strcmp(cmd, "tree")) {
			tree(cur_dir, 0);
		} else if (!strcmp(cmd, "pwd")) {
			char *path = pwd(cur_dir);
			printf("%s\n", path);
			free(path);
		} else if (!strcmp(cmd, "mv")) {
			mv(cur_dir, arg1, arg2);
		}else if (!strcmp(cmd, "stop")) {
			stop(home_dir);
			free_dir(&home_dir);
			free(line);
			break;
		}

		free(line);
	} while (true);

	return 0;
}