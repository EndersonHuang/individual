#! /usr/bin/perl -w
use strict;

my $file = 'D:\workfile\test\create_xlsx_auto.xlsx';
&excel_writer_xlsx("$file");

my $file2 = 'D:\workfile\test\create_spread_auto.xls';
&Spreadsheet_WriteExcel("$file2");

sub Spreadsheet_WriteExcel {
	use Spreadsheet::WriteExcel;
	# 鍒涘缓涓�涓柊鐨凟XCEL鏂囦欢 
	my $file = shift;
	my $workbook = Spreadsheet::WriteExcel->new("$file");
	
	# 娣诲姞涓�涓伐浣滆〃
	my $worksheet = $workbook->add_worksheet();
	
	# 鏂板缓涓�涓牱寮�
	my $format = $workbook->add_format();	# Add a format
	$format->set_bold();	#璁剧疆瀛椾綋涓虹矖浣�
	$format->set_color('red');	#璁剧疆鍗曞厓鏍煎墠鏅壊涓虹孩鑹�
	$format->set_align('center');	#璁剧疆鍗曞厓鏍煎眳涓�
	
	#浣跨敤琛屽彿鍙婂垪鍙凤紝鍚戝崟鍏冩牸鍐欏叆涓�涓牸寮忓寲鍜屾湯鏍煎紡鍖栫殑瀛楃涓�
	my $col = my $row = 0;
	$worksheet->write($row,$col,'Hi Excel!',$format);
	$worksheet->write(1,$col,'Hi Excel!');
	
	# 浣跨敤鍗曞厓鏍煎悕绉帮紙渚嬶細A1锛夛紝鍚戝崟鍏冩牸涓啓涓�涓暟瀛椼��
	$worksheet->write('A3',1.2345);
	$worksheet->write('A4','=SIN(PI()/4)');
	exit;
}
sub excel_writer_xlsx {
	use Excel::Writer::XLSX;
	# Create a new Excel workbook
	my $file = shift;
	my $workbook = Excel::Writer::XLSX->new("$file");

	# Add a worksheet
	my $worksheet = $workbook->add_worksheet();

	#  Add and define a format
	my $format = $workbook->add_format();
	$format->set_bold();
	$format->set_color( 'red' );
	$format->set_align( 'center' );

	# Write a formatted and unformatted string, row and column notation.
	my $col = my $row = 0;
	$worksheet->write( $row, $col, 'Hi Excel!', $format );
	$worksheet->write( 1, $col, 'Hi Excel!' );

	# Write a number and a formula using A1 notation
	$worksheet->write( 'A3', 1.2345 );
	$worksheet->write( 'A4', '=SIN(PI()/4)' );
}