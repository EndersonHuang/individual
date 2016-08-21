#!/usr/bin/perl -w
###### Add CEL130 bonding symbols to inner layers and pretect layers
###### write by hyp , 20160604 
use strict;
use Tk;
use utf8;
use warnings;
#use lib qw(/genesis/e102/all/perl);
#use Genesis;
#my $host = shift;
#our $f = new Genesis($host);
#our $JOB = $ENV{JOB};
#our $STEP = $ENV{STEP};
## main ##
#   #85b828
#my $innerLayerTmp = &pickOutInnerLayer();
&bondingMainWindow();

exit 0;

## main end ##



sub startGenesis
{
    my $oz1 = shift;
    my $oz2 = shift;
    my $oz3 = shift;
    my $_aoiMove = shift;
    my $boardTypeValue = shift;
    my $bonding_1oz = shift;
    my $bonding_2oz = shift;
    my $bonding_3oz = shift;
    my $innerLayerTmp = shift;
    my @innerLayer = @$innerLayerTmp;
    our $mw;
    our $exiterValue;
    my @_1ozLayer  = @$oz1;
    my @_2ozLayer  = @$oz2;
    my @_3ozLayer  = @$oz3;
    
    if ($_1ozLayer[0] eq 'hozNo')
    {
        @_1ozLayer = ();
    }
    if ($_2ozLayer[0] eq '_2ozNo')
    {
        @_2ozLayer = ();
    }
    if ($_3ozLayer[0] eq '_3ozNo')
    {
        @_3ozLayer = ();
    }
    
    #$f->PAUSE("lsValue1 = @_1ozLayer");
    #$f->PAUSE("lsValue2 = @_2ozLayer");
    #$f->PAUSE("lsValue3 = @_3ozLayer");
    #$f->PAUSE("_aoiMove = $_aoiMove");
    #$f->PAUSE("boardTypeValue = $boardTypeValue");    
    
    open(FILE,">/home/genesis/selectValueFromWindow.txt");
    printf FILE "set bonding_1oz = $bonding_1oz\n";
    printf FILE "set bonding_2oz = $bonding_2oz\n";
    printf FILE "set bonding_3oz = $bonding_3oz\n";
    printf FILE "set lyr_1oz = \(@_1ozLayer\)\n";
    printf FILE "set lyr_2oz = \(@_2ozLayer\)\n";
    printf FILE "set lyr_3oz = \(@_3ozLayer\)\n";
    printf FILE "set aoi_move_sel = $_aoiMove\n";
    printf FILE "set boardType = $boardTypeValue\n";
    printf FILE "set exiterValue = \'continue\'\n";    
    printf FILE "set innerLayer = \(@innerLayer\)\n";
    close FILE;
    
    $mw -> destroy;
    exit;
}

