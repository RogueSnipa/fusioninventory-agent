package FusionInventory::Agent::Task::Inventory::OS::MacOS::Video;

use strict;
use warnings;

use FusionInventory::Agent::Tools;

sub isInventoryEnabled {
    return
        -r '/usr/sbin/system_profiler' &&
        can_load("Mac::SysProfile");
}

sub doInventory {
    my ($params) = @_;

    my $inventory = $params->{inventory};

    my $prof = Mac::SysProfile->new();
    my $h = $prof->gettype('SPDisplaysDataType');
    return unless ref($h) eq 'HASH';

    # add the video information
    foreach my $x (keys %$h){
        my $memory = $h->{$x}->{'VRAM (Total)'};
        $memory =~ s/ MB$//;
        $inventory->addVideo({
                'NAME'        => $x,
                'CHIPSET'     => $h->{$x}->{'Chipset Model'},
                'MEMORY'    => $memory,
        });

        # this doesn't work yet, need to fix the Mac::SysProfile module to not be such a hack (parser only goes down one level)
        # when we do fix it, it will attach the displays that sysprofiler shows in a tree form
        # apple "xml" blows. Hard.
        foreach my $display (keys %{$h->{$x}}){
            my $ref = $h->{$x}->{$display};
            next unless(ref($ref) eq 'HASH');

            $inventory->addMonitor({
                'CAPTION'       => $ref->{'Resolution'},
                'DESCRIPTION'   => $display,
            })
        }
    }

}

1;
