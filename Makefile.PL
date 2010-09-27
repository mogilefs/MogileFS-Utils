#!/usr/bin/perl

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                        => 'MogileFS-Utils',
    VERSION_FROM                => 'lib/MogileFS/Utils.pm',
    AUTHOR                      => 'Brad Fitzpatrick <brad@danga.com>',
    ABSTRACT                    => 'MogileFS utilities',
    EXE_FILES                   => ['mogtool', 'mogadm', 'mogstats'],
    PREREQ_PM                   => {
        'LWP::Simple'      => 0,
        'Compress::Zlib'   => 0,
        'MogileFS::Client' => '1.13',
    },
    META_MERGE              => {
        resources => {
            homepage    =>      'http://danga.com/mogilefs/',
            bugtracker  =>      'http://rt.cpan.org/Public/Dist/Display.html?Name=MogileFS-Utils',
            repository  =>      'git://github.com/mogilefs/MogileFS-Utils.git',
            MailingList =>      'http://groups.google.com/group/mogile',
        },
    },
);
