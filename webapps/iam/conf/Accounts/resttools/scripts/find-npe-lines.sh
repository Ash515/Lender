temp=temp
#grep "public *Builder *set.*String *value)" -A 5 -n $1 > $temp

awk 'BEGIN{
		counter=0;
		twoLevelMethodFormationFlag=0;
		lastLine="";
		}
		{
			if(counter!=0)
			{
				print NR"-"$0;
				if(counter++==5)
				{	
					print"--";
					counter=0;
				}
			}
			if(counter==0)
			{
				if($0 ~ "public *Builder *set.*java\.lang\.String *value\\)")
				{
					print NR":"$0;
					counter++;
				}
				else if($0 ~ "public *Builder *set.*\\(")
				{
					lastLine=$0;
					twoLevelMethodFormationFlag=1;
				}
				else if((twoLevelMethodFormationFlag==1) && ($0 ~ ".*java\.lang\.String *value\\)"))
				{
					print NR-1":"lastLine"\n"$0;
					lastLine="";
					twoLevelMethodFormationFlag=0;counter++;
				}
			}
		}' < $1 > $temp

echo "" > $2
awk 'BEGIN {
			counter=0
		} {
			if(counter == 0 && $2 == "public" &&  (NF == 6||NF == 4) && substr($4,1,length("setReference(")) != "setReference(") {
				methodname=$4;
				gsub(/set/, "clear", methodname);
				gsub(/\(.*/, "();", methodname);
				counter=1;
			} else if(counter != 0 && $2 == "throw") {
				lno=$1
				gsub(/:/, "", lno);
				gsub(/\-/, "", lno);
				print lno",return "methodname; 
				counter=0;
				methodname="";
			} 
			if(counter > 6) {
				#print "Not found hence ignoring for " methodname;
				counter=0;
				methodname="";
			}
			if(counter != 0) {
				counter++;
			}
		}' < $temp > $2
rm $temp
