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


void panic () {
	fprintf(stderr, "Err: %s\n", strerror(errno));
	exit(EXIT_FAILURE);
}

int check_domain (const char *domain) {
	int fds[2], pid;

	g_argv[3] = domain;

	if (pipe(fds) == -1) panic();

	if ((pid = fork()) == -1) panic();
	
	// Child
	if (pid == 0) {
		close(fds[0]);
		close(STDOUT_FILENO);
		if (dup(fds[1]) == -1) {
			panic();
		}
		execvp(CMD_NAME, g_argv);
		panic();
	} else {
		close(fds[1]);
		int c;
		g_b_idx = 0;
		while (read(fds[0], &c, 1) == 1) {
			g_b[g_b_idx++] = c;
		}
		g_b[strlen(domain)] = '\0';
		close(fds[0]);
		return (strcmp(g_b, domain) == 0);
	}
}


int main (void) {
	char dbuf[256];
	int c, idx = 0;
	struct timespec delay = (struct timespec) {
		.tv_sec = 0,
		.tv_nsec = 250 * 1000000 // 250 ms
	};

	while ((c = getchar()) != EOF) {
		if (c == '\n') {
			dbuf[idx] = '\0';
			if (check_domain(dbuf) == 1) {
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
