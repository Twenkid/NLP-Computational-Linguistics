#!/usr/bin/perl
# A small program to read the contents
# of a directory and print them to screen
# Author: Todor Arnaudov, 2007
# Experimental Code

use English;

#@dir_contents;
#$dir_to_open="/home/sant/dcs/Teaching/Internet_Systems/Lectures";
#$dir="c:\\";

# open file with handle DIR

 opendir(DIR,$dir_to_open);#|| die("Cannot open directory !\n");

# Get contents of directory

 @dir_contents= readdir(DIR);

# Close the directory

 closedir(DIR);



# Now loop through array and print file names

foreach $file (@dir_contents)
 {
   if(!(($file eq ".") || ($file eq "..")))
    {
      print "$file \n";
    }
 }
 

 sub readWinDir()
 { 
  $windir = $ENV{"WINDIR"};
  opendir(NT, $windir) || die "no $windir?: $!";
  while ($name = readdir(NT)) 
     { # scalar context, one per loop
        print "$name\n"; # prints ., .., system.ini, and so on
        closedir(NT);
        }
   }


#And here's a way of getting them all in alphabetical order with the assistance #of sort:

  sub readWinDirSort()
  { 
$windir = $ENV{"WINDIR"};
opendir(NT, $windir) || die "no $windir?: $!";
foreach $name (sort readdir(NT))
   { # list context, sorted
        print "$name\n"; # prints ., .., system.ini, and so on
    }
closedir(NT);
  }
  
  
  


  sub readDir($)
  { 
   $dir = $_[0];      
  #$windir = $ENV{"WINDIR"};
  opendir(DIR, $dir) || die "no $dir?: $!";
   foreach $name (sort readdir(DIR))
   { # list context, sorted
        print "$name\n"; # prints ., .., system.ini, and so on        
    }
closedir(NT);
  }
  
  
  
  my $totalTexts = 0;
  my @Counts = 0;
  my @CountsOfCounts = 0;
  
  my $maxInstances = 0;
  my $minInstances = 100000;
  my $maxInstancesName;
  my $minInstancesName;
  
  my $topUnits = 0;
     
  my %Units = 0;
  my @UnitsNames = 0;
  
  my %Unitsi = ("mm", 1,                     
                      "nmol", 2,
                      "mmol", 3,
                      "g", 4,
                      "cm", 5                       
                      );
         
                                                         
  sub openFile($)
  {
   #$instancesAtStart = $totalInstances;
  my %UnitsPerFile = 0;
  my $topUnitsPerFile = 0;
  my @UnitNamesPerFile = 0;
  my @CountsPerFile = 0;
  my $instancesPerFile = 0;
  
  for($i=0; $i<5000; $i++)
  {
    $CountsPerFile[$i] = 0;
    }
     
   my $subTotalInstances = 0;
   my $instances = 0;
   my $subtotalTexts = 0;
    
    print "\nOPEN: $_[0]"; 
    open(FI, "<",$_[0]);   
    @lines = <FI>;		# Read it into an array
    close(FI);		         # Close the file
    
    #foreach $line(@lines)
    #$len = length($lines);
    $len = @lines;
    print "\n\nLLLLLLL = $len\n\n";
    #$fed = <STDIN>;
    goto NOE;    
    foreach $a(@lines)
    {
     print $a;
    }
    
    NOE:
    
    print "\nLines: $len";
    $i = 0;
    
    #for(;;)
    #{
    while( $i<=$len)
    {
    NEXT:
     #print "\n----- $i, $len -------\n";
     #$fed = <STDIN>;
    #  print $line[$i].", ".$i;      
      #else
      #$now = chop($lines[$i]);
      $now = $lines[$i];      
      chomp($now);
      $now =~s/(.*)\s+$/$1/g;            
      
      #chomp
      
     # print "\n$i ======$now=========, $len";
      #$pp = <STDIN>;
      
      #$len = length($now);
      #print "\n>>$now<<";
      #if (length($lines[$i])<1) {$i++; next;}
                  
      #goto SKIPIF;
                              
      #if ($now eq 'END')
      if ( ($now eq '!!!') || ($now eq ''))
      {   
       #print "\nTADAAA!!!, $i";
       #print "\n$minInstances";
       #$ff=<STDIN>;
       $i++;   
       if ($instances < $minInstances) 
        {
         $minInstances = $instances; 
         #print "\n$minInstances"; $ff=<STDIN>; 
         $minInstancesName = $file; 
        }
       if ($instances > $maxInstances) {$maxInstances = $instances; $maxInstancesName = $file;}       
       
       #$g = <STDIN>;
       next;
      }
      
      if ($now eq '###')
      #if ($now=~m/#/g)
         {
         # print "\nTADAAA!!!, $i";
         # $aa = <STDIN>;
        # print "\n IF END , $len";
          #print "###";          
          #$file = chop($lines[$i+1]);                    
          
          $file = $lines[$i+1];
          $totalTexts++;          
          $subTotalInstances+=$instancesPerFile;
          $subTotalTexts++;
          print "\n$subTotalIntances";
          #$fdd = <STDIN>;
          $instances = 0;                    
                    
          print "\nFILE: $file";
         # $pp = <STDIN>;  
          $i+=2;
          next;
          #goto NEXT;
          #next;
         # print "\n----- $i, $len -------\n";
          #next;                    
         }        
                           
     #if ($len>30) {$i++; next;}
     SKIPIF:
     if ($Units{$now} == 0) # haven't seen that unit
        {            
      #  print "\n IF UNITS == 0 , $len";
         $topUnits++;
         $Units{ $now } = $topUnits;
         $Counts[$topUnits]=1;
         $UnitNames[$topUnits] = $now;           
         #$topUnits++;
         $instances++;
        }
      elsif ($Units{$now}!=0)        
       {
        #  print "\n IF UNITS > 0 , $len";
    #     print "\n$now -- $Units{$now}!!!! -- $i, $topUnits, $line[$i]";
        
       # $fed = <STDIN>;
        $Counts[$Units{$now}]++;
        $instances++;                
        
      #  $CountsPerFile[$topUnitsPerFile]++;
        #print "\nADDED! >>>$now<<<, $topUnits, $Counts[$Units{$now}]";
        #$aa = <STDIN>;                   
       }
       
      if ($UnitsPerFile{$now} == 0)              
         {          
          
         # if ($now eq "yrs1") {$gg = <STDIN>;}
          $topUnitsPerFile++;          
          $UnitsPerFile{$now} = $topUnitsPerFile;
          $CountsPerFile[$topUnitsPerFile]=1;
          $UnitNamesPerFile[$topUnitsPerFile] = $now;
          print "\n$now, $topUnitsPerFile, $CountsPerFile[$topUnitsPerFile], $UnitNamesPerFile[$topUnitsPerFile] ";                   
          $instancesPerFile++;
          #$topUnitsPerFile++;
          }
          elsif ($UnitsPerFile{$now} != 0)
      { 
       $CountsPerFile[$UnitsPerFile{$now}]++;
       $instancesPerFile++;       
      }              
      #elsif ($line[$i] eq)
    #  print "\n AFTER $i, $len";
      $i++;
    #  print "\n AFTERAFTER??? $i, $len";               
    }
          
     print "\nUnits: $topUnits\n";
     
     #$Diff = $totalInstances - $instancesAtStart;
     #if ($intances < $minInstances) {$minInstances = $intances; $maxInstancesName = }
     #elsif ($intances > $maxInstances) {$maxInstances = $intances;}
          
     #return ($i - 1);
     
     
     
     
     $fN = "Per-file".$_[0].".txt";
      open(FOFILE, ">", $fN);      
     
     
      $i2 = 0;
  		$j2 = 0;  		  		
  		#$step2 = $size2/2;
  		$temp2 = 0;
  		$tempRedirect = 0;
  		#$MinEl = 0;
  		
  		  		#goto SHELL;
  		#print "\ntempREDIRECT?";
  		
  		@Redirect = 0;
  		$size2 = $topUnitsPerFile;
  		
  		#goto SKIP;
  		
  		for($i2=0;$i2<$size2; $i2++)
  		{
  		 $Redirect[$i2] = $i2;
      }
      
       $SortDirection = -1; #Descending
       
  		 for($i2=0; $i2<$size2; $i2++)
  		  {
  		   #$MinEl = $Positions[$i2];
         #$MinIndex = $i2;
         $MinEl = $i2;  
            for($j2 = $i2+1; $j2<$size2; $j2++)
            { 
              if ($SortDirection==1)
                {
                if ($CountsPerFile[$Redirect[$j2]] < $CountsPerFile[$Redirect[$MinEl]]) {$MinEl = $j2;}
                }
              else
              {
                 if ($CountsPerFile[$Redirect[$j2]] > $CountsPerFile[$Redirect[$MinEl]]) {$MinEl = $j2;}
              }
                
            }
          $temp2 = $Redirect[$i2];
          $Redirect[$i2] = $Redirect[$MinEl];
          $Redirect[$MinEl] = $temp2;                                      
        }
        
        
        SKIP:
        
      #print FOFILE "Units: $size2; Instances: $subTotalInstances;  TopUnits: $topUnitsPerFile\n\n";
      print FOFILE "File: $_[0], Units: $size2; Instances: $subTotalInstances;  TopUnits: $topUnitsPerFile\n\n";
      for($i2=0; $i2<$size2; $i2++)      
      {                  
       #$Ratio = $CountsPerFile[$Redirect[$i2]]/$subTotalInstances * 100;
       if ($instancesPerFile!=0)
       { 
          $Ratio = $CountsPerFile[$Redirect[$i2]]/$instancesPerFile * 100;
        }
          else {$Ratio = 0;}
       print "\n$val"; # -> $Counts[$Units->$un]";     
       $OutLine = sprintf("%s\t%s\t%s\t%8.4f", $i2, $CountsPerFile[$Redirect[$i2]],$UnitNamesPerFile[$Redirect[$i2]],$Ratio); #; # -> $Counts[$Units->$un]";
      #$OutLine = sprintf("%s\t%s\t%s\t%8.4f", $i2, $CountsPerFile[$Redirect[$i2]],$UnitNamesPerFile[$i2],$Ratio); #; # -> $Counts[$Units->$un]";                                                                                   
     # $OutLine = sprintf("%s\t%s\t%s\t%8.4f", $i2, $CountsPerFile[$i2],$UnitNamesPerFile[$i2],$Ratio); #; # -> $Counts[$Units->$un]";
       #print FO "\n$Counts[$Redirect[$i2]]\t$UnitNames[$Redirect[$i2]]\t$Ratio"; # -> $Counts[$Units->$un]";                                            
              print FOFILE "\n$OutLine"; #$Counts[$Redirect[$i2]]\t$UnitNames[$Redirect[$i2]]\t$Ratio"; # -> $Counts[$Units->$un]";
#       print FO "\n$Counts[$Redirect[$i2]]\t$UnitNames[$Redirect[$i2]]\t$Ratio"; # -> $Counts[$Units->$un]";
      }         
          
    if ($subtotalTexts!=0)
     {
    $averageInstances = $instances/$subTotalTexts;
    }
           
    print FOFILE "\n\nTexts: $subTotalTexts\nTypes: $topUnitsPerFile\nInstances: $subTotalInstances";
        
    print FOFILE "\n\Average instances per text: $averageInstances ( Minimum: $minInstances, Maximum: $maxInstances)";
    close FOFILE;        
                 
     return $instancesPerFile; #$subTotalInstances;     
     
    
     #return $topUnits;
  }
              
              
     my $totalInstances = 0;
     
    sub readDirProcess($)
  { 
   $dir = $_[0];      
  #$windir = $ENV{"WINDIR"};
  opendir(DIR, $dir) || die "no $dir?: $!";
   foreach $name (sort readdir(DIR))
   { # list context, sorted
        print "$name\n"; # prints ., .., system.ini, and so on
       $totalInstances += openFile($name);                    
    }  
             
    closedir(DIR);
                                              
  }
  
  
    
  sub showContentOf($)
  {         
        print ("Content?");
        #my $n = $_[0];     
        #$name = "en1.pl";
        my $n = shift;  
        print "\n$n";   
        #$name="name.txt";
        #if ($name !=~ "m/en1\.pl/g")
        
        $p = ".+\.pl";
        $p = "t";
        #if ($name !=~ m/\.pl/g)         
        #if ($name !=~ m/$p/g)
        #if ($name !=~ m/\.pl/g)
       
        if ($n !=~m/e.1.pl/g)
        {
        print "\n$n DOESNT MATCH! --> $p\n";
        #$a = <STDIN>;        
        return; 
        }
        
        print "\n\n========> MATCH: $MATCH\n\n";
        $a=<STDIN>;
        
        open(FI, "<", $name);
        @lines = <FI>;         
        
        close(FI);		# Close the file
        #$text  = join('', @lines);
        foreach $line (@lines)
        {
         print "$line\n";
        }            
  }
  
  sub readDirShow($)
  { 
    $dir = $_[0];      
    #$windir = $ENV{"WINDIR"};
    opendir(DIR, $dir) || die "no $dir?: $!";
    foreach $name (sort readdir(DIR))
    { # list context, sorted
        print "$name\n"; # prints ., .., system.ini, and so on
        #if ($name=~m/\w+\.pl/g)
        # if ($name=~m/[\w\d]+ \.nxml/g)
         #if ($name=~m/[.]*\.nxml/g)
        {
        print "\n\n=====> MATCH: $MATCH\n\n <======";
        print $MATCH;                
        #$a=<STDIN>;
        #$name = '"'.$name.'"';
        print "\n=====> NAME IS: -----$name-----\n";
        $a = <STDIN>;
        #open(FI, "<", $name);
        open(FI, "<", $dir."/".$name);
        @lines = <FI>;
        close(FI);
        #$text = join('', @lines);
        #print $lines[0];         
        #close(FI);		# Close the file
        #$text  = join('', @lines);
        #print $text;
        foreach $line (@lines)
          {
         #print ("!!!!!!!!!!!!!!!!!!!!!!!!!");
         print "$line\n";
          }
            
                                   
        # $a = <STDIN>;
        }  
        
       #goto SKIP; 
       #showContentOf($name);
       #goto SKIP;
       #if ($name !=~m/([a-zA-Z]*.*)/g)
       
     #  if ($name!=~m/\w+\.p./g)
     #   {
     #   print "\n$n DOESNT MATCH! --> $p\n";
     #   #$a = <STDIN>;        
     #   next;
     #   }
                
        
        
       SKIP:;                            
    }
    closedir(DIR);
  }
  
  
  sub test($$)
	{
	my $lookfor = shift;
	my $string = shift;
	print "\n$lookfor ";
	if($string =~ m/($lookfor)/)
		{
		print " is in ";
		}
	else
		{
		print " is NOT in ";
		}
	print "$string.";
	if(defined($1))
		{
		print "      <$1>";
		}
	print "\n";
	}

