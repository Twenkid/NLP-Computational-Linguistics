  #!/usr/bin/perl
# C:\Documents on this PC\articles.tar
# Read directory ( directory names) -> Menu -> Select Directory --> Process
# C:\Documents on this PC\articles.tar\BMC Cancer\BMC Cancer-1-_-32169.nxml  
# ml/min/100 g to 274.4 ml/min/100 g
#12.4 ml/min/100 g
# $RegEx[1] == Value
# $RegEx[2] == Unit  
# Experimental Code
# Author: Todor Arnaudov, 2007


  use English;
                       
  $Slash = '/';   
  $X = '&#x000d7;';    
  #$ccExpression = '([a-z]*)?//cm^3'; #cm^3';                                         
  $ccExpression = '(.*)/cm[\^]3'; #cm^3';
  $dlExpression = '(.*)/dl';
  $qL = 'mEq/L';
  $ql = 'mEq/l'; 
  #$ccExpression = '*'; #cm^3';
  #$ccExpression = '([a-z]*)?/cm^3'; #cm^3';
   #### POSITIONS #######
  @Positions = 0; # Array with positions of found units
  @LinesForPrinting = 0;
  @UnitsLines = 0;
  $UnitsLine = 0;
  @Redirect = 0;     # initial 0, 1, 2, 3, 4 ... --> links to the elements in the @LinesForPrinting
  $PositionsTop = 0;
  $PrintImmediately = 0;
  @Redirect = 0;
  
  $Sort = 1;
    
  ######################
  
                     
  $bFindUnknown = 0;
  $mainOutput = "mainOutput.txt";
  $formattedOut = "formattedOut.txt";  
  $defaultContextBack = 40;
  $defaultContextForward = 40;
  $defContext = 20;
  $MAX = 8;    #fields in the array of patterns
        
   # open(FO_FORMATTED, ">", $formattedOut);
             

    $defContext = 30;
    $defContextBack = $defContext;
    $defContextForward = $defContextBack;
              
   if ( (!$ARGV[0]) || ($ARGV[0] eq "d") ) 
   {
     $baseDir= "C:\\Documents on this PC\\articles.tar\\";
     $fileName = "";
   }
   else 
     {          
         $baseDir = $ARGV[0];
         print "\nBASEDIR = $baseDir\n";
         #$baseDir =~s/////aaa/g;
         $fileName = "";
     }
          
   if ( (!$ARGV[1]) || ($ARGV[1] eq "d"))
   {
     $directoryList = "showlist.txt";
   }
   else 
      {
       $directoryList = $ARGV[1];
      }
             
  if ($ARGV[2])
  {
   $defContextBack = $ARGV[2];
  }
  
  if ($ARGV[3])
  {
  $defContextForward = $ARGV[2];   
  }
        
  #print "\nYou entered: $fileName\n";

  goto SkipOldCode;
  
  open(INP_FILE, $fileName);	# Open the file
  @lines = <INP_FILE>;		# Read it into an array
  close(INP_FILE);		# Close the file
  $text  = join('', @lines);
  #$copy  = $text;
    
    $align = "align=\"center\"";
    $subst = "(<bold>|</bold>|<td>|<string>|<\/string>|<Sentences>|<\/Sentences>|<SentenceSplittedVignette>|<\/SentenceSplittedVignette>)";
    
     
  #$text=~s/(<bold>|</bold>|$align|<td>|<string>|<\/string>|<Sentences>|<\/Sentences>|<SentenceSplittedVignette>|<\/SentenceSplittedVignette>)//gi;
  
 # $text =~s/$subst//gi;
  
  
  
             
  print FO_FORMATTED "-----------------------------------------\n|Input:\t $fileName\n|Context:\t -$defContextBack +$defContextForward characters\n-----------------------------------------\n"; 
  
  SkipOldCode:;
  
  $text = "NA	0.37	%	1	<bold>0.37 <td dsjfisdjfidsjifd>	%<td align=\"center\">	</td><bold>0.37%</bold></td>";
  
   print "\nTEST: $text";
   $subst = "<bold>|</bold>|<td>|</td>|<table>|</table>|<td align=\"(left|right|center)\">|<string>|<\/string>|<Sentences>|<\/Sentences>|<SentenceSplittedVignette>|<\/SentenceSplittedVignette>";
  $text =~s/$subst//gi;
  print "\nTEST: $text";
  #exit(0);
  
  
  $sups = '<sup>\s*([-]?\d+)\s*</sup>';  
  $text ="dsdsods<sup> -8</sup>";
  $text =~s/$sups/^$1/gi;
  print "\n$text";
  #$a = <STDIN>;
  #exit(0);
  
