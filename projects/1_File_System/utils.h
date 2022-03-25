// Copyright 2021 Teodora Stroe
#ifndef _UTILS_H_
#define _UTILS_H_

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

#define DIE(assertion, call_description)			\
	do {											\
		if (assertion) {							\
			fprintf(stderr, "(%s, %d): ",			\
					__FILE__, __LINE__);			\
			perror(call_description);				\
			exit(errno);							\
		}											\
	} while (0)
	
#endif // _UTILS_H_