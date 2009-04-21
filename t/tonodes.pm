package t::tonodes;

use Test::Base -Base;
use IPC::Run3 ();
use FindBin;

our @EXPORT = qw( run_tests );

if (!-d 't/tmp') {
    mkdir 't/tmp';
}
$ENV{HOME} = "$FindBin::Bin/tmp";
#warn $ENV{HOME};
my $RcFile = $ENV{HOME} . '/.fornodesrc';

sub run_tests () {
    for my $block (blocks()) {
        run_test($block);
    }
}

sub write_rc (@) {
    open my $out, ">$RcFile" or
        die "Failed to open $RcFile for writing: $!\n";
    print $out @_;
    close $out;
}

sub run_test ($) {
    my $block = shift;
    my $name = $block->name;
    my $args = $block->args;
    if (!defined $args) {
        die "$name - No --- args specified.\n";
    }
    chomp $args;
    if (!defined $args) {
        die "$name - No --- args specified.\n";
    }
    if (defined $block->rc) {
        write_rc($block->rc);
    } elsif (defined $block->no_rc) {
        unlink $RcFile;
    }
    my $prev_home;
    if (defined $block->no_home) {
        $prev_home = $ENV{HOME};
        $ENV{HOME} = '/foo/bar/baz/32rdssfsd32';
    }
    my $cmd = ("\"$^X\" bin/tonodes $args");
    my ($in, $out, $err);
    IPC::Run3::run3 $cmd, \$in, \$out, \$err;
    if (defined $block->status) {
        #warn "status: $?\n";
        if ($block->status == 0) {
            is($? >> 8, $block->status, "$name - status ok");
        } else {
            ok($? >> 8, "$name - status ok");
        }
    }
    if (defined $block->no_home) {
        $ENV{HOME} = $prev_home;
    }
    if (defined $block->err) {
        $err =~ s/\Q$RcFile\E/**RC_FILE_PATH**/g;
        is $err, $block->err, "$name - stderr ok";
    } elsif ($err) {
        warn $err, "\n";
    }
    if (defined $block->out) {
        $out =~ s/\Q$RcFile\E/**RC_FILE_PATH**/g;
        is $out, $block->out, "$name - stdout ok";
    }
}

1;

