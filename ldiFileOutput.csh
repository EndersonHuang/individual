 #!/bin/csh -f
### LDI output
### tranplant by B1
### update by hyp ,20160526
#set echo
set GUI_DATA = /tmp/gui_data.$$
set GUI_RESP = /tmp/gui_resp.$$
alias o 'echo \!:* >> $GUI_DATA'
alias do_gui gui "$GUI_DATA > $GUI_RESP; source $GUI_RESP; \rm $GUI_RESP $GUI_DATA"
alias o_tooling 'echo -n >! $GUI_DATA; o WIN 300 150;o FONT $TITLE_FONT;o FG 00000;o BW 1;o LABEL Genesis Automated Tooling'
alias compare 'echo "if(\!*) 1;" | bc' ; ######## alias calc 'echo "scale=0; \!:*" | bc -l'
set TITLE_FONT = "hbr18"
set NORM_FONT  = "hbr14"
set HINT_FONT  = "hbi14"
###### 脚本开头 ######
COM open_entity,job=$JOB,type=step,name=pnl,iconic=no
AUX set_group,group=$COMANS
COM get_units
set work_unit = $COMANS
if ( $work_unit == inch ) then
	COM units,type=mm
endif
COM affected_layer, name = , mode = all, affected = no
COM clear_layers
####################
DO_INFO -t matrix -e $JOB/matrix -d ROW
set std_layers = ()
set layers = ()
set stepname = ()
set i=1
while ($i <= $#gROWcontext)
 if ($gROWcontext[$i] =~ "board" && ($gROWlayer_type[$i] =~ "signal" || $gROWlayer_type[$i] =~ "power_ground" || $gROWlayer_type[$i] =~ "mixed" || $gROWlayer_type[$i] =~ "solder_paste" || $gROWname[$i] =~ *sm || $gROWname[$i] =~ *ta)  || $gROWname[$i] =~ [t,b]o[p,t][0-9] || $gROWname[$i] =~ [t,b]o[p,t]?[0-9]st || $gROWname[$i] =~ *jt?[t,b]o[p,t] || $gROWname[$i] =~ *-ldi ) then
     set std_layers = ($std_layers "$gROWname[$i]")

 endif
@ i++
end
###### 获取钻带层 drill ######
DO_INFO -t matrix -e $JOB/matrix -d ROW
DO_INFO -t matrix -e $JOB/matrix -m script -d NUM_ROWS
set drill_layer = ()
set i = 1
while ( $i <= $gNUM_ROWS )
	if ($gROWcontext[$i] == board && $gROWlayer_type[$i] == drill && ($gROWname[$i] =~ drill* || $gROWname[$i] =~ d?? || $gROWname[$i] =~ *drill)) then
	set drill_layer = ($drill_layer $gROWname[$i]) 
  endif
  @ i++
end

############################
#BACK1:
#o_tooling
#o LABEL "Select a step from the list"
#o FONT $NORM_FONT
#o LIST stepname 10 S 1
#foreach step ($gSTEPS_LIST)
#   o $step
#end
#o END
#do_gui

set stepname = 'pnl'
DO_INFO -t step -e $JOB/$stepname -d PROF_LIMITS,units=mm
set y_center = `echo "scale=6;($gPROF_LIMITSymax - $gPROF_LIMITSymin)/2" | bc -l`
set x_size = `echo "scale=6;$gPROF_LIMITSxmax - $gPROF_LIMITSxmin" | bc -l`
set y_size = `echo "scale=6;$gPROF_LIMITSymax - $gPROF_LIMITSymin" | bc -l`

#BACK2: 
#set layers = ()
#### select the layers from list
#o_tooling
#
#o LABEL "Select layers to output"
#o FONT $NORM_FONT
#o LIST layers 16 M 1
#foreach layer ($std_layers)
#o $layer
#end
#o END
#o FG 000099
#o LABEL "LDI RESOLUTION"
#o FORM
#o TEXT size_x 5 "Profile X:"
#o DTEXT size_x $x_size
#o TEXT size_y 5 "Profile Y:"
#o DTEXT size_y $y_size
#o ENDFORM
#o "RADIO orientation ORIENTATION: H 1 890000"
#o Landscape
#o Vertical
#o END
#o "RADIO ldiPlant LDI-PLANT: H 1 890000"
#o B5
#o B3
#o END
#o TEXT fileName 8 "Input File Code:" 
#o FG 00000
#o "RADIO quit Quit_Script: H 1 890000"
#o No
#o Yes
#o END
#do_gui

set layerSelectWinPath = '/genesis/sys/scripts/hyp/ldiPerl/LDIFileOutput.pl'
if ( -f $layerSelectWinPath ) then
 perl $layerSelectWinPath $x_size $y_size $std_layers
 source /tmp/soureFileForTk.txt;
 #rm /tmp/soureFileForTk;
else
 PAUSE Script is not exist,exit.
 echo ""
 exit
endif



if ($quit == 2) exit 0
#PAUSE layers = $layers
#if ($#layers == 0) then
# goto BACK2
#endif

#if ($fileName == "") then
# goto BACK2
#endif

## select outer layers' polarity
COM get_user_name
if ($COMANS == 'hyp') then
  if ( -f /genesis/sys/scripts/hyp/ldiPerl/outerLayerWindow.pl ) then
    set llllll = (cs ss)
    perl /genesis/sys/scripts/hyp/ldiPerl/outerLayerWindow.pl $llllll
  else
    PAUSE scripts is not exist.
    exit
  endif
 endif


foreach _ttt ( $layers ) 
	if ( $_ttt =~ cs || $_ttt =~ ss ) then
		set needToSelect = 1
	endif
end
set csPolarity = 111
set ssPolarity = 111
if ( $?needToSelect ) then
	o_tooling
	o LABEL "Select outer layers polarity"
	o "LABEL @/genesis/sys/scripts/hyp/xpm/polarity_query.xpm"
	o FG 000099
	foreach _tmp ( $layers ) 
		if ( $_tmp =~ cs ) then
			o "RADIO csPolarity ${_tmp}: H 1 890000"
			o Negative
			o Positive			
			o END
		endif
		if ( $_tmp =~ ss ) then			
			o "RADIO ssPolarity ${_tmp}: H 1 890000"
			o Negative
			o Positive
			o END
		endif

	end
	o FG 000000
	do_gui
endif
if ( $csPolarity == 2 ) then
	set csPolarity = positive
else if ( $csPolarity == 1 ) then
	set csPolarity = negative
endif

if ( $ssPolarity == 2 ) then
	set ssPolarity = positive
else if ( $ssPolarity == 1 ) then
	set ssPolarity = negative
endif
#PAUSE $csPolarity , $ssPolarity , --Polarity
#### select drill layer

DRILL:
set drillSelect = ()
o_tooling
o LABEL "Select Drill Layers"
o FONT $NORM_FONT
#o FORM locationType 
o LIST drillSelect 8 S 1
foreach layer ($drill_layer)
 o $layer
end
o END
#o ENDFORM

o FG 000099
o "RADIO locationType 'Location Type:' H 1 890000"
o Automark
o Laser reg
o Four coner
o Manual
o END

o FG 000099
o "RADIO exiter Quit_Script: H 1 890000"
o No
o Yes
o END

do_gui

if ( $locationType != 4 && $#drillSelect == 0 ) then
	if ( $exiter == 2 ) exit
	goto DRILL
else
	if ( $exiter == 2 ) exit
endif

if ( $locationType == 1 ) then
	set locationType = 'automamark'
else if ( $locationType == 2 ) then
	set locationType = 'lsr-reg-drill'	
else if ( $locationType == 3 ) then
	set locationType = 'four_corner_drill'
else if ( $locationType == 4 ) then
	set locationType = 'manual'
endif


set size_x = $x_size
set size_y = $y_size


### refer selected drill layer to copy related symbols
## before adding symbol , delete r0 symbols with attibute ".fiducial_name,text=300.reg or 301.reg" ##
foreach layer_tmp ($layers)
	COM display_layer,name=$layer_tmp,display=yes,number=1
	COM work_layer,name=$layer_tmp
	COM filter_reset,filter_name=popup   
	COM filter_atr_reset,filter_name=popup 
	COM filter_set,filter_name=popup,update_popup=no,include_syms=r0
	COM filter_atr_set,filter_name=popup,condition=yes,attribute=.fiducial_name,text=301.reg
	COM filter_atr_set,filter_name=popup,condition=yes,attribute=.fiducial_name,text=300.reg
	COM filter_atr_logic,filter_name=popup,logic=or
	COM filter_area_strt   
	COM filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no   
	COM get_select_count
	if ( $COMANS != 0 ) then
		COM sel_delete
	endif
end

## add $locationType symbols to $drillSelect ##
if ( $locationType != 'manual' ) then
 if ( $locationType =~ {automamark} ) then 
	 DO_INFO -t step -e $JOB/pnl -m script -d SR_LIMITS,units=mm
	 DO_INFO -t step -e $JOB/pnl -m script -d PROF_LIMITS,units=mm
	 set X_automaRectangle = ( $gSR_LIMITSxmin $gSR_LIMITSxmax  )
	 set Y_automaRectangle = ( $gPROF_LIMITSymin  $gPROF_LIMITSymax )
	 #PAUSE $X_automaRectangle , $Y_automaRectangle --rectangle
 endif
 
 VOF
	 COM create_layer,layer=tmp_hyp,context=misc,type=signal,polarity=positive,ins_layer=
 VON
 
 COM affected_layer, name = , mode = all, affected = no
 COM clear_layers
 COM display_layer,name=$drillSelect,display=yes,number=1
 COM work_layer,name=$drillSelect
 COM filter_reset,filter_name=popup  
 COM filter_atr_reset,filter_name=popup  
 
 if ( $locationType =~ {four_corner_drill} ) then
	 COM filter_atr_set,filter_name=popup,condition=yes,attribute=$locationType
	 COM filter_area_strt
	 COM filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no
 else if ( $locationType =~ {automamark} ) then
	 COM filter_atr_set,filter_name=popup,condition=yes,attribute=$locationType
	 COM filter_area_strt 
	 COM filter_area_xy,x=$X_automaRectangle[1],y=$Y_automaRectangle[1]   
	 COM filter_area_xy,x=$X_automaRectangle[2],y=$Y_automaRectangle[2]   
	 COM filter_area_end,layer=,filter_name=popup,operation=select,area_type=rectangle,inside_area=yes,intersect_area=no   
 else if ( $locationType =~ {lsr-reg-drill} ) then
	 COM filter_set,filter_name=popup,update_popup=no,include_syms=$locationType
	 COM filter_area_strt
	 COM filter_area_end,layer=,filter_name=popup,operation=select,area_type=none,inside_area=no,intersect_area=no
 endif
 
 COM get_select_count
 
 if ( $COMANS != 0 ) then	
	 COM sel_copy_other,dest=layer_name,target_layer=tmp_hyp,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none
 else
	 PAUSE No $locationType found in '$drillSelect' layer , pls check!
	 exit
 endif
 
 COM display_layer,name=tmp_hyp,display=yes,number=1  
 COM work_layer,name=tmp_hyp  
 COM sel_change_sym,symbol=r0,reset_angle=no
 
 COM cur_atr_reset
 if ( $locationType =~ {automamark,four_corner_drill} ) then
	 COM cur_atr_set,attribute=.fiducial_name,text=300.reg  
 else if ( $locationType =~ {lsr-reg-drill} ) then
	 COM cur_atr_set,attribute=.fiducial_name,text=301.reg  
 endif
 COM sel_change_atr,mode=add
 
 foreach tmpLayer ($layers)
	 COM display_layer,name=tmp_hyp,display=yes,number=1  
	 COM work_layer,name=tmp_hyp
	 COM sel_copy_other,dest=layer_name,target_layer=$tmpLayer,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none
 end 
 
 VOF
	 COM delete_layer,layer=tmp_hyp
 VON
 
 COM filter_reset,filter_name=popup  
 COM filter_atr_reset,filter_name=popup 
 COM cur_atr_reset
else
 
 VOF
	 COM create_layer,layer=tmp_hyp,context=misc,type=signal,polarity=positive,ins_layer=
 VON
 
 selectAgain:
 COM affected_layer, name = , mode = all, affected = no
 COM clear_layers
 COM filter_reset,filter_name=popup  
 COM open_entity,job=$JOB,type=step,name=pnl,iconic=no
 AUX set_group,group=$COMANS
 #if ( ! $?loopValue ) then
  PAUSE Pls select 4 symbol for adding to specified layers.
 #endif
 
#automamark,four_corner_drill,lsr-reg-drill

  COM get_work_layer
  set workLayer = $COMANS
 COM get_select_count
 if ( $COMANS == 4 ) then
    
    if ( -f /tmp/selectSymbol ) then
     rm /tmp/selectSymbol
    endif
    
    COM info, out_file=/tmp/selectSymbol, units=mm,args=  -t layer -e $JOB/pnl/$workLayer -m script -d FEATURES  \
      -o select
source /tmp/selectSymbol
#PAUSE kkk
   #set attributeStatus = '';
   #set kkk = 2
   #while ( $kkk <= 5)
     set attributePickOut = `cat /tmp/selectSymbol | sed -n 2p | sed s/\ /-/g`
     #PAUSE $attributePickOut = attributePickOut
     if ( $attributePickOut =~ *automamark* ) then
       set attributePickOut = automamark;
       #set attributeStatus = 'auto'
     else if ( $attributePickOut =~ *four_corner_drill* ) then
       set attributePickOut = four_corner_drill;
       #set attributeStatus = 'corner';
     else if ( $attributePickOut =~ *lsr-reg-drill* ) then
       set attributePickOut = lsr-reg-drill;
       #set attributeStatus = 'lsr';
     else
       PAUSE Select wrong, select again!
       goto selectAgain
     endif
   #@ kkk++
   #PAUSE $kkk kkk
   #end
   
   #PAUSE $attributePickOut attributePickOut
   
   if ( -f /tmp/selectSymbol ) then
     rm /tmp/selectSymbol
    endif
    
   
   COM sel_copy_other,dest=layer_name,target_layer=tmp_hyp,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none  
 else
  #set loopValue = 'no';
  #PAUSE Select not 4, select again.
  goto selectAgain
 endif
  
 COM display_layer,name=tmp_hyp,display=yes,number=1  
 COM work_layer,name=tmp_hyp  
 COM sel_change_sym,symbol=r0,reset_angle=no
 
 COM cur_atr_reset
 if ( $attributePickOut =~ {automamark,four_corner_drill} ) then
	 COM cur_atr_set,attribute=.fiducial_name,text=300.reg
	 #PAUSE 300
 else if ( $attributePickOut =~ {lsr-reg-drill} ) then
	 COM cur_atr_set,attribute=.fiducial_name,text=301.reg
	 #PAUSE 301
 endif
 COM sel_change_atr,mode=add
 
 foreach tmpLayer ($layers)
	 COM display_layer,name=tmp_hyp,display=yes,number=1  
	 COM work_layer,name=tmp_hyp
	 COM sel_copy_other,dest=layer_name,target_layer=$tmpLayer,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none
 end 
 
 VOF
	 COM delete_layer,layer=tmp_hyp
 VON
 
 COM filter_reset,filter_name=popup  
 COM filter_atr_reset,filter_name=popup 
 COM cur_atr_reset
 
endif

   
#PAUSE end

### set image productin parameters.
source /genesis/sys/scripts/hyp/image_production_auto_test	## update plot-Q , image_production POP
source /genesis/sys/scripts/hyp/display_plot_Q.csh	## check Plot-Q

set b3Path = /id/cme/b5tob3/ldi/$JOB-$fileName-ldi
set b5Path = /id/cme/hyp/ldi_test/b5/$JOB-$fileName-ldi
if ( ! -d $b3Path ) mkdir -p -m 777 "$b3Path"
if ( ! -d $b5Path ) mkdir -p -m 777 "$b5Path"
rm $b3Path/*
rm $b5Path/*

foreach layer ($layers)
	DO_INFO -t layer -e $JOB/$stepname/$layer -d LPD
	DO_INFO -t layer -e $JOB/$stepname/$layer -d POLARITY
        if ($layer =~ *top*) then
               set center_y = "$y_center"
        else if ($layer =~ *bot*) then 
               set center_y = 0
	else 
            set center_y =  "$y_center"
        endif
### Verify the X and Y Parameters by Sandy

### 

	COM output_layer_reset
	COM output_layer_set,layer=$layer,angle=0,mirror=no,x_scale=1,y_scale=1,comp=0,polarity=positive,setupfile=,\
    setupfiletmp=,line_units=inch,gscl_file=,step_scale=no

	COM skip_next_pre_hook

	if ( $orientation == 1 ) then		# $orientation from image_production_auto script above
		set size_1 = $size_y
		set size_2 = $size_x
	else
		set size_1 = $size_x
		set size_2 = $size_y
	endif
 
	if ( $ldiPlant == 1 ) then	## output to b5
		COM output,job=$JOB,step=$stepname,format=DP100X,dir_path=$b5Path,prefix=,suffix=,break_sr=no,break_symbols=no,break_arc=no,scale_mode=nocontrol,\
surface_mode=contour,units=inch,x_anchor=0,y_anchor=0,x_offset=0,y_offset=0,line_units=inch,\
override_online=yes,local_copy=yes,send_to_plotter=no,dp100x_lamination=0,\
dp100x_clip=0,clip_size=$size_1 $size_2,clip_orig=0.2 0.2,clip_width=$size_1,clip_height=$size_2,clip_orig_x=0.200000000,clip_orig_y=0.200000000,plotter_group=any,units_factor=0.0005,\
auto_purge=no,entry_num=5,plot_copies=1,dp100x_iserial=,imgmgr_name=,deliver_date=
	else		## output to b3
		COM output,job=$JOB,step=$stepname,format=DP100X,dir_path=$b3Path,prefix=,suffix=,break_sr=no,break_symbols=no,break_arc=no,scale_mode=nocontrol,\
surface_mode=contour,units=mm,x_anchor=0,y_anchor=0,x_offset=0,y_offset=0,line_units=inch,\
override_online=yes,local_copy=yes,send_to_plotter=no,dp100x_lamination=0,dp100x_clip=1,clip_size=$size_1 $size_2,clip_orig=5.08 5.08,clip_width=$size_1,clip_height=$size_2,clip_orig_x=5.0800000757,clip_orig_y=5.0800000757,plotter_group=any,\
units_factor=0.1,auto_purge=no,entry_num=5,plot_copies=1,dp100x_iserial=,imgmgr_name=,deliver_date=
	endif
end

###### 脚本结尾 ######
COM filter_reset,filter_name=popup 
COM filter_atr_reset,filter_name=popup
COM affected_layer, name = , mode = all, affected = no
COM clear_layers
COM units,type=$work_unit

#COM output,job=h16cs12cm1,step=pnl,format=DP100X,dir_path=/home/genesis/Desktop,prefix=,suffix=,break_sr=no,\
#break_symbols=no,break_arc=no,scale_mode=nocontrol,surface_mode=contour,units=inch,x_anchor=0,y_anchor=0,x_offset=0,\
#y_offset=0,line_units=inch,override_online=yes,local_copy=yes,send_to_plotter=no,dp100x_lamination=0,dp100x_clip=0,\
#clip_size=24 21,clip_orig=0.2 0.2,clip_width=24,clip_height=21,clip_orig_x=0.200000003,clip_orig_y=0.200000003,plotter_group=any,\
#units_factor=0.0005,auto_purge=no,entry_num=5,plot_copies=1,dp100x_iserial=,imgmgr_name=,deliver_date=

















