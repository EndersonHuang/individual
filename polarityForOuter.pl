#!/usr/bin/perl -w
use strict;
use utf8;
use Tk;

my $promptMW = new MainWindow(-title,"LDI Auto Output -version 1.0 2016-06-07");
$promptMW -> geometry("+450+200");

my $frame = $promptMW->Frame->pack(-expand=>1,-fill=>'x',-side=>'top');
$frame -> Label ( -text=>'添加CEL邦定（融合块）', -height=>1,-background=>'white', -justify=>'center',-anchor=>'center',-font=>[-size=>18]) -> pack(-expand=>1,-anchor=>'center',-fill=>'x',-side=>'top');
$frame -> Label ( -text=>'请选择外层的极性：', -font=>[-size=>15],-background=>'yellow', -justify=>'center',-anchor=>'w') -> pack(-anchor=>'w', -pady=>10,-fill=>'x');
my $rogerLabel = $frame -> Label ( -text=>'1、Roger pp 材料',-relief=>'flat', -background=>'white',-font=>[-size=>15], -justify=>'center',-anchor=>'w') -> pack(-anchor=>'w', -fill=>'x');
$frame -> Label ( -text=>'2、Core厚大于30mil',-relief=>'flat', -background=>'white', -font=>[-size=>15],-justify=>'center',-anchor=>'w') -> pack(-anchor=>'w', -fill=>'x');
$frame -> Label ( -text=>'3、假Core大于30mil',-relief=>'flat', -background=>'white', -font=>[-size=>15],-justify=>'center',-anchor=>'w') -> pack(-anchor=>'w', -fill=>'x');
$frame -> Label ( -text=>'4、2次压板',-relief=>'flat', -background=>'white', -font=>[-size=>15],-justify=>'center',-anchor=>'w') -> pack(-expand=>1,-anchor=>'w', -fill=>'x');

my $frame1 = $promptMW->Frame->pack(-side=>'bottom');
$frame1->Button(-text,'继续',-font=>[-size=>10],-width=>'10',-height=>'2',-activebackground=>'green',-command=>\&promptAction)->pack(-side=>"left",-padx=>"50",-pady=>"5");
$frame1->Button(-text,'退出',-font=>[-size=>10],-width=>'10',-height=>'2',-command=>\&exiter,-state=>'normal',-activebackground=>'red')->pack(-side=>"left",-padx=>"50",-pady=>"5");
    
MainLoop;

sub promptAction
{
    open(PROMPT,">/home/genesis/promptStatus.txt");
    printf PROMPT "set promptStatus = \'continue\'\n";
    
    close PROMPT;
    $promptMW -> destroy;
    exit;    
}

sub exiter
{
    open(PROMPT,">/home/genesis/promptStatus.txt");
    printf PROMPT "set promptStatus = \'exit\'\n";
    close PROMPT;
    $promptMW -> destroy;
    exit;
}






