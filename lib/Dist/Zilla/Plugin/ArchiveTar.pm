use strict;
use warnings;
use 5.020;
use experimental qw( postderef );

package Dist::Zilla::Plugin::ArchiveTar {

  use Moose;
  use Archive::Tar;
  use Path::Tiny ();
  use Moose::Util::TypeConstraints;
  use namespace::autoclean;
  use experimental qw( signatures postderef );

  # ABSTRACT: Create dist archives using  Archive::Tar

  with 'Dist::Zilla::Role::ArchiveBuilder';

  enum ArchiveFormat => [qw/ tar tar.gz tar.bz2 tar.xz /];

  has format => (
    is       => 'ro',
    isa      => 'ArchiveFormat',
    required => 1,
    default  => 'tar.gz',
  );

  our $VERBOSE;

  sub build_archive ($self, $archive_basename, $built_in, $basedir)
  {
    my $archive = Archive::Tar->new;

    my $archive_path = Path::Tiny->new(join '.', $archive_basename, $self->format);

    my %dirs;
    my $verbose = $VERBOSE || $self->zilla->logger->get_debug;

    my $now = time;
    foreach my $distfile (sort { $a->name cmp $b->name } $self->zilla->files->@*)
    {
      {
        my @parts = split /\//, $distfile->name;
        pop @parts;

        my $dir = '';
        foreach my $part ('', @parts)
        {
          $dir .= "/$part";
          next if $dirs{$dir};
          $dirs{$dir} = 1;

          $self->log("DIR  @{[ $basedir->child($dir) ]}") if $verbose;
          $archive->add_data(
            $basedir->child($dir),
            '',
            {
              type  => Archive::Tar::Constant::DIR(),
              mode  => oct('0755'),
              mtime => $now,
              uid   => 0,
              gid   => 0,
              uname => 'root',
              gname => 'root',
            }
          );
        }
      }

      $self->log("FILE @{[ $basedir->child($distfile->name) ]}") if $verbose;
      $archive->add_data(
        $basedir->child($distfile->name),
        $built_in->child($distfile->name)->slurp_raw,
        {
          mode  => -x $built_in->child($distfile->name) ? oct('0755') : oct('0644'),
          mtime => $now,
          uid   => 0,
          gid   => 0,
          uname => 'root',
          gname => 'root',
        },
      );
    }

    $self->log("writing archive to $archive_path");

    if($self->format eq 'tar.gz')
    {
      $archive->write("$archive_path", Archive::Tar::COMPRESS_GZIP());
    }
    elsif($self->format eq 'tar')
    {
      $archive->write("$archive_path");
    }
    elsif($self->format eq 'tar.bz2')
    {
      $archive->write("$archive_path", Archive::Tar::COMPRESS_BZIP());
    }
    elsif($self->format eq 'tar.xz')
    {
      $archive->write("$archive_path", Archive::Tar::COMPRESS_XZ());
    }

    return $archive_path;
  }

  __PACKAGE__->meta->make_immutable;
}

1;


