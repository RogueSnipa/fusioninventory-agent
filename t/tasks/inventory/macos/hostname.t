#!/usr/bin/perl

use strict;
use warnings;

use Test::Deep;
use Test::Exception;
use Test::More;
use Test::NoWarnings;

use FusionInventory::Agent::Task::Inventory::MacOS::Hostname;

my %tests = (
    '10.6-system_profiler_Software_SPSoftwareDataType' => 'mac-fusion01'
);

plan tests => 2;

my $pathToResourcesDir = 'resources/macos/system_profiler/';
for my $fileName (keys %tests) {
    my $filePath = $pathToResourcesDir . $fileName;
    my $hostname = FusionInventory::Agent::Task::Inventory::MacOS::Hostname::_getHostname(file => $filePath, format =>
        'text');
    ok ($hostname eq $tests{$fileName});
}