sub bondingMainWindow
{
    our $exiterValue = 'no';
    my $_tmpValue = shift;
    my @innerLayer = @$_tmpValue;
    our $JOB = '123';    
    #$f->COM("get_user_name");
    my $userName = 'hyp';
    
    
    our $mw = new MainWindow(-title,"New Bonding Script");
    #our $mw = new MainWindow(-title,"添加bonding脚本");
    $mw -> geometry("400x900+550+20");
    my $multekLogo = $mw-> Photo(-file=>"/genesis/sys/scripts/hyp/perl_file/One_Color.GIF");
    $mw -> Label ( -relief=>'flat', -background=>'white', -justify=>'center' ,-image=>$multekLogo) -> pack(-anchor=>'center', -fill=>'x');
    
    my $frame1 = $mw->Frame->pack();
    $frame1->Label(-text=>'料号名称:',-anchor=>'w',-font=>[-size=>15])->pack(-expand=>1,-side=>'left',-pady=>10,-fill=>'x');
    $frame1->Entry(-textvariable=>$JOB,-font=>[-size=>15],-width=>'15')->pack(-expand=>1,-pady=>5,-side=>'left',-fill=>'x');
    $frame1->Label(-text=>'工程师:',-font=>[-size=>15])->pack(-expand=>1,-side=>'left',-pady=>10,-fill=>'x');
    $frame1->Entry(-textvariable=>$userName,-font=>[-size=>15],-width=>'15')->pack(-expand=>1,-pady=>5,-side=>'left',-fill=>'x');
    
    my $frame2 = $mw->Frame->pack(-fill=>'x');
    $frame2->Label(-text=>'添加Hoz or 1oz bonding？',-anchor=>'w',-font=>[-size=>15],)->pack(-expand=>1,-side=>'left',-pady=>0,-fill=>'x');
    our $hozValue;
    $frame2->Radiobutton(-text,'是',-height=>2,-variable=>\$hozValue,-command=>\&list1)->pack(-side=>"left",-fill=>'x');
    $frame2->Radiobutton(-text,'否',-height=>2,,-value=>'hozN',-variable=>\$hozValue,-command=>\&list1)->pack(-side=>"left");
    
    my $frame3 = $mw->Frame->pack(-fill=>'x');
    $frame3->Label(-text=>'选择层:',-anchor=>'w',-font=>[-size=>15])->pack(-expand=>1,-side=>'left',-fill=>'x');
    our $selectValue;
    our $allSelection = $frame3->Radiobutton(-text,'全部层',-height=>2,-variable=>\$selectValue,-command=>\&hozSelection)->pack(-side=>"left");
    our $manualSelection = $frame3->Radiobutton(-text,'手动选择',-height=>2,-value=>'selectManual',-variable=>\$selectValue,-command=>\&hozSelection)->pack(-side=>"left");
    
    my $frame4 = $mw->Frame->pack(-fill=>'both');
    our $lb_bk1 = $frame4->Scrolled('Listbox',-relief=>'sunken', -background=>'#fec038', -selectmode=>'multiple', -font=>'charter 11 normal', -height=>7, -selectbackground=>'#00009a', -scrollbars=>'se', -selectforeground=>'White',-exportselection=>0) -> pack(-anchor=>'se', -fill=>'both', -expand=>1,-side=>'left',-fill=>'both');
    $lb_bk1->insert(0,@innerLayer);
    $lb_bk1->configure(-state=>'disable');
    
    my $frame5 = $mw->Frame->pack(-fill=>'x');
    $frame5->Label(-text=>'添加2oz bonding？',-anchor=>'w',-font=>[-size=>15],)->pack(-expand=>1,-side=>'left',-pady=>2,-fill=>'x');
    our $secondozValue;
    $frame5->Radiobutton(-text,'是',-height=>2,-value=>'threeozN',-variable=>\$secondozValue,-command=>\&list2)->pack(-side=>"left");
    $frame5->Radiobutton(-text,'否',-height=>2,-variable=>\$secondozValue,-command=>\&list2)->pack(-side=>"left");
    my $lb_frame2 = $mw->Frame->pack(-fill=>'both');
    our $lb_bk2 = $lb_frame2->Scrolled('Listbox',-relief=>'sunken', -background=>'#fec038', -selectmode=>'multiple', -font=>'charter 11 normal', -height=>7, -selectbackground=>'#00009a', -scrollbars=>'se', -selectforeground=>'White',-exportselection=>0) -> pack(-anchor=>'se', -fill=>'both', -expand=>1,-side=>'left',-fill=>'both');
    $lb_bk2->insert(0,@innerLayer);
    $lb_bk2->configure(-state=>'disable');

    my $frame6 = $mw->Frame->pack(-fill=>'x');
    $frame6->Label(-text=>'添加3oz bonding？',-anchor=>'w',-font=>[-size=>15])->pack(-expand=>1,-side=>'left',-pady=>2,-fill=>'x');
    our $threeozValue;
    $frame6->Radiobutton(-text,'是',-height=>2,-value=>'threeozN',-variable=>\$threeozValue,-command=>\&list3)->pack(-side=>"left");
    $frame6->Radiobutton(-text,'否',-height=>2,-variable=>\$threeozValue,-command=>\&list3)->pack(-side=>"left");
    my $lb_frame3 = $mw->Frame->pack(-fill=>'both');
    our $lb_bk3 = $lb_frame3->Scrolled('Listbox',-relief=>'sunken', -background=>'#fec038', -selectmode=>'multiple', -font=>'charter 11 normal', -height=>7, -selectbackground=>'#00009a', -scrollbars=>'se', -selectforeground=>'White',-exportselection=>0) -> pack(-anchor=>'se', -fill=>'both', -expand=>1,-side=>'left');
    $lb_bk3->insert(0,@innerLayer);
    $lb_bk3->configure(-state=>'disable');
    
    my $frame9 = $mw->Frame->pack(-fill=>'x');
    $frame9->Label(-text=>'选择板类型：',-anchor=>'w',-font=>[-size=>15],-background=>'#a291fe',-height=>1)->pack(-expand=>1,-side=>'left',-pady=>2,-fill=>'x');
    our $boardType;
    $frame9->Radiobutton(-text,'普通类型',-height=>2,-variable=>\$boardType)->pack(-side=>"left");
    $frame9->Radiobutton(-text,'板边交货',-height=>2,,-value=>'aoiN',-variable=>\$boardType,)->pack(-side=>"left");
    
    my $frame8 = $mw->Frame->pack(-fill=>'x');
    $frame8->Label(-text=>'是否移动AOI孔？',-anchor=>'w',-font=>[-size=>15])->pack(-expand=>1,-side=>'left',-pady=>2,-fill=>'x');
    our $aoiMoveValue;
    $frame8->Radiobutton(-text,'是',-height=>2,-variable=>\$aoiMoveValue)->pack(-side=>"left");
    $frame8->Radiobutton(-text,'否',-height=>2,,-value=>'aoiN',-variable=>\$aoiMoveValue)->pack(-side=>"left");
    
    my $frame7 = $mw->Frame->pack(-side=>'bottom');
    $frame7->Button(-text,'继续',-font=>[-size=>15],-width=>'15',-height=>'2',-activebackground=>'green',-command=>sub{&continueAction(@innerLayer)})->pack(-side=>"left",-padx=>"20",-pady=>"10");
    $frame7->Button(-text,'退出',-font=>[-size=>15],-width=>'15',-height=>'2',-command=>\&exiter,-state=>'normal',-activebackground=>'red')->pack(-side=>"left",-padx=>"20",-pady=>"10");
    MainLoop;
}