#  $clearHtmlTags = "<bold>|</bold>|<td>|</td>|<table>|</table>|<td align=\"(left|right|center)\">|<
#  string>|<\/string>|<Sentences>|<\/Sentences>|<SentenceSplittedVignette>|<\/SentenceSplittedVignette>";


  $clearHtmlTags = "<tr>|</tr>|<italic>|</italic>|<p>|</p>|<bold>|</bold>|<td>|</td>|<table.{0,35}>|</table>|<caption>|</caption>";
  $clearHtmlTags .="|<td align=\"(left|right|center)\".{0,15}>|<string>|<\/string>|<Sentences>|<\/Sentences>|<SentenceSplittedVignette>|<\/SentenceSplittedVignette>";
  #$clearHtmlTags .="|<sup>|</sup>";
         
  #$clearHtmlTags .="|<td align=\"center|right|left\"";
  
  #$clearHtmlTags = "<tr>|</tr>|<td";
  
  #sup might be used!
  $text =~s/$clearHtmlTags/ /gi;    
  
  #$text =~s/$subst//gi;
          
  #Building two-dimensional array
  $maxPatterns = 50;
        
  for $i (1..$maxPatterns) {
    @array = " "; # == $array[0][0]
    $P[$i] = [ @array ];               
   }
          
   for($i=0;$i<$MAX;$i++)
   {  
    $P[$i][2] = $defContextBack;
    $P[$i][3] = $defContextForward;
   }   
       
   # &$PatternArray, $pattern, $description, $ContextBack, $ContextForth)
   
   $pTop = 0;
   
   sub addPattern($$$) 
   {        
    $P[$pTop][0] = $_[0];
    $P[$pTop][1] = $_[1];
    $P[$pTop][2] = $defContextBack;
    $P[$pTop][3] = $defContextForward;
    $P[$pTop][4] = $_[2];   # no tt
    $pTop++;    
   }
         
   %Conversions = ("in", 0.0254,
                     "ft", 0.3048,
                      "yd", 0.9144,
                      "lb", 0.4535924,
                      "oz",  0.02834952,
                      "cap.oz", 0.0338140227 
                      );
                     
   ############
   # CLEAR    #
   ############
   
   
   ####################
   # Mark MAB4413 pos #
   ####################
   
   pos($text) = 0;       
   $pattern = '<MedleyId>(M.*)</MedleyId>';
   $i=0;
   while ($text =~m/$pattern/g)
   {       
    push(@filePos, length($PREMATCH));
    push(@fileName, $1);    
    print "\n$filePos[$i] --> $fileName[$i]";   
    $i++;
   }
        
    push(@filePos, 99999999);
    push(@fileName, "NA");
    
         
    
    #$k=0;
    #while ( $filePos[$k] < $)
   #    while( ($filePos[$k] < $middle) ) {$k++;};
   #          $middleIndex = $k;
               
                
   $sizeFilePos = @filePos;
   $sizeFileName = @fileName;
   
    $middle = length($text)/2;
    $middleIndex = $sizeFilePos / 2;
    $middlePos = $filePos[$sizeFilePos/2];
    
   print "\n$i --> $sizeFilePos --> $sizeFileName";  
   
                    
   sub findWhichFileLinear($$)
   {
   
     return;  ### Not used for PubMedCentral!!!
     $curPos = $_[0];     
     $k = $_[1];      #current start index
     print $curPos." --- ".$k;
     #$k = 0;
          
      $k = $middleIndex;
      if ( ($filePos[$k] < $curPos) && ($filePos[$k+1] > $curPos) )
        {
         return $k;
        }
     elsif ($curPos >= $middlePos)
        {                                    
         while( ($filePos[$k] < $curPos) && ($filePos[$k+1] < $curPos) ) {$k++;};
         #print "Founddddddddddd: $k";
         return $k;         
        }
      else
      {                  
        # $k--;
         while( ($filePos[$k] > $curPos) && ($filePos[$k+1] > $curPos) ) {$k--;};
         #print "Founddddddddddd: $k";
         return $k;         
        } 
        
    }
        
    sub findWhichFile($$)
   {
     $curPos = $_[0];             
     $k = $sizeFilePos / 2;
     if ( ($filePos[$k] < $curPos) && ($filePos[$k+1] > $curPos) )
        {
         return $k;
        }      
     elsif ($filePos[$k] > $curPos) 
        {            
         $k--;
         while($filePos[$k] > $curPos) {$k--};
         return $k;         
        }
      elsif ($filePos[$k] < $curPos)
        {                  
         $k++;
         while($filePos[$k] < $curPos) {$k++};
         return $k;         
        }
    }                            
                
     
   sub findWhichFileBinary($)
   {
     $curPos = $_[0];
     #print $curPos;
     
     $k = $sizeFilePos / 2;
     $lastKBig = $k+1;
     $lastKSmall = $k-1;
     $dir = 1;
     
        
     $k = $sizeFilePos / 2;
       
    while(1)
    {            
     print "\nK = $k, $curPos, $filePos[$k], $filePos[$k+1], ";
     $a = <STDIN>;     
     #if ($lastK == $k) {return $k;}
                  
      if ( ($filePos[$k] < $curPos) && ($filePos[$k+1] > $curPos) )
        {
         return $k;
        }      
      elsif ( ($filePos[$k] > $curPos) && ($filePos[$k+1] > $curPos) ) 
        {            
         $lastKBig = $k;
         $k = $k/2 - $k%2; #($sizeFilePos - $k)/2;
        }
      elsif (($filePos[$k] < $curPos) && ($filePos[$k+1] < $curPos)) #Go left, to bigger
        {         
         print "<<<<<?";
         $lastKSmall = $k;
         $k+= ($sizeFilePos-$k)/2;
        }
    }                 
  }
  
  
  $pt = "2 ml/min";
  $pt = "2 ml/sec";
  $pat = "([mnp]?[lL]/?(hr?|min|sec))";
    
   $pt = "50 µg/ml";
  #if ($pt =~ "([mnp]?[lL]/?(hr?|min|sec))")
  if ($pt =~ "(µg/ml)")    
    { 
     print "Match!\n";
     print "$MATCH";
    }
    #exit(0);    
  #$where = 3256;
  
  $r = findWhichFileLinear($where, $currentFilesIndex);
  print "\n$where is between $filePos[$r] and $filePos[$r+1], and the name is $fileName[$r]";                       
  print "\nSearching for: $P[$i][1]\n\n";
  
  $converted = " ";
                  
   #$P[2][0] ='\[()*[0-9][0-9]*,( )*[0-9][0-9]*( )*]'; #"  | (\[( )*[0-9][0-9]*( )*\]);
   $CP[0][0] ='[\s*[0-9][0-9]*( )*[,-]?\s*[0-9][0-9]*\s*]'; #"  | (\[( )*[0-9][0-9]*( )*\]); 
   $CP[0][1] ="Chapter";
   $CP[0][2] = $defContext;
   $CP[0][3] = $defContext;
   
   $CP[1][0] ='\(?[F|f]igure\s*[0-9]?[0-9]*[a-z]?\)? |([F|f]igure\s*[1-9]?[0-9]\s)'; 
   $CP[1][1] ="Figure";
   $CP[1][2] = $defContext;
   $CP[1][3] = $defContext;
   
   $clearPatterns = 2;    

   ############
   # PATTERNS #
   ############
   
   # $MAX = 10;
      
  $pTop = 0; 
#  addPattern('(\d+[.,]?\d*)\s*-?(([kmµnp]?g/?(\d{1,2}\sh)?[dm]?[lL]?)|([µnp]?mol/?[dm]?[lL]?)|(mEq/d?[lL])|%)


 #addPattern('(\d+[.,]?\d*)\s?-?([mM]mol)', 'Mmol or mm', 0);
 
 # addPattern('[\b\s\.\,\;\(](\d+[\.,\s]?\d*)\s+(([k]?cal/?mole)|rpm|g|(([npm]?)([mM]ol))|(Hz|[a-zA-Z]{1,4}\^?[\d]?([\./][a-zA-Z]{1,4}))([\s\^;\:,]\d)?)[\s\.\,\;)]', 'Energy', 0);
 
  
 #addPattern('(\d+[.,]?\d*)\s*-?(([kmdµnp]?&#x003bc;[lL]?[g|M]?/?(( ([dmµnp]?|&#x003bc;)[lL]?[\s\.\;\)])|day|well|((\d+)?\s?[kmµnp]?g)|(\d{1,2}\sh))?(mol|[dm])?/?([lL]|min|min-1|sec|h|hour|day)?)|((U/[dm][lL])|molecules|((&#x003bc;|[µnp])?mol)/?[dm]?[lL]?)|(mEq/d?[lL])|%)[\s\.\,\;]', 'Mass or Volume or Substance Quantity or Rates or Percent', 0);
 #addPattern('[\b\s\.\,\;\(](\d+[\.,\s]?\d*)\s+(([k]?cal/?mole)|rpm|g|(Hz|[a-zA-Z]{1,3}\^?[\d]?\s*([\./][a-zA-Z]{1,4})?)([\s\^;\:,]\d)?)[\s\.\,\;)]', 'Energy', 0);
 #goto Skip;
 
 #goto SKIPMASS;
