#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <time.h>

#define CMD_NAME		"host"

#define MAX_HOST		2048


// Global: Exec argument vector
char *g_argv[] = {CMD_NAME, "-t", "ns", "foo.com", 0x0};

// Global: Response buffer
int g_b_idx = 0;
char g_b[MAX_HOST];


void panic (const char *note) {
	fprintf(stderr, "Err (%s): %s\n", note, strerror(errno));
	exit(EXIT_FAILURE);
}

int check_domain (const char *domain) {
	int fds[2], pid;

	g_argv[3] = domain;

	if (pipe(fds) == -1) panic("pipe");

	if ((pid = fork()) == -1) panic("fork");
	
	// Child
	if (pid == 0) {
		close(fds[0]);
		close(STDOUT_FILENO);
		if (dup(fds[1]) == -1) {
			panic("dup");
		}
		execvp(CMD_NAME, g_argv);
		panic("exec");
	} else {
		close(fds[1]);
		int c;
		g_b_idx = 0;
		while (read(fds[0], &c, 1) == 1) {
			g_b[g_b_idx++] = c;
		}
		waitpid(pid, NULL, 0x0);
		g_b[strlen(domain)] = '\0';
		close(fds[0]);
		return (strcmp(g_b, domain) == 0);
	}
}


int main (int argc, char *argv[]) {
	char dbuf[256];
	int c, idx = 0;
	int count = 0;
	struct timespec delay = (struct timespec) {
		.tv_sec = 0,
		.tv_nsec = 20 * 1000000 // 20 ms
	};
	int clean = 0;

	if (argc == 2) {
		if (strcmp("-clean", argv[1]) == 0) {
			clean = 1;
		} else {
			fprintf(stderr, "Usage: %s [-clean] < infile > outfile\n", argv[0]);
			exit(EXIT_FAILURE);
		}
	} 

	while (count < 1000 && (c = getchar()) != EOF) {
		if (c == '\n') {
			dbuf[idx] = '\0';

			// Drop characters until the first ., then replace with null
			if (clean == 0) {
				while (idx > 0 && dbuf[idx] != '.') idx--;
				dbuf[idx] = '\0';
			}
			int result = check_domain(dbuf);
			if (clean == 0) {
				dbuf[idx] = '.';
			}
			if (result) {
				count++;
				printf("%s\n", dbuf);
			}
			idx = 0;
			nanosleep(&delay, NULL);
		} else {
			dbuf[idx++] = c;
		}
	}
	return EXIT_SUCCESS;
}