sub exiter
{
    our $mw;
    my $exiterValue = 'exit';

    open(FILE,">/home/genesis/selectValueFromWindow.txt");
    printf FILE  "set exiterValue = $exiterValue\n";
    
    $mw->destroy;
    exit;
}
sub list3
{
    our $threeozValue;
    our $lb_bk3;
    if ( $threeozValue eq '' )  # 3oz no
    {
        $lb_bk3->configure(-state=>'disable');
    }
    else    # 3oz yes
    {
        $lb_bk3->configure(-state=>'normal');
    }
}

sub list2
{
    our $secondozValue;
    our $lb_bk2;
    if ( $secondozValue eq '' ) # 2oz no
    {
        $lb_bk2->configure(-state=>'disable');
    }
    else    # 2oz yes
    {
        $lb_bk2->configure(-state=>'normal');
    }
}


sub list1
{
    our $hozValue;
    our $lb_bk1;
    our $allSelection;
    our $manualSelection;
    our $selectValue;
    
    if ( $hozValue eq '' )  # hoz or 1oz yes
    {
        print "\$selectValue = \'undefined\' \n" if ( ! defined($selectValue) );
        print "\$selectValue = \'bare\' \n" if ( $selectValue eq '' );
        
        $allSelection->configure(-state=>'normal');
        $manualSelection->configure(-state=>'normal');
        $lb_bk1->configure(-state=>'normal');
        if ( $selectValue eq '' )
        {
            $lb_bk1->configure(-state=>'disable');
        }
                

    }
    else    # hoz or 1oz no
    {
        $allSelection->configure(-state=>'disable');
        $manualSelection->configure(-state=>'disable');
        $lb_bk1->configure(-state=>'disable');
    }
}

