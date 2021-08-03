use strict;
use warnings;
use 5.020;
use experimental qw( postderef );

package Dist::Zilla::Plugin::ArchiveTar {

  use Moose;
  use namespace::autoclean;

  # ABSTRACT: Create dist archives using  Archive::Tar

  __PACKAGE__->meta->make_immutable;
}

1;


