#! /usr/bin/perl -w
use strict;
use Tk;
my $cb1 = 100;
my $cb2 = 100;
my $rb1 = 100;
my $rb2 = 100;

my $mw=MainWindow->new(-title=>'GUI');
$mw->geometry("300x200+400+100");
$mw->Label(-text=>"GUI TEST",-background=>'blue',-height=>1,-font=>[-size=>15])->pack(-pady=>10,-fill=>'both');
my $en_ = $mw->Entry(-textvariable=>'3',-state=>'disable')->pack();

my $cb_fr = $mw -> Frame->pack;
$cb_fr -> Checkbutton(-text=>'one',-variable=>\$cb1,-state=>'disable')->pack(-side=>'left');
$cb_fr -> Checkbutton(-text=>'one',-variable=>\$cb2)->pack(-side=>'right');

my $rb_fr = $mw -> Frame->pack;
$rb_fr -> Radiobutton(-text=>'one',-variable=>\$rb1,-value=>'10')->pack(-side=>'left');
$rb_fr -> Radiobutton(-text=>'one',-variable=>\$rb1,-value=>'20')->pack(-side=>'right');

my $final = $mw -> Frame->pack;
$final -> Button(-text=>'Continue',-command=>\&Goruning,-width=>20,-height=>2)->pack(-side=>'left',-pady=>20,-padx=>20,-expand=>1);
$final -> Button(-text=>'Quit',-command=>sub{exit},-width=>20,-height=>2)->pack(-side=>'right',-pady=>20,-padx=>20,-expand=>1);
MainLoop;

sub Goruning {
    my $pt = $en_->cget(-textvariable);
    print "$pt \n";
}


