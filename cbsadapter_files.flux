//only as example - remove it later

//cbs_http = "http://localhost:40000/JOB1/RUN12/";
cbs_http = "http://sb-rcbs4p.swissbib.unibas.ch:40000/JOB1/RUN14/";

cbs_http|
cbs-export-source (fileRangePattern="job1r14A[1-57].raw")|
file-splitter(delimiter="(?<=</record>)")|
normalize-string |
write-sized-files(path="/data/export.swissbibToslsp.${i}.xml.gz", fileSizeNumberRecords="190000", compression="gzip", header="<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n<collection>\n", footer="</collection>");
