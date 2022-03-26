				 ____  _____    _    ____  __  __ _____ 
				|  _ \| ____|  / \  |  _ \|  \/  | ____|
				| |_) |  _|   / _ \ | | | | |\/| |  _|
				|  _ <| |___ / ___ \| |_| | |  | | |___ 
				|_| \_\_____/_/   \_\____/|_|  |_|_____|

						Stroe Teodora, 321CA

## SKEL MODIFICATIONS:

 ### Data structures - struct Dir:
- added size variables for the number of files/directories in the 
  corresponding lists

 ### File guide:
 
	- tema1.c		 ~ main() function
	- tema1.h		 ~ Dir and File data structures
	- commands.c		 ~ command functions
	- extra_functions.c 	 ~ custom functions
	- messages.c		 ~ functions used to display standard error messages
	- utils.h		 ~ DIE macro used for checking the error code returned
				   by a system call

 ### Makefile:
- added new rules: run, valgrind, pack
- modified build rule to fit the new file structure

## IMPLEMENTATION DESCRIPTION:

- **main**: Created HOME directory and called each command function. Used 
**get_command** to break input line into command and arguments.

- **touch**: Used **check_file** to browse the file list for the existence 
of a file with the same name. If there is one already, the standard 
message is displayed. Otherwise, a file with the new name is added to the 
end of the list, using **add_file**.

- **mkdir**: The approach is similar to the **touch** function, the 
operations being applied to the directory list. The used functions are: 
**check_dirs** and **add_dir**.

- **ls**: Browsed the directory/file list of the parent directory and 
displayed the name of each item.

- **rm**: Used **eliminate_file** to browse the file list. If the searched
item is found (a file with the given name), it is removed from the file
list and retained in a variable. Then it's allocated memory is frees and
the size of the file list is decreased in the parent directory.

- **rmdir**:  The approach is similar to the **rm** function, the 
operations being applied to the directory list. The used function is: 
**eliminate_dir**. Additionaly, the file list of the removed directory is
emptied using the **rm** function and it's own directory list is also 
emptied recursively.

- **cd**: Addressed the case in which the the previous directory becomes 
the current directory, and restricted the number of previous steps that 
can be done using this command. Used **check_dirs** to navigate through 
the directory list of the current folder and change the current directory 
to the one with the given name.

- **tree**: Used this function to recursively print the directories on
each level, and the display the contained files. Used **lvl_identation**
to display the indentation needed for each level.

- **pwd**: Used **create_reversed_path** to generate the reversed path
of the current directory (cur_dir/.../home) and subsequently used 
**create_path** to invert the reversed path (/home/.../cur_dir).

- **stop**:  Freed the memory allocated for the file and folder using the
**rm** and **rmdir** functions.

- **mv**: Used **check_files** and **check_dirs** to navigate the file/
directory list and find the element with the given name, if it exists.
Checked using the same functions to verify there isn't already an element
with the new name. If the renamed item is a file, a copy is made using
**make_copy_file**, the old file is removed with **rm** function and the
new one is added in the file list using **add_file**. If the item is a
directory, a copy is made using **make_copy_dir**, the original folder
is removed from the directory list with **eliminate_dir**, and the list
size decreased, and then the new folder is added using **add_dir**.

## FEEDBACK:

 ### PROS:
- I liked the comments in checker.py ;)
- The freedom given to us in the approach regarding the implementation, 
the fact that we were allowed to modify the data structures and 
restructure the code as we saw fit.
- The given tasks were interesting and challenging.
- The use of a certain coding style was optional.

 ### CONS:
- The inital skel seemed pretty restrictive and was bad modularized.
- There weren't comments for the functions' arguments.
- The vmchecker uploading platform was updated with a long delay.
