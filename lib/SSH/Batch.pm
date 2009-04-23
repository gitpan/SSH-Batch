package SSH::Batch;

use strict;
use warnings;

our $VERSION = '0.011';

1;
__END__

=head1 NAME

SSH::Batch - Cluster operations based on parallel SSH, set and interval arithmetic

=head1 SYNOPSIS

The following scripts are provided:

=over

=item fornodes

Expand patterns to machine host list.

    $ cat > ~/.fornodesrc
    ps=blah.ps.com bloo.ps.com boo[2-25,32,41-70].ps.com
    as=ws[1101-1105].as.com
    # use set operations to define new sets:
    foo={ps} + {ps} * {as} - {ps} / {as}
     bar = foo.com bar.org \
        bah.cn \
        baz.com
    ^D

    $ fornodes 'api[02-10].foo.bar.com' 'boo*.ps.com'
    $ fornodes 'tq[ab-ac].[1101-1105].foo.com'
    $ fornodes '{ps} + {as} - ws1104.as.com'  # set union and subtraction
    $ fornodes '{ps} * {as}'  # set intersect

=item atnodes

Run command on clusters. (atnodes calls fornodes internally.)

    # run a command on the specified servers:
    $ atnodes $'ps -fe|grep httpd' 'ws[1101-1105].as.com'

    # multiple-arg command requires "--":
    $ atnodes ls /opt/ -- '{ps} + {as}' 'localhost'

    # or use single arg command:
    $ atnodes 'ls /opt/' '{ps} + {as}' 'localhost' # ditto

    # specify a different user name and SSH server port:
    $ atnodes hostname '{ps}' -u agentz -p 12345

    # use -w to prompt for password if w/o SSH key (no echo back)
    $ atnodes hostname '{ps}' -u agentz -w

    # or prompt for password if sudo required...
    $ atnodes 'sudo apachectl restart' '{ps}' -w

    # or specify a timeout:
    $ atnodes 'ping foo.com' '{ps}' -t 3

=item tonodes

Upload local files/directories to remote clusters

    $ tonodes /tmp/*.inst -- '{as}:/tmp/'
    $ tonodes foo.txt 'ws1105*' :/tmp/bar.txt

    # use rsync instead of scp:
    $ tonodes foo.txt 'ws1105*' :/tmp/bar.txt -rsync

    $ tonodes -r /opt /bin/* -- 'ws[1101-1102].foo.com' 'bar.com' :/foo/bar/

=item key2nodes

Push the SSH public key (or generate one if not any) to the remote clusters.

    $ key2nodes 'ws[1101-1105].as.com'

=back

=head1 DESCRIPTION

This is a high-level abstraction over the powerful L<Net::OpenSSH> module. A bunch of handy scripts are provided to simplify big cluster operations: L<fornodes>, L<atnodes>, L<tonodes>, and L<key2nodes>.

Parallel SSH communication is used to ensure minimal latency.

=head1 PREREQUISITES

This module uses L<Net::OpenSSH> behind the scene, so it requires the OpenSSH I<client> executable (usually spelled "ssh") with multiplexing support (at least OpenSSH 4.1). To check your C<ssh> version, use the command:

    $ ssh -v

On my machine, it echos

    OpenSSH_4.7p1 Debian-8ubuntu1.2, OpenSSL 0.9.8g 19 Oct 2007
    usage: ssh [-1246AaCfgKkMNnqsTtVvXxY] [-b bind_address] [-c cipher_spec]
               [-D [bind_address:]port] [-e escape_char] [-F configfile]
               [-i identity_file] [-L [bind_address:]port:host:hostport]
               [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port] [-R [bind_address:]port:host:hostport] [-S ctl_path]
               [-w local_tun[:remote_tun]] [user@]hostname [command]

There's no spesial requirement on the server side ssh service. Even a non-OpenSSH server-side deamon should work as well.

=head1 INSTALLATION

    perl Makefile.PL
    make
    make test
    sudo make install

Win32 users should replace "make" with "nmake".

=head1 SOURCE CONTROL

You can always get the latest SSH::Batch source from its
public Git repository:

    http://github.com/agentzh/sshbatch/tree/master

If you have a branch for me to pull, please let me know ;)

=head1 SEE ALSO

L<fornodes>, L<atnodes>, L<tonodes>, L<key2nodes>,
L<SSH::Batch::ForNodes>, L<Net::OpenSSH>.

=head1 COPYRIGHT AND LICENSE

This module as well as its programs are licensed under the BSD License.

Copyright (c) 2009, Yahoo! China EEEE Works, Alibaba Inc. All rights reserved.

Copyright (C) 2009, Agent Zhang (agentzh). All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

=over

=item *

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

=item *

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

=item *

Neither the name of the Yahoo! China EEEE Works, Alibaba Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

=back

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