# addPattern('(\d+[.,]?\d*)\s*([a-zA-Z\d//]+/24 h)', 'Mass or Volume or Substance Quantity or Rates or Percent', 0); 
 addPattern('(\d+[.,]?\d*)\s*([a-zA-Z^\d//\s]+/24 h)', 'Mass or Volume or Substance Quantity or Rates or Percent', 0);
 addPattern('(\d+[.,]?\d*)\s*-?(([kmdµnp]?&#x003bc;[lL]?[g|M]?/?(( ([dmµnp]?|&#x003bc;)[lL]?[\s\.\;\)])|day|well|((\d+)?\s?[kmµnp]?g)|(\d{1,2}\sh))?(mol|[dm])?/?([lL]|min|min-1|sec|h|hour|day)?)|((U/[dm][lL])|molecules|((&#x003bc;|[µnp])?mol)/?[dm]?[lL]?)|(mEq/d?[lL])|%)[\s\.\,\;]', 'Mass or Volume or Substance Quantity or Rates or Percent', 0);
  #addPattern('(\d+[.,]?\d*)\s*([a-zA-Z\d//]{0,12}//24 h)', 'Mass or Volume or Substance Quantity or Rates or Percent', 0);
    
 #SKIPMASS:;

#addPattern('(\d+[.,]?\d*)\s*-()', 'Mass or Volume or Substance Quantity or Rates or Percent', 0);


   ### Find varous numbers?
   
   $bFindGenetics = 1;
   $bElectricity  = 1;
   $bBiochem = 1;
   
   
 #  $bFindGenetics = 0;
 #  $bElectricity  = 0;

 #goto SKIPGenetics;
 
  $exponentX = '\&#x000d7';
  $exponentExpr = '\s'.$exponentX.'\s';
  
  # addPattern "" --> ne ''      
  $bExponent = 1;
  if ($bExponent)
  {
   #addPattern("(\d+[\.,]\d+\s&#x000d7[.]+l)", "Exponent", 0);
   
   #addPattern("(\d+[\.,]\d+\s+x\s+10[-]?\d{1,2})[\s][a-zA-Z]{1-3}[/]?[a-zA-Z]{1,3}", "Exponent", 0);
   #addPattern("(\d+[\.,]\d*\s+x\s+10[-]?\d{1,2})[\s]", "Exponent", 0);
   # addPattern('(\d+[\.,]?\d*\s+\.+000d7\s+10\^[+-]?\d\d?)\s+([a-zA-Z/\^]+[\d]?\s*)', "Exponent", 0);
    
  #   addPattern('(\d+[\.,]?\d*\s+\&#x000d7;\s+10\^[+-]?\d\d?)\s*;?\s*([a-zA-Z/\^]{1,5}/?{[a-z^]{1,3}?[\d]?\s*)', "Exponent", 0);
     
     #4 x 10^7; cells/ml 
     #addPattern('(\d+[\.,]?\d*\s*\x)(.)',"Expo", 0); #10\^[+-]?\d\d?)', "Expo", 0); #   #?\s*([a-zA-Z/\^]{1,5}/?{[a-z^]{1,3}?[\d]?\s*)', "Exponent", 0);
     
     #addPattern('(4\s*&#x000d7;\s*10^7;)', "Mexpo", 0);  #\s*(cells/ml)     
     #addPattern('(4\s*&#x000d7;\s*10-?[\d]+\s)(.)*', "Mexpo", 0);
     #addPattern('(4\s*&#x000d7;\s*10[\^][-]?[\d]+);?([a-z]{1,5}/[a-z]{1,5}[\^]?[\d]?)', "Mexpo", 0);
     addPattern('(\d+[\.,]?\d*\s*&#x000d7;\s*10[\^][-]?[\d]+)[;\s]+([a-z]{1,5}/?([a-z]{1,5})?^?[\d]?)', "Mexpo", 0);
       
   #addPattern('(\d+[\.,]?\d*\s+x\s+10\^[+-]?\d\d?)\s+([a-zA-Z/\^]+[\d]?\s*)', "Exponent", 0); #[-]?\^\d{1,2})[\s]', "
   
   
   #[mnpcdk]?[glms][\s;]
   
  # addPattern('(\d+[\.,]\d*\s+x\s+10\^[+-]?\d)\s*([a-zA-Z/]{1,3}  )', "Ekcfod", 0); #[-]?\^\d{1,2})[\s]', "Exponent", 0);
   #addPattern('(\^\d{1,2})', "Exponent", 0);
   
   #([a-zA-Z]{1-3}[/]?[a-zA-Z]{1,3})', "Exponent", 0);
   #addPattern("(.+l)", "Exponent", 0);
   #[\s\t]  
    # $pat = '
   #addPattern('(\d+[\.,]?\d*\s$Exponent\s+[-]?\d[\s;/)])', 'Exponent', 0);  
   #addPattern('(\d+[\.,]?\d*\s$Exponent\s+[-]?\d)', 'Exponent', 0);
   #addPattern('(&#x000d7)', 'Exponent', 0);
   #addPattern($exponentX, "Exponent", 0);
   #addPattern("(\d+[\.,]?\d*\s$exponentX\s)", "Exponent", 0);
   
   #[-]?10[-]?\^\d{1,2})", "Exponent", 0);
   
   #([a-zA-Z]{1,3}[/]?[a-zA-Z]{1,3})", 'Exponent', 0);
   #addPattern('$EX)', 'Exponent', 0);
  }
        
   if ($bFindGenetics == 1) 
  {
  #1,982 sequences
   #addPattern('[a-zA-Z-\b](\d+)[\s-](sequences|genes|bp|kb|kDa|nts|[K]?bases)[\s\.\,\;]', 'Genetics and Bioinformatics', 0);
  
    #addPattern('[^^](\d+[,\.]?\d+)[\s-]([npm]?g|sequences|genes|bp|kb|kDa|nts|[K]?bases|mg\.mL-1)[\s\.\,\;\b/)]', 'Genetics and Bioinformatics', 0);   #[^a-z^A-Z^-]
   #   addPattern('[^^](\d+[,\.]?\d+)[\s-](sequences|genes|bp|kb|kDa|nts|[K]?bases|mg\.mL-1)[\s\.\,\;\b/)]', 'Genetics and Bioinformatics', 0);   #[^a-z^A-Z^-]
   addPattern('(\d+[\.,]?\d*)[\s-](&#x003bc;\smol)', "microMol", 0);  #captures g????
   #addPattern('(\d+[,\.]?\d+)[\s-](ng)', "ng", 0);
           
  }
 SKIPGenetics:;
  
  #3.3 10<sup>6 </sup>M<sup>-1 </sup>  1.06 105 M-1   between 30–50 mM, 0.95–3 mM for
  
  
 # $bBiochem = 0;
    
  if ($bBiochem == 1)
  {
  ## UNIVERSAL ##
  
  # more restrictive
       
   addPattern('[\s\,\;\(^.](\d+[\.,]?\d*)\s+(([k]?cal/?mole)|rpm|g|(([npm]?)([mM]ol))|(Hz|[a-zA-Z]{1,5}\^?[\d]?([\./][a-zA-Z]{1,4}))([\s\^;\:,]\d)?)[\s\.\,\;)]', 'Energy', 0);
   addPattern('[\b\s\,\;\(](\d+[\.,]?\d*)\s+([a-zA-Z]{1,3}\^?-?[\d]?)[\s\.\,\;)]', 'Energy', 0);
   #addPattern('[\b\s\.\,\;\(](\d+)\s+([a-zA-Z]{1,3}\^?-?[\d]?([\./][a-zA-Z]{1,4}))([\s\^;\:,]\d)?)[\s\.\,\;)]', 'Energy', 0);
   #addPattern('[\b\s\.\,\;\(](((\d+[\.,]\d+)|(\d+)))\s+([a-zA-Z]{1,4}\b([\s\^;\:,]\-?\d)?)[\s\.\,\;\)]', 'Energy', 0);
   #addPattern('[\b\s\.\,\;\(]((\d+[\.,\s]?\d*)\s+([a-zA-Z]{1,4}\^?[\d]?([\./]?[a-zA-Z]{1,4}))([\s\^;\:,]\d)?)[\s\.\,\;)]', 'Energy', 0);
      
   #addPattern('[\b\s\.\,\;\(](\d+[\.,\s]?\d*)\s+([npm]?([k]?cal/?mole)|rpm|g|[mM]ol|(Hz|[a-zA-Z]{1,3}\^?[\d]?\s*([\./][a-z]{1,3})?)([\s\^;\:,]\d)?)[\s\.\,\;)]', 'Energy', 0);        
    #addPattern('(\d+[\.,\s]?\d+?)\s+(µ[lL])[\s]?', 'Energy', 0);
    #[npm]            
  }
  if ($bElectricity == 1) 
  {
  #|(&#x003bc[VM])
   #addPattern('(\d+[\.,]?\d?)[\s-]([kKmM][VM])[\s\.\,\;]', 'Electricity and ?', 0);  
   addPattern('(\d+[\.,]?\d*)[\s-](([µukmKMn])?[VM])[\s\.\,\;\)/]', 'Electricity and ?', 0);
   #&#x003bc;
  }
  
  #$exponentX = "&#x000d7";
  #$exponentX = "\&#x000d7";
  #$exponentX = "\&\#x000d7";
 
  
    
    $bCancer = 1.0; 
    # p = 0.003 
    if ($bCancer==1)
  {    
   #addPattern('(p)\s=\s(\d+[\.,]\d+)', 'Probability?', 0);
   addPattern('(p)\s=\s((\d+[\.,]?\d*(\s+x\s+10\^[+-]?\d\d?)?))', 'Probability?', 0);
   
   
#   (\d+[\.,]\d+)|
    
  }
  
   $bFindUnknown = 0;
  if ($bFindUnknown == 1) 
  {
  addPattern('[^a-z^A-Z](\d+[\.,]\d+)[\s-](\w+)[\s\.\,\;]', 'Number', 0);
  addPattern('[^a-z^A-Z](\d+)[\s-](\w+)[\s\.\,\;]', 'Number', 0);
  }
  ##

  addPattern('(\d{2,3}/\d{2,3})\s*(mm\s*Hg)', 'Blood Pressure', 0);
  addPattern('(\d{0,}\sg/\d{1,}\sh)', 'Stool Fat', 0); #?
  addPattern('(\d+\s*ft\s*(\d+\s*in)?\s?)', 'UK Length', 1);
  addPattern('(\d{2,3})(/min)\s?', 'Rate of Pulse or Respirations', 0);
  addPattern('(\d{1,}[\.,]?\d*)(/mm)\s?', 'Count per mm', 0);
  addPattern('(\d{1,})-((day-old)|(year[-\s]old)|(year-age)|(month-old))\s?', 'Age', 0);  
  addPattern('(\d+[\.,]?\d*)[\s-]((year-old)|(year[s]?)|(day[s]?)|(week[s]?)|(month[s]?)|(hour[s]?)|(h)|(hr)|(min)|(minute[s]?)|(second[s]?)|(sec)|(s))[\s\.,\);]', 'Period', 0); #[\s\.,\);]
  
 # addPattern('(\d+[\.,]?\d*)[\s-]?(year-old|years?|days?|weeks?|month[s]?|hour[s]?|h|hr|min|minutes?|seconds?|sec|s)[\s\.,\);]', 'Period', 0);
  #addPattern('(\d+[\.,]?\d*)[\s-]?((year-old)|years?|days?|weeks?|month[s]?|hour[s]?|h|hr|min|minutes?|seconds?|sec|s)[\s\.,\);]', 'Period', 0);
  
  
    #addPattern('(\d+[\.,]?\d?)[\s-]?((year-old)|years?|days?|weeks?|month[s]?|hour[s]?|h|hr|min|minutes?|seconds?|sec|s)[\s\.,\);]', 'Period', 0);
    
  #addPattern('(\d\d)[\s\-](years)', 'Period', 0); #[\.,\);]
  #addPattern('(\d+)[\s-](years)', 'Period', 0); #[\.,\);]  
    
  
   #addPattern('(\d+[.,]?\d*)[\s\-](years)', 'Period', 0);
   #addPattern('(\d\d)\syear-old', 'Period', 0);
   #p unknown roblems with years, year-old?   
    
  addPattern('(\d{1,}[.,]?\d{1,}?)\s+([dcmµnp]m)[\s\.]', 'Metric Length', 0);
  addPattern('(\d+[.,]?\d+)\s*[\s-]?([mnp]?[lL]/?(hr?|min|sec)?)[.\s]','Metric Volume or Volume Rate', 0);
  addPattern('([+-]?\d{1,}[\.,]?\d{1,}?)\s*(°|&#x000b0;[CF]?)\s*','Temperature', 0);
  addPattern('(\d+[\s-]lb\s*(\d+[\s-]oz)?)\s*','UK Mass Lb Oz', 1);
  addPattern('[^b]\s(\d+[\s-]oz)\s*','UK Capacity Oz', 1);  
  addPattern('(N=\d+\s+\d+)((\s+)|(/hpf))','Two numbers', 0);
  addPattern('([pP][hH])\s?(\d+[\.,]?\d+)[\.,)\s]','PH', 0);#(\d+[.,]?d+)\s?','pH'); #if first is non-numerical -> swap
  addPattern('(\d{1,}[.,]?\d*)\s*(mm/h)[\s.]', 'mm per hour', 0);  
  addPattern('(\d+[.,]?\d+)-?(th|nd|rd)[^\w]','Ordinal', 0);
  
  
  ######   
   Skip:
  ######
  
        
  $range = $pTop;
  
  
 $i=0;
    
 @RegEx = $1;
 $conversionCoefficient = '1.0';
 $i=0;
 
 sub nishto()
 {
 $temp ="kfod 8-oz jkkifis";
  if ($temp =~m/\s(\d+[\s-]oz)\s*/)
         {
          
          print "FOUND!";                     
         }    
         else { print "NOT!"}
         
         exit(0);
  }
         
         
 #filename 
  ##sub ProcessFile($)
 ##{        
   
   
   ##### DIR ######
   $path = 'C:\Documents on this PC\articles.tar\BMC Bioinformatics';
   $path = 'C:\Documents on this PC\articles.tar\BMC Genet';
   $path = 'C:\Documents on this PC\articles.tar\HemTest';
   
    
   $path = 'C:\Documents on this PC\articles.tar\BMC Genet';
   $path = 'C:\Documents on this PC\perl\perl\test';
   
   #goto SKIPCONF;
   
   
   my $dirIndex = 0;
   my $dirListing = 0;
   
   
   
