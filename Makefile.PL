#!/usr/bin/perl

use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                        => 'MogileFS-Utils',
    VERSION_FROM                => 'lib/MogileFS/Utils.pm',
    AUTHOR                      => 'Brad Fitzpatrick <brad@danga.com>',
    ABSTRACT                    => 'MogileFS utilities',
    EXE_FILES                   => ['mogtool', 'mogadm', 'mogstats',
        'mogupload', 'mogfetch', 'mogdelete', 'mogfileinfo', 'moglistkeys',
        'moglistfids', 'mogfiledebug', 'mogrename',
                                   ],
    PREREQ_PM                   => {
        'LWP::Simple'      => 0,
        'Compress::Zlib'   => 0,
        'MogileFS::Client' => '1.14',
    },
    META_MERGE              => {
        resources => {
            homepage    =>      'http://www.mogilefs.org',
            bugtracker  =>      'http://code.google.com/p/mogilefs/issues/list',
            repository  =>      'git://github.com/mogilefs/MogileFS-Utils.git',
            MailingList =>      'http://groups.google.com/group/mogile',
        },
    },
);
