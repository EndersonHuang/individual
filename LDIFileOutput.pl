#! /usr/bin/perl

use strict;
use utf8;
use Tk;
my $mw;
#use MyGenesis_hyp;
#use lib qw(/genesis/e102/all/perl);
#use Genesis;
#my $host = shift;
#my $f = new Genesis($host);
#my $JOB = $ENV{JOB};
#my $STEP = $ENV{STEP};
##

my ( $xProfile,$yProfile,@layerArgv ) = (@ARGV);
my $ldiLayers = \@layerArgv;
#my $ldiLayers = ['smt','dmt','top','s2t','s3b','p4t','p5b','s6t','bot','smb','dmb'];
#my $xProfile = 21;
#my $yProfile = 24;

&main($ldiLayers,$xProfile,$yProfile);
#print "End\n";
exit;

sub main
{
    &mainWindow($ldiLayers,$xProfile,$yProfile);
}

sub mainWindow
{
    my ($ldiLayers,$xProfile,$yProfile) = (@_);
    my @ldiLayers = @$ldiLayers;
    
    require Tk::LabEntry;
    
    $mw = new MainWindow(-title,"LDI File Output Script version: 1.0 2016-06-13");
    $mw -> geometry("+550+70");
    my $multekLogo = $mw-> Photo(-file=>"/genesis/sys/scripts/hyp/perl_file/One_Color.GIF");
    $mw -> Label (-relief=>'flat',
                  -background=>'white',
                  -justify=>'center',
                  -image=>$multekLogo)-> pack(-anchor=>'center',-fill=>'x');
    $mw -> Label(-text=>'LDI资料自动output程序',
                   -anchor=>'center',
                   -font=>'charter 15 bold',
                   -relief=>'raised',
                   -background=>'#dfef52',
                   -height=>2)->pack(-expand=>1,-fill=>'both');
    
    my $frame1 = $mw->Frame->pack(-fill=>'both');
    my $listScrolld = $frame1->Scrolled('Listbox',-relief=>'sunken',
                                        -background=>'#fec038',
                                        -cursor=>'hand2',                                        
                                        -selectmode=>'multiple',
                                        -font=>'charter 15 normal',
                                        -height=>10,
                                        -selectbackground=>'#00009a',
                                        -scrollbars=>'e',
                                        -selectforeground=>'White',
                                        -exportselection=>0,
                                        ,)-> pack(-anchor=>'se',-side=>'left',-fill=>'x',-expand=>1);
    $listScrolld->insert(0,@ldiLayers);
    
    
    
    $mw->Label(-text=>'LDI 输出参数设置',
                   -anchor=>'center',
                   -font=>'charter 10 bold')->pack(-expand=>1,-side=>'top',-pady=>2,-fill=>'x');
    
    my $frame2 = $mw -> Frame(-relief=>'groove',-borderwidth=>'4')->pack(-fill=>'both');
    
    my $xProfileValue;
    my $yProfileValue;
    my $frame8 = $frame2 -> Frame(-relief=>'solid',)->pack(-fill=>'both');
    
    
    my $layerSelectType;
    $frame8 -> Radiobutton(-text=>'内层',
                           -height=>2,
                           -command=>sub{&layerSelection($layerSelectType,$listScrolld)},
                           -variable=>\$layerSelectType,
                           -font=>'charter 10 bold',
                           -cursor=>'hand2')->pack(-side=>"left",-expand=>1,-fill=>'x');
    $frame8 -> Radiobutton(-text,'外层',
                           -height=>2,
                           -value=>'outer',
                           -variable=>\$layerSelectType,
                           -command=>sub{&layerSelection($layerSelectType,$listScrolld)},
                           -font=>'charter 10 bold',
                           -cursor=>'hand2')->pack(-side=>"left",-expand=>1,-fill=>'x');
    #$frame8 -> Radiobutton(-text,'次外层',
    #                       -height=>2,
    #                       -value=>'lowOuter',
    #                       -variable=>\$layerSelectType,
    #                       -command=>sub{&layerSelection($layerSelectType,$listScrolld)},
    #                       -font=>'charter 10 bold')->pack(-side=>"left",-expand=>1,-fill=>'x');
    #$frame8 -> Radiobutton(-text,'所有层',
    #                       -height=>2,
    #                       -value=>'all',
    #                       -variable=>\$layerSelectType,
    #                       -command=>sub{&layerSelection($layerSelectType,$listScrolld)},
    #                       -font=>'charter 10 bold')->pack(-side=>"left",-expand=>1,-fill=>'x');
    $frame8 -> Radiobutton(-text,'手动选择',
                           -height=>2,
                           -value=>'manual',
                           -variable=>\$layerSelectType,
                           -command=>sub{&layerSelection($layerSelectType,$listScrolld)},
                           -font=>'charter 10 bold',
                           -cursor=>'hand2')->pack(-side=>"left",-expand=>1,-fill=>'x');
    $listScrolld->configure(-state=>'disable');
    
    my $frame3 = $frame2 -> Frame()->pack(-fill=>'both');
    
    my $xProfileEntry = $frame3 -> LabEntry(-label=>'Profile X:',
                                            -relief=>'sunken',
                                            -labelPack=>[-side=>'left'],
                                            -textvariable=>\$xProfileValue,
                                            -font=>'charter 10 bold')->pack(-side=>'left',-fill=>'x',-expand=>1);
    $xProfileEntry->insert(0,$xProfile);
    
    my $yProfileEntry = $frame3 -> LabEntry(-label=>'Profile Y:',
                                            -relief=>'sunken',
                                            -labelPack=>[-side=>'left'],
                                            -font=>'charter 10 bold',
                                            -textvariable=>\$yProfileValue)->pack(-side=>'left',-fill=>'x',-expand=>1);
    $yProfileEntry->insert(0,$yProfile);
    
    my $frame4 = $frame2->Frame(-relief=>'solid',)->pack(-fill=>'both');     
    $frame4 -> Label(-text=>'板方向：',
                    -anchor=>'w',
                    -font=>'charter 10 bold',)->pack(-expand=>1,-side=>'left',-pady=>2,-fill=>'x');
    my $orientationValue;  
    $frame4 -> Radiobutton(-text,'横向',
                           -height=>2,
                           -variable=>\$orientationValue,
                           -command=>sub{&oriSelection($orientationValue)},
                           -font=>'charter 10 bold',
                           -cursor=>'hand2')->pack(-side=>"left");
    $frame4 -> Radiobutton(-text,'竖向',
                           -height=>2,
                           -value=>'vertical',
                           -variable=>\$orientationValue,
                           -command=>sub{&oriSelection($orientationValue)},
                           -font=>'charter 10 bold',
                           -cursor=>'hand2')->pack(-side=>"left");
    
    my $frame5 = $frame2->Frame(-relief=>'solid')->pack(-fill=>'both');     
    $frame5 -> Label(-text=>'选择Output分厂：',
                   -anchor=>'w',
                   -font=>'charter 10 bold',)->pack(-expand=>1,-side=>'left',-pady=>2,-fill=>'x');
    my $plantValue;  
    $frame5 -> Radiobutton(-text,'B5',
                           -height=>2,
                           -variable=>\$plantValue,
                           -cursor=>'hand2',
                           -command=>sub{&plantSelection($plantValue)})->pack(-side=>"left");
    $frame5 -> Radiobutton(-text,'B3',
                           -height=>2,
                           -value=>'B3',
                           -variable=>\$plantValue,
                           -cursor=>'hand2',
                           -command=>sub{&plantSelection($plantValue)})->pack(-side=>"left");
    
    my $fileCode;
    my $frame6 = $frame2 -> Frame(-relief=>'solid')
        ->pack(-fill=>'both');     
    my $fileCodeEntry = $frame6 -> LabEntry(-label=>'输入文件代号：',
                                            -relief=>'sunken',
                                            -labelPack=>[-side=>'left'],
                                            -font=>'charter 10 bold',
                                            -textvariable=>\$fileCode)->pack(-side=>'left',-expand=>1,-fill=>'x');    
    $fileCodeEntry -> insert(0,'00');
    my $frame7 = $mw->Frame->pack(-side=>'bottom');
    $frame7->Button(-text,'继续',
                    -font=>[-size=>10],
                    -width=>'8',
                    -height=>'2',
                    -activebackground=>'green',
                    -cursor=>'hand2',
                    -command=>sub{&continueAction($xProfileValue,$yProfileValue,$orientationValue,$plantValue,$fileCode,$listScrolld,$layerSelectType,$ldiLayers)})->pack(-side=>"left",-padx=>"50",-pady=>"10");
    $frame7->Button(-text,'退出',
                    -font=>[-size=>10],
                    -width=>'8',
                    -height=>'2',
                    -command=>sub
                    {
                        open(FILE,">/tmp/soureFileForTk.txt");
                        print FILE "set quit = 2\n";                        
                        close FILE;
                        $mw->destroy;
                        exit 0;
                    },
                    -state=>'normal',
                    -activebackground=>'red',
                    -cursor=>'hand2')->pack(-side=>"left",-padx=>"50",-pady=>"10");
    
    MainLoop;
}