#   if ($ARGV[0] eq "list")
   {   
    $dirListing = 1;
    open(FDIRLIST, "showlist.txt");
    @dirList = <FDIRLIST>;   
    close(FDIRLIST);       
    #$path = "C:\\Documents on this PC\\articles.tar\\".@dirList[$dirIndex];
    $path = "$baseDir".@dirList[$dirIndex];
    goto SkipMenu;       
   } 
            
   open(FCONFIG, "config.txt");
   @conf = <FCONFIG>;
   $confi = join('',@conf);
   close(FCONFIG);
   
   open(FDIRLIST, "dirlist.txt");
   @dirList = <FDIRLIST>;   
   close(FDIRLIST);      
   
   $i = -1;
   foreach $s (@dirList)
   {
   $i++;
   chop $s;
   print("\n$i --> $s");
   }      
   
   print "\n================\nSelect dir...(0 - $i)";
   $dirNum = <STDIN>;      
   $path = $dirList[$dirNum];
   
   
   
   goto SkipAutomatic;
   
   
   ## CONFIG ###
      
    foreach $s (@conf)
   {
   $i++;
   chop $s;
   print("\n$i --> $s");
   }
        
   if ($conf[0] eq 'no') 
   {
   goto SKIPCONF;
   }
   elsif ($conf[0] eq 'test')
   {
   print "TEST";
   $path = $conf[2];
    }
   else
   {print "NOTEST"; $path = $conf[1];}
   
   SkipAutomatic:;
   SkipMenu:;
   
   
      
   print "\nPA: $path\n";
   #$path = $conf[0];
   #$path = ''
   
   
