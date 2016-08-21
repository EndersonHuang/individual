#! /usr/bin/perl -w
use strict;
use Tk;
use utf8;
use Encode;
use warnings;
use Tk::X11Font;
##

#my (@layerTmp) = (@ARGV);

my @layerTmp = ('sc','s','a'..'h','cs','ss');
&outerPolaritySelectMain(@layerTmp);
exit;

sub outerPolaritySelectMain
{
    my (@layerTmp) = (@_);
    my @csPattern = grep /\Acs\Z/,@layerTmp;
    my @ssPattern = grep /\Ass\Z/,@layerTmp;
    my $allVariable = {};
    
    my $promptMW;
    if (@csPattern == 1 || @ssPattern == 1)
    {
        $promptMW = new MainWindow(-title,"LDI File Auto Output -v1.0 2016-06-07");
        $promptMW -> geometry("+300+300");
	
	my $fontValue = $promptMW->fontCreate('tipFont',
			      -family=>'Times',
			      -size=>'60',
			      -weight=>'bold',
			      -slant=>'italic');
	my @valueFont = $promptMW->fontActual('tipFont');
	print "Defined Font = @valueFont\n";
        
	my $frame = $promptMW->Frame->pack(-expand=>1,
                                           -fill=>'x',
                                           -side=>'top',
                                           -pady=>2);
        
        my $frame2 = $promptMW->Frame(-relief=>'groove',
				      -borderwidth=>'2')->pack(-fill=>'both');
        
        my $tipWidget = $frame -> Label ( -text=>'请注意周期更改！！',
	#my $tipWidget = $frame -> Label ( -text=>'注意fdfdfdfdf！！',
					  -font=>'tipFont',	
					  -background=>'red',
					  -foreground=>'black',
					  -justify=>'center',
					  -anchor=>'w') -> pack(-anchor=>'w',-pady=>2,-fill=>'x');        
	
        #my $frame3 = $frame2 -> Frame -> pack(-fill=>'both',-expand=>1);
        my $labFrame = $promptMW -> LabFrame( -label=>'请选择外层排片极性:',
                             -font=>'charter 10 bold',
                             #-background=>'yellow',
                             -labelside=>'acrosstop') -> pack(-anchor=>'w',-fill=>'x');    
        #if ( @csPattern == 1)
        #{
        #    $frame3 -> Label(-text=>'cs 层极性：',
        #             -anchor=>'w',
        #             -font=>'charter 10 bold',)->pack(-expand=>1,-side=>'left',-pady=>2,-fill=>'x');
        #    $allVariable->{csRB_N} = $frame3 -> Radiobutton(-text=>'负片',
        #                                                    -height=>2,
        #                                                    -variable=>\$allVariable->{csPolarity},
        #                                                    -cursor=>'hand2',
        #                                                    -background=>'#9f75ff',
        #                                                    -command=>sub{&csLayerSelection($allVariable)})->pack(-side=>"left");
        #    $allVariable->{csRB_P} = $frame3 -> Radiobutton(-text,'正片',
        #                           -height=>2,
        #                           -value=>2,
        #                           -variable=>\$allVariable->{csPolarity},
        #                           -cursor=>'hand2',
        #                           -command=>sub{&csLayerSelection($allVariable)})->pack(-side=>"left");   
        #}
        
        #if ( @ssPattern == 1 )
        #{
        #    my $frame4 = $frame2->Frame(-relief=>'solid')->pack(-fill=>'both',-expand=>1);     
        #    $frame4 -> Label(-text=>'ss 层极性：',
        #                     -anchor=>'w',
        #                     -font=>'charter 10 bold',)->pack(-expand=>1,-side=>'left',-pady=>2,-fill=>'x');
        #
        #   $allVariable->{ssRB_N} = $frame4 -> Radiobutton(-text=>'负片',
        #                           -height=>2,
        #                           -variable=>\$allVariable->{ssPolarity},
        #                           -cursor=>'hand2',
        #                           -background=>'#9f75ff',
        #                           -command=>sub{&ssLayerSelection($allVariable)})->pack(-side=>"left");
        #    $allVariable->{ssRB_P} = $frame4 -> Radiobutton(-text,'正片',
        #                           -height=>2,
        #                           -value=>'2',
        #                           -variable=>\$allVariable->{ssPolarity},
        #                           -cursor=>'hand2',
        #                           -command=>sub{&ssLayerSelection($allVariable)})->pack(-side=>"left",-fill=>'x'); 
        #}
    
	if (@csPattern == 1 || @ssPattern == 1)
	{
	    #my $frameOuterType = $promptMW->Frame->pack(-expand=>1,-fill=>'x');
	    $labFrame -> Label (-text=>'流程选择:    ',
	        		      -font=>'chater 10 bold',	
				      #-background=>'red',
				      -foreground=>'black',
				      -justify=>'center',
				      -anchor=>'w') -> pack(-anchor=>'w',-pady=>2,-fill=>'x',-side=>'left');  
	    $allVariable->{rb_OuterType_P} = $labFrame -> Radiobutton(-text=>'正片流程',
						                            -height=>2,
									    -value=>'positive',
								            -variable=>\$allVariable->{outerType},
									    -cursor=>'hand2',
									    -command=>sub{&outerType($allVariable)})->pack(-side=>"left");
	    $allVariable->{rb_OuterType_N} = $labFrame -> Radiobutton(-text=>'负片流程',
									    -height=>2,
									    -value=>'negative',
									    -variable=>\$allVariable->{outerType},
									    -cursor=>'hand2',
									    -command=>sub{&outerType($allVariable)})->pack(-side=>"left");	
	}
	
	
	
	my $frame1 = $promptMW->Frame->pack(-side=>'bottom');
        my $continueButton = $frame1->Button(-text=>'继续(3)',
					     -font=>[-size=>10],
					     -width=>'6',
					     -height=>'2',
  					     -activebackground=>'green',
					     #-state=>'disable',
					     -command=>sub{&polarityMainAction($promptMW,$allVariable)})->pack(-side=>"left",-padx=>"30",-pady=>"5");
        
	$frame1->Button(-text=>'退出',
                        -font=>[-size=>10],
                        -width=>'6',
                        -height=>'2',
                        -command=>sub{&exiter($promptMW,$allVariable)},
                        -state=>'normal',-activebackground=>'red')->pack(-side=>"left",-padx=>"30",-pady=>"5");
        
        #$continueButton->after(1000,sub{$continueButton->configure(-text=>'继续(2)',-state=>'disable')});
        #$continueButton->after(2000,sub{$continueButton->configure(-text=>'继续(1)',-state=>'disable')});
        #$continueButton->after(3000,sub{$continueButton->configure(-text=>'继续',-state=>'normal')});
        
        MainLoop;                
    
    } else {
    
        open(PROMPT,">/tmp/outerWindowtStatus");
    
        printf PROMPT "set outerWindowtStatus = \'continue\'\n";
        printf PROMPT "set csPolarity = none\n";
        printf PROMPT "set ssPolarity = none\n";
        close PROMPT;
        
        exit 0;
    }    
}

