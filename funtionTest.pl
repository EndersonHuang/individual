#! /usr/bin/perl -w
use strict;
use Tk;
use utf8;
use warnings;

my @array = qw/a b c d e/;
#printf ("\@array = @array \n");
my %hash = (-name=>'hyp',-sex=>'mali');
my $value = \@array;
&test($value);

sub mainWindow
{
    my $mw = MainWindow -> new(-title=>'MainWindow');
    $mw->geometry("300x100+100+100");
    our $tmpValue;
    $mw->Radiobutton(-text=>'yes',-value=>'yes',-variable=>\$tmpValue,-command=>\&printValue)->pack(-pady=>'10');
    $mw->Radiobutton(-text=>'no',-variable=>\$tmpValue,-command=>\&printValue,)->pack(-pady=>'10');
    $mw->Button(-text=>"continue",-command=>sub{\&event1()})->pack(-pady=>'20');
    MainLoop;
}

sub printValue
{
    our $tmpValue;
    print "tmpValue = $tmpValue \n" if ( $tmpValue eq '' );
    print "tmpValue = $tmpValue \n" if ( $tmpValue ne '' );
    #printf "tmpValue = $tmpValue \n";
}

sub test
{
    my $var = shift;
    #$var = $var -> [3];
    my $i = 0;
    my @array = ();
    while($$var[$i]){
        push (@array,$$var[$i]);
        $i++;
    }
    
    printf ("\@array = @array- \n");
    
    
}