#   $path = 'C:\Documents on this PC\articles.tar\
    
    #$path = 'C:\Documents on this PC\articles.tar\BMC Genet';
    
       if ($path eq $conf[1]) { print "\n\n<<<<<<<<<<<<eq (EQual) for string<<<<<<<<<<<<\n\n";}      
       else       
       {
       $len1 = length($path);
       $len2 = length($conf[1]);
       print "\n\n$path($len1)\n$conf[1]($len2)\n\n ";
       }
       
   
   SKIPCONF:;
   
   
   
    open (FO_TOTAL, ">", "TotalReport.txt");
    $totalTime = 0;
    $totalNumberOfFiles = 0; 
    
  ################
  ## MAIN LOOP ###
  ################
  
  foreach $dirName(@dirList)
  {   
  #if (length($dirName)>0)
  print "\n\n>>>>$dirName<<<<\n\n";
  if ($dirName=~m/\n/gi) { chop($dirName); }
  print "\n\n>>>>$dirName<<<<\n\n";
  if ($dirName eq 'end') {last;} 
  else {"$dirName != <<<end>>>   ????";}
      
  #$path = "C:\\Documents on this PC\\articles.tar\\".@dirList[$dirIndex];
  #$path = "C:\\Documents on this PC\\perl\\perl\\testbio";  
  #$path = "C:\\Documents on this PC\\articles.tar\\".$dirName;
  
  $path = "$baseDir".$dirName;        
  $dir =  $path;
  
 #  $dir = $fileName;
 
  my @timeStart;
  my @timing;
  $now = localtime;
  
  #@timeStart = split('/\s:/', $now);
     ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime(time);
                                   
  push(@timing, "start", $hour, $min, $sec);
  print "\n\n\nStart at: $hour:$min:$sec\n";
               
  opendir(DIR, $dir) || die "\n\n No $dir?:";
   
  print "PA:$dir\n";    
      
   $dirPattern = 'm/[cdefghij]*';
   $dirPattern = '.*';
   #$dirPattern = "[CDEFGHIJ]:\\Document";
   $dirPattern = "[CDEFGHIJ]:\\";
   
   
   #$dir = 'C:\.Documents on this PC\articles.tar\.BMC Bioinformatics';
   #$formattedOut = split()
   @splitDir = split("\\\\", $dir, 10);
   #print "Sizeof split";
   #$formattedOut = $split[@split-1];
   #$formattedOut = $split[0];
   
   #$formattedOut = $slitDir[0]."-out.txt";
    my @values = split('\\\\', $dir, 10);

  foreach my $val (@splitDir) {
    print "$val\n";
  }
 
   
 #  $myNames = "Jacob,Michael,Joshua,Matthew,Ethan,Andrew";
#   $myNames = "Jacob. Michael Joshua\Matthew\Ethan\Andrew";
 #  @nameList = split('\\\\', $myNames, 2);
   #$formattedOut = $nameList[0];
   
   #  my $data = 'Becky Alcorn,25,female,Melbourne';

 # $data = 'Becky\Alcorn\25\female\Melbourne';

  #my @values = split('\\\\', $data);
  
  
  
  $formattedOut = $splitDir[@splitDir-1]."-out.txt";
  $formattedOut =~ s/ /_/g;
  $formattedOut = "C:\\Documents on this PC\\articles.tar\\results2\\".$formattedOut;

   #if ($dir =~ m/[cdefghij]:[\\]/gi) # ([.]*\\)*(.*)/gi)
 #  if ($dir =~ m/$dirPattern/gi) # ([.]*\\)*(.*)/gi)
 #  {
 #   $formattedOut = $MATCH;
 #   print "\n>>>>>>$MATCH<<<<<";
 #  }
 
 print "\n>>>>>>$formattedOut<<<<<";
   
   #exit(0);
   
        
   open(FO_FORMATTED, ">", $formattedOut);
   open(FO_UNITS, ">", $formattedOut."-units.txt");
   open(FO_UNITSLOG, ">", $formattedOut."-log.txt");
   
   my $numberOfFiles = 0;
   
   @dircontents = sort(readdir(DIR));
   shift(@dircontents); #.
   shift(@dircontents); #..  
 #foreach $name (sort readdir(DIR))
 foreach $name (@dircontents)
 { # list context, sorted
          
      $numberOfFiles++;
      
      if (($numberOfFiles%25) == 0 ) { print "\n$numberOfFiles files processed";}
      #Print name of File
       # print "$name\n"; # prints ., .., system.ini, and so on
       
        
        #if ($name=~m/\w+\.pl/g)
        # if ($name=~m/[\w\d]+ \.nxml/g)
         #if ($name=~m/[.]*\.nxml/g)
               
          $fileName =  $dir."\\".$name;                                    
  #open(FIN, "<", $dir."\\".$name);                            
  open(FIN, "<", $fileName);
  print FO_UNITSLOG "$fileName\n";
   
  #open(FIN, $file);	# Open the file
  
  @lines = <FIN>;		# Read it into an array
  close(FIN);		# Close the file
  $text  = join('', @lines);
  #$copy  = $text;


    

  $text =~s/$clearHtmlTags//gi;
  $sups = '<sup>\s*([-]?\d+)\s*</sup>';  
  $text =~s/$sups/^$1 /gi;
  
  #$text =~s/&#x000d7[;]/x/gi;  
  
  #$sup = '<sup>.*([+-]\d+)</sup>';
  #$text =~s/$sup/^$1/gi;
    
#  $micro = "&\#x003bc;";
  #$deg = "&\#x003b2;";  
  
#  &#x003b2;
 # $text =~s/$micro/µ/gi;  
  
 # $deg = "&\#x000b0;";    
  #$text=~s/$deg/°/gi;
      
    print FO_FORMATTED "\n-------------------------------------\n|Input:\t [$numberOfFiles] : $fileName\n|Context:\t -$defContextBack +$defContextForward characters\n------------------------------------";
    print FO_UNITS "\n###\n$fileName\n";
    #print FO_UNITSLOG "$formattedOut.-log.txt\n";
      
#  $text=~s/(<string>|<\/string>|<Sentences>|<\/Sentences>|<   SentenceSplittedVignette>|<\/#SentenceSplittedVignette>)//gi;
     
    $i = 0;
   pos($text) = 0;
   
     
   $PositionsTop = 0;
   
   while($i < $range)
  {         
  #print "\n$i";
  #pos($text) = 0;
  pos($text) = 0;       
  #$pattern = $P[$i][0];
  # print $pattern;    
  # print "\nSearching for: $P[$i][1]\n\n";
  
  $converted = " ";  
  $foundType = " ";
  
  #while ($text =~m/$pattern/g) #!!!!!!!!
  
  while ($text =~m/$P[$i][0]/g)    
  {       
    $currentFilesIndex = 0;
    
   $st = length($PREMATCH);
   $le = length($MATCH);   
   
    #print "$PositionsTop ";
   $Positions[$PositionsTop] = $st;   
          
       #?   ##########
 
#   if ($P[$i][4] != 0) 
#     {
#      $tempMatch = $MATCH;
#      
#      foreach $type (keys %Conversions)
#      {
#       if ($tempMatch =~m/$type/)
#         {
#          $converted = ( substr($tempMatch, 0, -length($MATCH)) ) * $Conversions{$type}." m";
#          $foundType = $type;
#          last;                     
#         }    
#       }
#      }

                                                
   if ($st<$defContextBack)
   {
   $start = 0;
   }
    else
    {
     $start = $st - $defContextBack;
    }
       
   if (($st+$defContextForward)>length($text))
   {
    $len = length($text) - $start;   
   } 
   else {
         $len = 2*$defContextForward;
        }
      
   $out1 = substr($text, $st, $le);
   $out2 = substr($text, $start, $len );
   
   $p = findWhichFileLinear($st, $currentFilesIndex);
   $inFileFileName = $fileName[$p];
   $currentFilesIndex = $p;
         
  # print "\nInFileFileName = $inFileFileName, $st  -- ".$inFileFileName;
   
   if ($P[$i][4]==0)
   {    
 #   print "$P[$i][1] found: >>>$out1<<<  in:\n $out2\n";    
   }
   else
   {    
#    print "$P[$i][1] found: >>>$out1<<< == $converted in:\n $out2\n\n\n";    
             
    
    if ($P[$i][4] == 1) 
    {
     $targetUnit = "m"; 
     $conversionCoefficient = $Conversions{$foundType};          
    }
     else 
          {
           $conversionCoefficient = "1.0";
           $foundType = $P[$i][1];
           $covnerted = $out1;
          }                        
   }
      
   $conversionCoefficient = 1.0;
                           
     $RegEx[1] = $1;
     $RegEx[2] = $2;
     
     $RegEx[2] =~ s/&#x003bc;/µ/g;
     $RegEx[2] =~ s/&#x000b0;/°/g;
     
     #if ($RegEx[2] eq "cc") {$RegEx[2] = "cm^3";} #Additional pass over the files?    
     #if ($RegEx[2] eq "cc") {$RegEx[2] = "ml";} #Additional pass over the files?
     
     $RegEx[2]=~s/(cc)|(cm[\^]3)/ml/g;
     $RegEx[2]=~s/mEq/mmol/g;
     $RegEx[2]=~s/ug/µg/g;
     $RegEx[2]=~s/mm[\^]/µl/g;    
     $RegEx[2]=~s/$qL/$ql/g; #mEq/L -> mEq/l
     $RegEx[2]=~s/dL/dl/g; #mEq/L -> mEq/l
     $RegEx[2]=~s/mgr/mg/g;
     $RegEx[2]=~s/gram/g/g; #mEq/L -> mEq/l
     $RegEx[2]=~s/gr/g/g; #mEq/L -> mEq/l
          
            
          
     goto SKIPDEBUG;
     
    #if ($i==0)  #micro
   {   
    if ($RegEx[2] =~ s/&#x003bc;/µ/g)
     {
        #print $RegEx[1];
        $fifi=<STDIN>;
     }   
   }     
           
    SKIPDEBUG:;
   
   if ($RegEx[2] =~m/(\bcan\b)|(\ba(ny)?\b)|(\bx\b)|(\bo[urnf][et]?\b)|(\band\b)|(\bbut\b)|(\buse\b)|(\bd[io]d?\b)|(\bs[oe]t?\b)|(\bper\b)|(\bend\b)|(\bn[eo]w\b)|(\bbut\b)|(\bvs\b)|(\band\b)|(\bto[p]?\b)|(\bi[sft]\b)|(\ball\b)|(\bas\b)|(\bby\b)|(\bare\b)|(\bthe\b)|(\bten\b)|(\bs?he\b)|(\bsub\b)|(\bnot?\b)|(\bu[kp]\b)|(\bm[ae][ny]\b)|(\bHo\b)|(\bkey\b)|(\bdue\b)|(\bf[oi][rg]\b)|(\bW[uea][s]?\b)|(\bvon\b)|(\bpp\b)|(\bL[ei][te]\b)|(\bDe\b)|(\bbox\b)|(\bat\b)|(\bi\.e\b)|(\bha[ds]\b)|(\blow\b)|(\bexp\b)|(\bmet\b)/gi) #in is special      
   {   
    goto MistakeSkip;
   }  
      
   if ($RegEx[1]=~m/\b\d+[,.]$/g)
   {
    goto MistakeSkip;
   }
        
    $targetUnit = $RegEx[2]; 
             
  #  goto SkipOldVersionSwap;
    
     if ($RegEx[1]=~m/^[a-zA-Z].*/g)  #if the first match begins with a letter
     {
      #pos($RegEx[1]) = 0;
      #if ($RegEx[1]=~m/\)
      $swap = $RegEx[2];
      $RegEx[2] = $RegEx[1];
      $RegEx[1] = $swap;
     }
              
  #   SkipOldVersionSwap:
  #   
  #   if ($RegEx[1]!=~m/\d+/g)  #if the first match doesn't begin with a number
  #   {
  #    $swap = $RegEx[2];
  #    $RegEx[2] = $RegEx[1];
  #    $RegEx[1] = $swap;
  #   }


     #$ccExpression = '([.]+)?($Slash)?cm^3';
             
     $converted = $RegEx[1];
     $targetUnit = $RegEx[2];     
     
     if ($RegEx[2] =~ m/$dlExpression/) #'(.*)/dl'
     {     
      print "\ndl";      
      $RegEx[1] *= 10;
      $RegEx[2] = $1."/l";
      $conversionCoefficient = "10";
     }
     if ($RegEx[2] eq "mm^3")
     {
      $RegEx[2] = l;
      $RegEx[1]*=0.000001;
     }
     #elsif ($RegEx[2] eq =~m/cm^3/)
     elsif ($RegEx[2] =~ m/$ccExpression/) #cm^3/) #cm^3/)
     {     
      print "CM^3";      
      $RegEx[1] *= 1000;
      $RegEx[2] = $1."/l";
      $conversionCoefficient = "10^3";
     }
     elsif ($RegEx[2] eq 'cm^3')
     {
      #C/cm^3 
      $RegEx[2]="l";
      #$RegEx[2]  = $1.$2."l";   # liter
      $RegEx[1] *= 0.001;
      $conversionCoefficient = "10^-3";            
     }                         
     #elsif ($RegEx[2] =~ m/(.+)($Slash)cm^3/) #cm^3/) #cm^3/)
     #     elsif ($RegEx[2] =~ m/([.]+)($Slash)?ml/)
      elsif ($RegEx[2] =~ m/cells($Slash)ml/)
     {
      #$RegEx[2] = "$1$2l";
      $RegEx[2] = "cells/l";
      $conversionCoefficient = "10^6";
      
      #if ($RegEx[2]=~m/(\d)\s$X\s10^(-)?([\d]+)/)
      
      #$eeee = '(\d+[\.,]?\d*)\s*$X\s*10[\^]([-]?)([\d]+)';
      #$eeee = '(\d+[\.,]?\d*)\s*&#x000d7;\s*10[\^][-]?([\d]+)';
      $eee = '(\d+[\.,]?\d*)\s*&#x000d7;\s*10[\^]([\d]+)';
      #if($RegEx[2]=~m/\d+[\.,]?\d*\s*&#x000d7;\s*10[\^][-]?[\d]+)
      if($RegEx[1]=~m/$eee/) #(d+[\.,]?\d*)\s*$X\s*10[\^]([-]?)([\d]+)/)
       {
        print "\nYES!";
        #$inpi = <STDIN>;
        goto SkipCalculation;
        $Mult = 1;
        if ($2=="")
        {
        for($exp=1; $exp<=$2; $exp++) {$Mult=$Mult*10;}
        }
        
        #elsif ($2=="-")
         #   {
          #    for($exp=1; $exp<=$3; $exp++) {$Mult=$Mult/10;}          
           # }
       $RegEx[1] = 1000000*$1*$Mult;
      
        SkipCalculation:
              $NewExp = $2 + 6;                                            
              #$RegEx[1] = $1." ".$X." "."10^".$2$NewExp;              
              $RegEx[1] = $1." ".$X." "."10^".$NewExp;
              #$RegEx[1] = $1;           
       }
       else
           {
            $RegEx[1]*=1000000;
          }
     }               
          

        #if ($RegEx[2] ==          
            
        #LB OZ, FT IN
        #if ( ($RegEx[2]=~m/(lb|oz)/) || ($RegEx[1]=~m/(lb|oz)/) || ($RegEx[1]=~m/(ft|in)/) || ($RegEx[2]=~m/(ft|in)/))
        if ( ($RegEx[2]=~m/(lb|oz)/) || ($RegEx[1]=~m/(lb|oz)/)) # || ($RegEx[1]=~m/(ft|in)/) || ($RegEx[2]=~m/(ft|in)/))
        {
         $LB = 0; $FT = 0;
         $OZ = 0; $IN = 0;
                               
            if ($RegEx[2]=~m/(\d+)[\s\-]lb/)
             {               
               $LB = $1;                   
             } 
                     
             if ($RegEx[2] =~ m/(\d+)[\s-]oz/)
             {                                          
               $OZ = $1;
             }
             
             
             if ($RegEx[1] =~ m/(\d+)[\s-]ft/)
             {                                          
               $FT = $1;
             }
             elsif ($RegEx[2] =~ m/(\d+)[\s-]ft/)
             {                                          
               $FT = $1;
             }
                          
        #     if ($RegEx[1] =~ m/(\d+)[\s-]in/)
        #    {                                          
        #       $IN = $1;
        #    }
        #     elsif ($RegEx[2] =~ m/(\d+)[\s-]in/)
        #     {                                          
        #       $IN = $1;
        #     }
                      
           if ($LB!=0)
           {
            $RegEx[1] = $LB.'.'.$OZ;
            $RegEx[2] = 'lb oz';
            $conversionCoefficient = 'lb*'.$Conversions{'lb'}.'+oz*'.$Conversions{'oz'};
            $converted = $LB*$Conversions{'lb'} + $OZ*$Conversions{'oz'};
            $targetUnit = 'kg';
           }
           elsif (($OZ!=0) && ($LB==0)) #Capacity Oz
                 {
                  #print FO_FORMATTED "OOOOOOOOOOOOOOOOZZZZZZZ"; #$FT.'.'.$IN.'  -  '.$RegEx[1].'  '.$RegEx[2];
                  if ($OZ == 0) {goto SKIP_PRINTING;} 
                  $RegEx[1] = $OZ;                  
                  $RegEx[2] = 'capacity oz';
                  $conversionCoefficient = $Conversions{'cap.oz'};
                  $converted = $OZ*$Conversions{'cap.oz'};
                  $targetUnit = 'l';
                 }
                 
          if ( ($FT!=0) || ($IN!=0) )
           {           
#            print FO_FORMATTED $FT.'.'.$IN.'  -  '.$RegEx[1].'  '.$RegEx[2];
            $RegEx[1] = $FT.'.'.$IN;
            $RegEx[2] = 'ft in';
            $conversionCoefficient = 'ft*'.$Conversions{'ft'}.'+in*'.$Conversions{'in'};
            $converted = $FT*$Conversions{'ft'} + $IN*$Conversions{'in'};
            $targetUnit = 'm';
           }                                                                                                                                                             
        }                
                                     
      $out2 =~s/\n//g;
      $out2 =~s/\s{2,}/; /g;
      $out2 =~ s/&#x003bc;/µ/g;
      $out2 =~ s/&#x000b0;/°/g;
      $out2 =~ s/&#x0003e;/>/g;
      $out2 =~s/&#x000d7;/x/gi;
      $RegEx[1]=~s/&#x000d7;/x/gi;
          
      #print FO_FORMATTED "\n$inFileFileName\t$RegEx[1]\t$RegEx[2]\t$conversionCoefficient\t$converted\t$targetUnit\t$out2";      
      #$OutputLine = sprintf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s", $Positions[$PositionsTop], $inFileFileName, $RegEx[1], $RegEx[2], $conversionCoefficient, $converted, $targetUnit, $out2);
    if ($RegEx[1]<0.001)
     {
      $OutputLine = sprintf("%s\t%1.9f\t%s\t%s\t%s\t%s\t%s",   $inFileFileName, $RegEx[1], $RegEx[2], $conversionCoefficient, $converted, $targetUnit, $out2);
      }
      else
      {
          $OutputLine = sprintf("%s\t%s\t%s\t%s\t%s\t%s\t%s", $inFileFileName, $RegEx[1], $RegEx[2], $conversionCoefficient, $converted, $targetUnit, $out2);
      }
      #$OutputLine .=" -- $P[i][1]";
                   
      if ($PrintImmediately == 1)                
         {
          print FO_FORMATTED "\n$OutputLine"; #\n$inFileFileName\t$RegEx[1]\t$RegEx[2]\t$conversionCoefficient\t$converted\t$targetUnit\t$out2";
          }          
      else
      {
       #print "dsfkiodsjkfoesjfijds";
      # print "$PositionsTop";
       $LinesForPrinting[$PositionsTop] = $OutputLine;
       $UnitsLines[$PositionsTop] = $targetUnit; 
       $PositionsTop++;
       #$PositionsTop++;   
      }
            
  MistakeSkip:;
  SKIP_PRINTING: # if false cap.oz are found
                 
  }
  $i++;
 }
  ##SORTING###
  
  if ($PrintImmediately == 0)
  {
  #print "Sorting..."; 
  #$lfdfd = <STDIN>;
    
  
 #goto SKSK; 
  #print "\n\n$PositionsTop\n";
  for($i3=0; $i3<$PositionsTop; $i3+=1)
  {
  #  print "\nREDIRECT? $i3 - $PositionsTop";
    $Redirect[$i3] = $i3;
   #  print "\nAFTER REDIRECT? $i3 - $PositionsTop";
  }  
  
  SKSK:
       
       if ($Sort == 0)  {	goto SKIPSHELL;}
       
  		$i2 = 0;
  		$j2 = 0;  		
  		$size2 = $PositionsTop;
  		$step2 = $size2/2;
  		$temp2 = 0;
  		$tempRedirect = 0;
  		#$MinEl = 0;
  		
  		  		#goto SHELL;
  		#print "\ntempREDIRECT?";
  		
  		 for($i2=0; $i2<$size2; $i2++)
  		  {
  		   #$MinEl = $Positions[$i2];
         #$MinIndex = $i2;
         $MinEl = $i2;  
            for($j2 = $i2+1; $j2<$size2; $j2++)
            { 
              if ($Positions[$j2] < $Positions[$MinEl]) {$MinEl = $j2;}
            }
          $temp2 = $Positions[$i2];
          $Positions[$i2] = $Positions[$MinEl];
          $Positions[$MinEl] = $temp2;
          $temp2 = $Redirect[$i2];          
          $Redirect[$i2] = $Redirect[$MinEl];
          $Redirect[$MinEl] = $temp2;                            
        }
  		
  		goto SKIPSHELL;
  		
  		SHELL:
  		while($step2>0)
  		{
  		
  		if ($step2 < 0.51) { $step2 = 0; }  
  		#print "\n$step2";
  		
  		  
       for($i2=$step2; $i2<$size2; $i2++)
        {
         $j2 = $i2;
         $temp2 = $Positions[$i2];
         $tempRedirect = $Redirect[$i2];
          while( ($j2>$step2) && ($Positions[$j2-$step2] > $temp2) )
          {
            $Positions[$i2] = $Positions[$i2 - $step2];
            $Redirect[$i2] = $Redirect[$i2 - $step2];
            $j2 = $j2 - $step2;                    
          }
          
          $Positions[$j2] = $temp2;
          $Redirect[$j2] = $tempRedirect;                  
        }
         $step2 = $step2/2;
                      
      }      
  			
  #print FO_FORMATTED "\nPOSITIONS TOP = $PositionsTop";
  
  SKIPSHELL:
  
  $last = -100;
  for ($i2=0; $i2<$PositionsTop; $i2++)
  {
   $cur = $Positions[$i2];  
   if ( ($cur - $last) < 3 ) {next;}
   $last = $cur;      
   
   #print FO_FORMATTED "\n$LinesForPrinting[$i2]";   
   #print FO_FORMATTED "\n$LinesForPrinting[$Redirect[$i2]]";
   #print FO_FORMATTED "\n$Redirect[$i2]";
   #print  "\n$Redirect[$i2]";
      
   print FO_FORMATTED "\n$LinesForPrinting[$Redirect[$i2]]";
   #print "\n$LinesForPrinting[$Redirect[$i2]]";
   print FO_UNITS "$UnitsLines[$i2]\n";   
   #print "\n$Positions[$i2]";   
   } 
   
   print FO_UNITS "\n!!!"; #!!! ==> End of file
  #print FO_UNITS "###\n";
  
 }#if imed
  
} #foreach file in dir


 print "\n$numberOfFiles files processed";            
  ($secF,$minF,$hourF,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime(time);
                                   
  push(@timing, "final", $hour, $min, $sec);
  print "\nFinal at: $hourF:$minF:$secF\n";
  
  my $diffHour = $hourF - $hour;
  my $diffMin =  $minF - $min;
  my $diffSec = $secF - $sec;
#  if ($diffSec<0) { $diffSec = 60-$diffSec; }
  
  my $resTime = $diffMin*60 + $diffSec;
  my $resTime = $diffHour*3600 + $diffMin*60 + $diffSec; #$resTime;#diffSec; #?
  #print "\nTime: $diffHour: $diffMin: $diffSec";  #.":".$diffMin.":".$diffSec;
  print "\nTime: $resTime";  #.":".$diffMin.":".$diffSec;
  
  print FO_FORMATTED "\n\n";
  print FO_FORMATTED "\nStart at: $hour: $min: $sec";
  print FO_FORMATTED "\nFinal at: $hourF: $minF: $secF";  
  #print FO_FORMATTED "\nTime: $diffHour: $diffMin: $diffSec";  #.":".$diffMin."
  print FO_FORMATTED "\nTime: $resTime sec";        
                     
  close FO_FORMATTED;
  close FO_UNITS;
  close F_OUTPUT;
  $totalTime += $resTime;
  $totalNumberOfFiles+=$numberOfFiles;
  print          "\n$dir\n$hour:$min:$sec <--> $hourF:$minF:$secF ===> $resTime ($totalTime) ... $numberOfFiles ($totalNumberOfFiles)";
  print FO_TOTAL "\n$dir\n$hour:$min:$sec <--> $hourF:$minF:$secF ===> $resTime ($totalTime) ... $numberOfFiles ($totalNumberOfFiles)";
  }         #foreach dir
 
 close FO_TOTAL;
 close FO_UNITSLOG   
  