sub continueAction
{
    $mw->withdraw;
    my @outPutLayer;

    my ($xProfileValue,$yProfileValue,$orientationValue,$plantValue,$fileCode,$listScrolld,$layerSelectType,$ldiLayers) = (@_);
    
    if ($fileCode eq '' )
    {
        $mw->messageBox(-icon=>'error',-type=>'OK',-title=>'Error detect',-message=>'文件代号为空，请重新输入！');
        $mw->deiconify;
    } else { 
        
        if ($orientationValue eq '')
        {
             $orientationValue = 'landscape';
        }
        if ($plantValue eq '')
        {
            $plantValue = 'B5';
        }
                
        my @ldiLayers = @$ldiLayers;
        if ( $layerSelectType eq '' )
        {
            @outPutLayer = grep /\A\w{3}\d{1,2}-\w{3}\Z/,@ldiLayers;    ## pattern innerlayer
            $mw->destroy;
        }
        elsif ( $layerSelectType eq 'outer' )
        {
            @outPutLayer = grep /\Acs\Z|\Ass\Z/,@ldiLayers; ## pattern outer layer : cs ss
            $mw->destroy;
        }
        elsif ( $layerSelectType eq 'all')
        {
            @outPutLayer = @ldiLayers;
            $mw->destroy;
        }
        else
        {
            if ( ! $listScrolld->curselection )
            {
                print "No selections \n";
                $mw->messageBox(-icon=>'error',-type=>'OK',-title=>'Error detect',-message=>'未选择层，请重新选择！');
                $mw->deiconify;   
            } else {
                @outPutLayer = map({$listScrolld->get($_)} $listScrolld->curselection);
                print "@outPutLayer\n";
                $mw->destroy;
            }
        }    
        
        print "layer = @outPutLayer\n";
        print "$xProfileValue-$yProfileValue-$orientationValue-$plantValue-$fileCode\n";
        
        if ( $orientationValue eq 'landscape')
        {
            $orientationValue = '1';
        }
        else
        {
            $orientationValue = '2';
        }
        
        if ( $plantValue eq 'B5')
        {
            $plantValue = '1';
        }
        else
        {
            $plantValue = '2';
        }
    
        open(FILE,">/tmp/soureFileForTk.txt");
        print FILE "set x_size = $xProfileValue\n";
        print FILE "set y_size = $yProfileValue\n";
        print FILE "set orientation = $orientationValue\n";
        print FILE "set ldiPlant = $plantValue\n";
        print FILE "set fileName = $fileCode\n";
        print FILE "set layers = \(@outPutLayer\)\n";   
        print FILE "set quit = 1\n"; 
        close FILE;
    }
    
}


sub plantSelection
{
    my $plantValue = shift;
    $plantValue = 'B5' if ( $plantValue eq '');
    print "$plantValue\n";
}

sub oriSelection
{
    my $orientationValue = shift;
    $orientationValue = 'lanscape' if ( $orientationValue eq '' );
    
    print "$orientationValue\n";
}

sub layerSelection
{
    my $layerSelectType = shift;
    my $listScrolld = shift;
    $layerSelectType = 'inner' if ( $layerSelectType eq '' );
    $listScrolld->configure(-state=>'normal') if ($layerSelectType eq 'manual');
    $listScrolld->configure(-state=>'disable') if ($layerSelectType ne 'manual');
    
    print "$layerSelectType\n";
}