sub polarityMainAction
{
    my $promptMW = shift;
    my $allVariable = shift;
    
    #if (! $allVariable->{csPolarity})
    #{
    #    $allVariable->{csPolarity} = '1';    
    #}
    #if (! $allVariable->{ssPolarity})
    #{
    #    $allVariable->{ssPolarity} = '1';    
    #}    
    
    if ( $allVariable->{outerType} )
    {
	
	if ($allVariable->{outerType} eq 'positive')
	{
	    $allVariable->{csPolarity} = 1 ;
	    $allVariable->{ssPolarity} = 1 ;
	}
	else
	{
	    $allVariable->{csPolarity} = 2 ;
	    $allVariable->{ssPolarity} = 2 ;
	}
	
	
	
	
	
	print "cs=".$allVariable->{csPolarity}."\n";
	print "ss=".$allVariable->{ssPolarity}."\n";
	
	open(PROMPT,">/tmp/outerWindowtStatus");
	
	printf PROMPT "set outerWindowtStatus = \'continue\'\n";
	printf PROMPT "set csPolarity = $allVariable->{csPolarity}\n";
	printf PROMPT "set ssPolarity = $allVariable->{ssPolarity}\n";
	close PROMPT;
	
	$promptMW -> destroy;
	exit;
	
    }
    else
    {
	$promptMW->messageBox(-icon=>'error',-type=>'OK',-title=>'Error detect',-message=>'未选择输出流程，请重新选择！');
        $promptMW->deiconify;   
    }    
}

sub exiter
{
    my $promptMW = shift;
    open(OUTER_PROMPT,">/tmp/outerWindowtStatus");
    printf OUTER_PROMPT "set outerWindowtStatus = \'exit\'\n";
    close OUTER_PROMPT;
    
    $promptMW -> destroy;
    exit;
}

sub csLayerSelection
{
    my $allVariable = shift;
    
    if ($allVariable->{csPolarity} eq '')
    {
        $allVariable->{csRB_P}->configure(-background=>'#ede9e3');
        $allVariable->{csRB_N}->configure(-background=>'#9f75ff');  #ede9e3    
    } else {
        $allVariable->{csRB_P}->configure(-background=>'#9f75ff');
        $allVariable->{csRB_N}->configure(-background=>'#ede9e3');  #ede9e3    
    }
}

sub ssLayerSelection
{
    my $allVariable = shift;
    
    if ($allVariable->{ssPolarity} eq '')
    {
        $allVariable->{ssRB_P}->configure(-background=>'#ede9e3');
        $allVariable->{ssRB_N}->configure(-background=>'#9f75ff');  #ede9e3    
    } else {
        $allVariable->{ssRB_P}->configure(-background=>'#9f75ff');
        $allVariable->{ssRB_N}->configure(-background=>'#ede9e3');  #ede9e3    
    }
}

sub outerType
{
    my $allVariable = shift;
    
    print "$allVariable->{outerType}\n";
    
    if ($allVariable->{outerType} eq 'positive' )
    {
	$allVariable->{rb_OuterType_P}->configure(-background=>'#9f75ff');  #ede9e3
	$allVariable->{rb_OuterType_N}->configure(-background=>'#ede9e3');  #ede9e3
    }
    else
    {
	$allVariable->{rb_OuterType_N}->configure(-background=>'#9f75ff');  #ede9e3
	$allVariable->{rb_OuterType_P}->configure(-background=>'#ede9e3');  #ede9e3
    }
    
}
