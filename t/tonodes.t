# vi:filetype=

use t::tonodes;

plan tests => 3 * blocks();

#no_diff();

run_tests();

__DATA__

=== TEST 1: no home
--- no_home
--- args: t/tonodes.t * :foo
--- err
Can't find the home for the current user.
--- out
--- status: 2



=== TEST 2: no rc given
--- args: t/tonodes.t * :foo
--- no_rc
--- out
--- err
Can't open **RC_FILE_PATH** for reading: No such file or directory
--- status: 2
--- SKIP



=== TEST 3: no args given
--- rc
api=api01.foo.com api02.foo.com
--- args:
--- out
--- err
No argument specified.

USAGE:

    tonodes [OPTIONS] FILE... -- HOST_PATTERN... [OPTIONS]
    tonodes [OPTIONS] FILE HOST_PATTERN... [OPTIONS]

OPTIONS:
    -c <num>      Set SSH concurrency limit. (default: 20)
    -b <num>      bandwidth limit in Kbits/sec.
    -g            Use glob to process the input files/directories.
    -h            Print this help.
    -l            List the hosts and do nothing else.
    -L            Use the line-mode output format, i.e., prefixing
                  every output line with the machine name.
                  (could be controlled by the env SSH_BATCH_LINE_MODE)
    -p <port>     Port for the remote SSH service.
    -r            Recurse into directories too.
    -rsync        Use "rsync" to transfer files.
    -archive      Enable rsync archive mode
    -update       Enable rsync update
    -compress     Enable rsync compress
    -t <timeout>  Specify timeout for net traffic.
    -u <user>     User account for SSH login.
    -v            Be verbose.
    -w            Prompt for password (used mostly for login and sudo,
                  could be privided by SSH_BATCH_PASSWORD).
    -P            Prompt for passphrase (used mostly for login,
                  could be privided by SSH_BATCH_PASSPHRASE).
--- status: 1



=== TEST 4: no file
--- args: -- foo.com :/tmp/
--- out
--- err
No local files/directories specified.
--- status: 255



=== TEST 5: no expression
--- args: t/tonodes.t -- :/tmp
--- out
--- err
No cluster expression specified.
--- status: 255



=== TEST 6: no target
--- args: t/tonodes.t -- foo.com '*.bar.cn'
--- rc
blah=foo
--- out
--- err
No remote target path specified.
  (You forgot to specify ":/path/to/target" at the end of the command line?)
--- status: 1



=== TEST 7: multiple servers
--- args: t/tonodes.t -- foo.com '*foo' :~ -l -v
--- rc
blah=foo
--- out
--- err
Using Scp method.
Local files: [t/tonodes.t]
WARNING: Expanding target path ~ to /home/sshbatch
Cluster expression: foo.com *foo
Target path: /home/sshbatch
Cluster set: foo foo.com
--- status: 0



=== TEST 8: no dash-dash
--- args: t/tonodes.t foo.com '*foo' :~/ -l -v
--- rc
blah=foo
--- out
--- err
Using Scp method.
Local files: [t/tonodes.t]
WARNING: Expanding target path ~/ to /home/sshbatch/
Cluster expression: foo.com *foo
Target path: /home/sshbatch/
Cluster set: foo foo.com
--- status: 0



=== TEST 9: local file not found
--- args: t/dfsd2322asdfdt foo.com '*foo' :~
--- rc
blah=foo
--- out
--- err
Local file/directory t/dfsd2322asdfdt not found.
--- status: 1



=== TEST 10: -h
--- args: -h
--- out
USAGE:

    tonodes [OPTIONS] FILE... -- HOST_PATTERN... [OPTIONS]
    tonodes [OPTIONS] FILE HOST_PATTERN... [OPTIONS]

OPTIONS:
    -c <num>      Set SSH concurrency limit. (default: 20)
    -b <num>      bandwidth limit in Kbits/sec.
    -g            Use glob to process the input files/directories.
    -h            Print this help.
    -l            List the hosts and do nothing else.
    -L            Use the line-mode output format, i.e., prefixing
                  every output line with the machine name.
                  (could be controlled by the env SSH_BATCH_LINE_MODE)
    -p <port>     Port for the remote SSH service.
    -r            Recurse into directories too.
    -rsync        Use "rsync" to transfer files.
    -archive      Enable rsync archive mode
    -update       Enable rsync update
    -compress     Enable rsync compress
    -t <timeout>  Specify timeout for net traffic.
    -u <user>     User account for SSH login.
    -v            Be verbose.
    -w            Prompt for password (used mostly for login and sudo,
                  could be privided by SSH_BATCH_PASSWORD).
    -P            Prompt for passphrase (used mostly for login,
                  could be privided by SSH_BATCH_PASSPHRASE).
--- err
--- status: 0



=== TEST 11: option takes a value error
--- args: t foo.com '*foo' :~ -u
--- out
--- err
ERROR: Option -u takes a value.
--- status: 1



=== TEST 12: rsync
--- args: t/tonodes.t foo.com:/tmp/ -rsync -l -v
--- err
Using Rsync method.
Local files: [t/tonodes.t]
Cluster expression: foo.com
Target path: /tmp/
Cluster set: foo.com
--- out
--- status: 0



=== TEST 13: skipping directories w/o -r
--- args: t foo.com:~
--- err
Warning: Skipped directory t.
ERROR: No files to be transferred.
--- out
--- status: 1



=== TEST 14: ~foo shortcut
--- args: t/tonodes.t foo.com:~foo -l -v
--- err
Using Scp method.
Local files: [t/tonodes.t]
WARNING: Expanding target path ~foo to /home/foo
Cluster expression: foo.com
Target path: /home/foo
Cluster set: foo.com
--- out
--- status: 0



=== TEST 15: ~foo/abc shortcut
--- args: t/tonodes.t foo.com:~foo/abc -l -v
--- err
Using Scp method.
Local files: [t/tonodes.t]
WARNING: Expanding target path ~foo/abc to /home/foo/abc
Cluster expression: foo.com
Target path: /home/foo/abc
Cluster set: foo.com
--- out
--- status: 0



=== TEST 16: only leading ~ will be transformed
--- args: t/tonodes.t foo.com:~foo/baz~bar -l -v
--- err
Using Scp method.
Local files: [t/tonodes.t]
WARNING: Expanding target path ~foo/baz~bar to /home/foo/baz~bar
Cluster expression: foo.com
Target path: /home/foo/baz~bar
Cluster set: foo.com
--- out
--- status: 0