sub hozSelection
{
    our $selectValue;
    our $lb_bk1;
    our $hozValue;
  
    if ( $selectValue eq '' )   # select type of hoz or 1oz , all
    {
        $lb_bk1->configure(-state=>'disable');
    }
    else    # select type of hoz or 1oz , manual
    {
        $lb_bk1->configure(-state=>'normal');
    }
    
    if ( $hozValue ne '' )  # while hoz or 1oz selection is no , disable hoz or 1oz listbox
    {
        $lb_bk1->configure(-state=>'disable');
    }
}

sub continueAction
{
    our $f;
    my (@innerLayer) = (@_);
    #our @innerLayer;
    our $lb_bk1;
    our $lb_bk2;
    our $lb_bk3;
    our $hozValue;
    our $secondozValue;
    our $threeozValue;
    my @lsValue1 = ();
    my @lsValue2 = ();
    my @lsValue3 = ();
    our $mw;
    our $selectValue;   
    my $statusValue;
    my $continueStatus;
    my $bonding_1oz;
    my $bonding_2oz;
    my $bonding_3oz;
    
    if ($hozValue ne '' && $secondozValue eq '' && $threeozValue eq '')
    {
        $mw -> destroy;
        open(FILE,">/home/genesis/selectValueFromWindow.txt");
        printf FILE "set exiterValue = \'exit\'\n";    
        exit;
    }
    
    $mw -> withdraw;
    
    if ($hozValue ne '')
    {
        $bonding_1oz = '2';
        @lsValue1 = ('hozNo');
    }
    else
    {
        $bonding_1oz = '1';
        if ($selectValue eq '' )
        {
            @lsValue1 = @innerLayer;
            #$continueStatus = 'continue';
        }
        else
        {
            if ( ! $lb_bk1 -> curselection ) 
            { 
                $mw->messageBox(-icon=>'error',-type=>'OK',-title=>'GUI',-message=>'Hoz or 1oz 选项未选层,请重新选择！');
                $mw->raise;
                $statusValue = 'noSelect';
                goto returnMainwindow;
            }
        
            my @lbIndex1 = $lb_bk1 -> curselection;
            foreach (@lbIndex1)
            {
                my $tmpValue =  $lb_bk1 -> get ( $_ );
                push (@lsValue1,$tmpValue);
            }
        }
    }
    
    if ($secondozValue eq '')
    {
        $bonding_2oz = '1';
        @lsValue2 = ('_2ozNo');
    }
    else
    {
        $bonding_2oz = '2';
        if ( ! $lb_bk2 -> curselection ) 
        { 
            $mw->messageBox(-icon=>'error',-type=>'OK',-title=>'GUI',-message=>'2oz 选项未选层,请重新选择！');
            $mw->raise;
            $statusValue = 'noSelect';
            goto returnMainwindow;
        }
        else
        {
            my @lbIndex2 = $lb_bk2 -> curselection;
            foreach (@lbIndex2)
            {
                my $tmpValue =  $lb_bk2 -> get ( $_ );
                push (@lsValue2,$tmpValue);
            }
        }
    }
    
    if ($threeozValue eq '')
    {
        $bonding_3oz = '1';
        @lsValue3 = ('_3ozNo');
    }
    else
    {
        $bonding_3oz = '2';
        if ( ! $lb_bk3 -> curselection ) 
        { 
            $mw->messageBox(-icon=>'error',-type=>'OK',-title=>'GUI',-message=>'3oz 选项未选层,请重新选择！');
            $mw->raise;
            $statusValue = 'noSelect';
            
        }
        else
        {
            my @lbIndex3 = $lb_bk3 -> curselection;
            foreach (@lbIndex3)
            {
                my $tmpValue =  $lb_bk3 -> get ( $_ );
                push (@lsValue3,$tmpValue);
            }
        }
    }
    
    if ($statusValue eq 'noSelect')
    {
        $mw->deiconify;
        $mw->raise;
        #$continueStatus = 'backToWindow';
    }
    else
    {
        outer : foreach my $tmpValue1 (@lsValue1)
        {
            foreach my $tmpValue2 (@lsValue2)
            {
                foreach my $tmpValue3 (@lsValue3)
                {
                    if ( $tmpValue1 eq $tmpValue2 || $tmpValue1 eq $tmpValue3 || $tmpValue2 eq $tmpValue3 )
                    {
                        $mw->messageBox(-icon=>'error',-type=>'OK',-title=>'GUI',-message=>'选择了相同层,请重新选择！');
                        $continueStatus = 'backToWindow';
                        last outer;
                    }
                    else
                    {
                        $continueStatus = 'continue';
                    }
                }
            }
        }
    }

    our $aoiMoveValue;
    my $tmpAoi;
    if ($aoiMoveValue eq '')
    {
        $tmpAoi = '1';
    }
    else
    {
        $tmpAoi = '2';
    }    
    
    our $boardType;
    my $tmpBoard;
    if ($boardType eq '')
    {
        $tmpBoard = '1';
    }
    else
    {
        $tmpBoard = '2';
    }
    
    if ($continueStatus eq 'continue')
    {
        #printf "\@lsValue1 = \'@lsValue1\' \n";
        #printf "\@lsValue2 = \'@lsValue2\' \n";
        #printf "\@lsValue3 = \'@lsValue3\' \n";
        
        my $lsValue1 = \@lsValue1;
        my $lsValue2 = \@lsValue2;
        my $lsValue3 = \@lsValue3;
        my $innerRef = \@innerLayer;
        &startGenesis($lsValue1,$lsValue2,$lsValue3,$tmpAoi,$tmpBoard,$bonding_1oz,$bonding_2oz,$bonding_3oz,$innerRef);
    }
    else
    {
        returnMainwindow:
        $mw->deiconify;
        $mw->raise;
    }
}

