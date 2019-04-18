//only as example - remove it later

//cbs_http = "http://localhost:40000/JOB1/RUN12/";
cbs_http = "http://sb-rcbs4p.swissbib.unibas.ch:40000/JOB1/RUN12/";

cbs_http|
//if we provide a file range - always the pattern  [\d*?-\d*?] - it's not allowed to use a file name
//as part of cbs_http
cbs-export-source (fileRangePattern="job1r12A[1-1].raw")|
file-splitter(delimiter="(?<=</record>)")|
normalize-string |
substitute-string-pattern(replace="<record>", replacement="<record type=\"Bibliographic\" xmlns=\"http://www.loc.gov/MARC21/slim\">") |
write-sized-files(path="/data/export.20190418.swissbibToslsp.${i}.txt.gz", fileSizeNumberRecords="10000", compression="gzip");
//write-sized-files(path="/home/swissbib/temp/trash/export.swissbibToslsp.${i}.txt.gz", fileSizeNumberRecords="10000", compression="gzip");
