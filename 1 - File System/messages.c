// Copyright 2021 Teodora Stroe
#include <stdio.h>

#include "messages.h"

// displays 'File already exists'
void file_exists()
{
	printf("File already exists\n");
}

// displays 'Directory already exists'
void directory_exists()
{
	printf("Directory already exists\n");
}

// displays 'File/Director already exists'
void element_exists()
{
	printf("File/Director already exists\n");
}

// displays 'Could not find the file'
void file_not_found()
{
	printf("Could not find the file\n");
}

// displays 'Could not find the dir'
void dir_not_found()
{
	printf("Could not find the dir\n");
}

// displays 'File/Director not found'
void element_not_found()
{
	printf("File/Director not found\n");
}

// displays 'No directories found!'
void no_dirs_found()
{
	printf("No directories found!\n");
}

// displays no message 
void no_message(){}