sub initializeOfBegin
{
    our $STEP;
    our $JOB;
    my ( $unitValue ) = ( @_ );
    if ( not defined($unitValue) )
    {
            $unitValue = 'mm';
    }
    
    #$f->PAUSE("unitValue = $unitValue , STEP = $STEP");
    $f->COM("open_entity,job=$JOB,type=step,name=$STEP,iconic=no");
    my $group = $f->{COMANS};
    $f->AUX("set_group,group=$group");
    $f->COM("filter_reset,filter_name=popup");
    $f->COM("affected_layer, name = , mode = all, affected = no");
    $f->COM("clear_layers");
    
    $f->COM("get_units");
    our $workUnit = ($f->{COMANS});
    $f->COM("units,type=$unitValue");
}

sub initializeOfEnd
{
        our $workUnit;
        $f->COM("filter_reset,filter_name=popup");
        $f->COM("affected_layer, name = , mode = all, affected = no");
        $f->COM("clear_layers");
        $f->COM("units,type=$workUnit");
}

sub setUnit
{
        my ( $unitValue ) = ( @_ );
        if ( not defined($unitValue) )
        {
                $unitValue = 'mm';
        }
        #$f->PAUSE("unitValue = $unitValue");
        $f->COM("units,type=$unitValue");
}