goto SKIPTEST;
test("st.v.", "steve was here");
test("st.v.", "kitchen stove");
test("st.v.", "kitchen store");

# exit(0);    
    $name="en1.pl";
     $p = '.+\.pl';
        if ($name =~ m/$p/g)
        {
         print "MACTH: $MATCH - $p";
#        exit(0);
        }
        
        
     SKIPTEST:;
        #$text  = join('', @lines);
    #    foreach $line (@lines)
    #    {
     #    print "$line\n";
   
   
  open(FO, ">", "UNITS-TOTAL.txt");
    
  #  print "\nUNITS";                               
  #  foreach $un( keys %Units)                      
  #  {                                              
  #   print FO "\n$un"; # -> $Counts[$Units->$un]"; 
  #  }                                              
  #  close FO;
    
 $path = 'C:\Documents on this PC\articles.tar\BMC Bioinformatics';
  #readDirProcess("C:\\Documents on this PC\\articles.tar\\stats2");   #("c:\\documents on this pc\\perl\\perl\\bin");
  readDirProcess("C:\\Documents on this PC\\articles.tar\\logs-units");   #("c:\\documents on this pc\\perl\\perl\\bin");
    
      open(FO_NAMES, ">", "units-total-names.out");
       
      print "\nUNITS";
      
      print FO_NAMES "\n\nTexts: $totalTexts\nTypes: $topUnits\nInstances: $totalInstances";        
      print FO_NAMES "\n\Average instances per text: $averageInstances ( Minimum: $minInstances, Maximum: $maxInstances)";                                                                              
      #foreach $un( sort(keys %Units))                                                                   
      foreach $un( sort(keys %Units))
      {                  
      print "\n$un"; # -> $Counts[$Units->$un]";                                                                           
      print FO_NAMES "\n$un\t$Counts[$Units{$un}]"; # -> $Counts[$Units->$un]";                                            
      }
      close(FO_NAMES);
      
      
      	$i2 = 0;
  		$j2 = 0;  		
  		$size2 = $PositionsTop;
  		$step2 = $size2/2;
  		$temp2 = 0;
  		$tempRedirect = 0;
  		#$MinEl = 0;
  		
  		  		#goto SHELL;
  		#print "\ntempREDIRECT?";
  		
  		@Redirect = 0;
  		$size2 = $topUnits;
  		
  		for($i2=0;$i2<$size2; $i2++)
  		{
  		 $Redirect[$i2] = $i2;
      }
      
       $SortDirection = -1; #Descending
       
  		 for($i2=0; $i2<$size2; $i2++)
  		  {
  		   #$MinEl = $Positions[$i2];
         #$MinIndex = $i2;
         $MinEl = $i2;  
            for($j2 = $i2+1; $j2<$size2; $j2++)
            { 
              if ($SortDirection==1)
                {
                if ($Counts[$Redirect[$j2]] < $Counts[$Redirect[$MinEl]]) {$MinEl = $j2;}
                }
              else
              {
                 if ($Counts[$Redirect[$j2]] > $Counts[$Redirect[$MinEl]]) {$MinEl = $j2;}
              }
                
            }
          $temp2 = $Redirect[$i2];
          $Redirect[$i2] = $Redirect[$MinEl];
          $Redirect[$MinEl] = $temp2;                                      
        }
        
      print FO "\n\n";
      
          $averageInstances = $totalInstances/$totalTexts;
           
    print FO "\n\nTexts: $totalTexts\nTypes: $topUnits\nInstances: $totalInstances";
        
    print FO "\n\Average instances per text: $averageInstances ( Minimum: $minInstances, Maximum: $maxInstances)";
    
    
      #foreach $val ( sort(values %Units))
      for ($i2=0; $i2<$size2; $i2++)
      {                  
       $Ratio = $Counts[$Redirect[$i2]]/$totalInstances * 100; 
       print "\n$val"; # -> $Counts[$Units->$un]";     
       $OutLine = sprintf("%s\t%s\t%s\t%9.6f", $i2+1, $Counts[$Redirect[$i2]],$UnitNames[$Redirect[$i2]],$Ratio); #; # -> $Counts[$Units->$un]";                                                                     
       #print FO "\n$Counts[$Redirect[$i2]]\t$UnitNames[$Redirect[$i2]]\t$Ratio"; # -> $Counts[$Units->$un]";                                            
              print FO "\n$OutLine"; #$Counts[$Redirect[$i2]]\t$UnitNames[$Redirect[$i2]]\t$Ratio"; # -> $Counts[$Units->$un]";
#       print FO "\n$Counts[$Redirect[$i2]]\t$UnitNames[$Redirect[$i2]]\t$Ratio"; # -> $Counts[$Units->$un]";
      }         
          

    #print FO "\n\Average units per file: $totalInstances/$totalTexts";
                                                                                                    
    close FO;                                                                                      
    exit(0);
    #####################



 goto SKIP;
 print "$path";
       if ( open(FIN, "<", $path) )
       {
        print "ijsdfiojdsifds";
        @lines = <FIN>;
        #print $lines;
        $text = join(' ', @lines);
        print $text;
        close(FIN);
       }
       else {
              print "NOT OPEN!";
            }         
          
          #exit(0);
    
      if ( open(FIN, "<", 'z.nxml') )
       {
        print "ijsdfiojdsifds";
        @lines = <FIN>;
        #print $lines;
        $text = join(' ', @lines);
        print $text;
        close(FIN);
       }
 #      exit(0);
               
          SKIP:;     
       
 $path = 'C:\Documents on this PC\articles.tar\BMC Bioinformatics';         
#  readDirShow($path);  #Read dir and show
 readDirShow('C:\Documents on this PC\perl\perl\testbio');  #Read dir and show  
        
  #readDir("c:\\Documents on this pc\\");  #Read dir and show filenames
#  readDirShow('C:\Documents on this PC\perl\perl\bin');  #Read dir and show files' content
  
#  readDirShow('C:\Documents on this PC\perl\perl\site\lib');  #Read dir and show 
  
  
  # "BMC Bioinformatics-2-_-64605.nxml"
