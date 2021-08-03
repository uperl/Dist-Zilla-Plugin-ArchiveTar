# Dist::Zilla::Plugin::ArchiveTar ![static](https://github.com/uperl/Dist-Zilla-Plugin-ArchiveTar/workflows/static/badge.svg) ![linux](https://github.com/uperl/Dist-Zilla-Plugin-ArchiveTar/workflows/linux/badge.svg)

Create dist archives using  Archive::Tar

# SYNOPSIS

In your `dist.ini`

```
[ArchiveTar]
```

# DESCRIPTION

This [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) plugin overrides the build in archive builder and uses [Archive::Tar](https://metacpan.org/pod/Archive::Tar) only.
Although [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) does frequently use [Archive::Tar](https://metacpan.org/pod/Archive::Tar) itself, it is different from the built
in version in the following ways:

- Predictable

    The built in behavior will sometimes use [Archive::Tar](https://metacpan.org/pod/Archive::Tar) or [Archive::Tar::Wrapper](https://metacpan.org/pod/Archive::Tar::Wrapper).  The problem with [Archive::Tar::Wrapper](https://metacpan.org/pod/Archive::Tar::Wrapper)
    is that it depends on the system implementation of tar, which in some cases can produce archives that are not readable by older
    implementations of tar.  In particular GNU tar which is typically the default on Linux systems includes unnecessary features that
    break tar on HP-UX.  (You should probably be getting off HP-UX if you are still using it in 2021 as I write this).

- Sorted by name

    The contents of the archive are sorted by name instead of being sorted by filename length.  While sorting by length makes for
    a pretty display when they are unpacked, I find it harder to find stuff when the content is listed.

- Additional formats

    This plugin supports the use of compression formats supported by [Archive::Tar](https://metacpan.org/pod/Archive::Tar).

# PROPERTIES

## format

```
[ArchiveTar]
format = tar.gz
```

Sets the output format.  The default, most common and easiest to unpack for cpan clients is `tar.gz`.  You should consider
carefully before not using the default.  Supported formats:

- `tar`
- `tar.gz`
- `tar.bz2`
- `tar.xz`

# SEE ALSO

- [Archive::Libarchive](https://metacpan.org/pod/Archive::Libarchive)
- [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla)
- [Dist::Zilla::Plugin::Libarchive](https://metacpan.org/pod/Dist::Zilla::Plugin::Libarchive)
- [Dist::Zilla::Role::ArchiveBuilder](https://metacpan.org/pod/Dist::Zilla::Role::ArchiveBuilder)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2021 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