sub createFilter
{	
        my ( $includeSymbol , $excludeSymbol ) = ( @_ );
        $f->COM("filter_reset,filter_name=popup");
        $f->COM("filter_area_end,layer=,filter_name=popup,operation=unselect,area_type=none,inside_area=no,intersect_area=no");
        if ( defined($includeSymbol) ) 
        {
        if ( $includeSymbol =~ /all/)
                    {
                 #while parameter is 'all', select all features including surface              
                    }
                 else
                 {
         $f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=$includeSymbol");
                    }
                }
        
        if ( defined($excludeSymbol) ) 
        {
            $f->COM("filter_set,filter_name=popup,update_popup=no,exclude_syms=$excludeSymbol");  
        }
        
        $f->COM("filter_area_strt");
        $f->COM("filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no");
        $f->COM("filter_reset,filter_name=popup");
}

sub createLayer
{
	my ($layerName,$context,$type,$polarity) = (@_);
	
	if ( not defined($layerName) or $layerName eq '' )
	{
		$layerName = 'unnamed_tmp';
		$f->VOF;
		$f->COM("delete_layer,layer=unnamed_tmp");
		$f->VON;
	}

	if ( not defined($context) or $context eq '' )
	{
		$context = 'misc';
	}

	if ( not defined($type) or $type eq '' )
	{
		$type = 'signal';
	}

	if ( not defined($polarity) or $polarity eq '' )
	{
		$polarity = 'positive';
	}

	$f->VOF;
	$f->COM("create_layer,layer=$layerName,context=$context,type=$type,polarity=$polarity,ins_layer=");
	$f->VON;
}

sub deleteLayer
{
	for (@_)
	{
		$f->VOF;
		$f->COM("delete_layer,layer=$_");
		$f->VON;
	}
}

sub doInfoLimit
{
        our ( $unitValue , $stepName ) = ( @_ );

        if ( not defined($stepName) )
        {
                $stepName = $STEP ;      
        }
        
        if ( not defined($unitValue) )
        {
                $unitValue = 'mm';
        }
        
        $f->INFO(units => $unitValue, entity_type => 'step',
         entity_path => "$JOB/$stepName",
         data_type => 'PROF_LIMITS');

        $f->INFO(units => $unitValue, entity_type => 'step',
         entity_path => "$JOB/$stepName",
         data_type => 'SR_LIMITS');

        $f->INFO(units => $unitValue, entity_type => 'step',
         entity_path => "$JOB/$stepName",
         data_type => 'ACTIVE_AREA');        
        
        our $gPROF_LIMITSxmin = $f->{doinfo}{gPROF_LIMITSxmin};
        our $gPROF_LIMITSxmax = $f->{doinfo}{gPROF_LIMITSxmax};
        our $gPROF_LIMITSymin = $f->{doinfo}{gPROF_LIMITSymin};
        our $gPROF_LIMITSymax = $f->{doinfo}{gPROF_LIMITSymax};
        
        our $gSR_LIMITSxmin = $f->{doinfo}{gSR_LIMITSxmin};
        our $gSR_LIMITSxmax = $f->{doinfo}{gSR_LIMITSxmax};
        our $gSR_LIMITSymin = $f->{doinfo}{gSR_LIMITSymin};
        our $gSR_LIMITSymax = $f->{doinfo}{gSR_LIMITSymax};
         
        our $gACTIVE_AREAxmin = $f->{doinfo}{gACTIVE_AREAxmin};
        our $gACTIVE_AREAxmax = $f->{doinfo}{gACTIVE_AREAxmax};
        our $gACTIVE_AREAymin = $f->{doinfo}{gACTIVE_AREAymin};
        our $gACTIVE_AREAymax = $f->{doinfo}{gACTIVE_AREAymax};
        
        #for ( ($gPROF_LIMITSxmin,$gPROF_LIMITSxmax,$gPROF_LIMITSymin,$gPROF_LIMITSymax) )
        #{
        #        $f->PAUSE("$_");
        #}
}

