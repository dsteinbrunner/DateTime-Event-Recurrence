use strict;

use Test::More tests => 3;

use DateTime;
use DateTime::SpanSet;
use DateTime::Event::Recurrence;

sub str { ref($_[0]) ? $_[0]->datetime : $_[0] }
sub span_str { str($_[0]->min) . '..' . str($_[0]->max) }

{
    my $dt1 = new DateTime( year => 2003, month => 4, day => 28,
                           hour => 12, minute => 10, second => 45,
                           nanosecond => 123456,
                           time_zone => 'UTC' );

    my $r1 = yearly DateTime::Event::Recurrence ( 
        months =>  [ 1 .. 12 ],
        days =>    [ 1 .. 31 ],
        hours =>   [ 0 .. 23 ],
        minutes => [ 0 .. 59 ],
        seconds => [ 0 .. 59 ],
    );
    my $r2 = daily DateTime::Event::Recurrence (
        hours =>   [ 0, 2, 4, 8, 10, 12, 14, 16, 18, 20, 22 ],
        minutes => [ 0, 15, 30, 45 ] );

    my $dt;

    $dt = $r1->next( $dt1 );
    is ( $dt->datetime, '2003-04-28T12:10:46', 'next' );
    $dt = $r1->next( $dt );
    is ( $dt->datetime, '2003-04-28T12:10:47', 'next' );

    my $r = $r1->intersection( $r2 );

    $dt = $r->next( $dt1 );
    is ( $dt->datetime, '2003-04-28T12:15:00', 'next intersection' );
}

__END__

# TODO: fatal error!
    $dt = $r->next( $dt );
    is ( $dt->datetime, '2003-04-28T12:30:00', 'next intersection' );
    $dt = $r->next( $dt );
    is ( $dt->datetime, '2003-04-28T12:45:00', 'next intersection' );
}

{
    # NO-INTERSECTION

    my $dt1 = new DateTime( year => 2003, month => 4, day => 28,
                           hour => 12, minute => 10, second => 45,
                           nanosecond => 123456,
                           time_zone => 'UTC' );

    my $r1 = yearly DateTime::Event::Recurrence (
        months =>  [ 10, 14 ],
        days =>    [ 15 ],
        hours =>   [ 14 ],
        minutes => [ 15 ] );

    my $r2 = daily DateTime::Event::Recurrence (
        hours =>   [ 11, 15 ],
        minutes => [ 15 ] );

    my $dt;

    my $r = $r1->intersection( $r2 );

    $dt = $r->next( $dt1 );
    is ( $dt, undef, 'next no-intersection' );
}

