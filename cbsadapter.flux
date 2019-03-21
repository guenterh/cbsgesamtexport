//only as example - remove it later

//cbs_http = "http://localhost:40000/JOB2/RUN12/";
cbs_http = "http://sb-rcbs4i.swissbib.unibas.ch:40000/JOB2/RUN12/";


cbs_http|
//if we provide a file range - always the pattern  [\d*?-\d*?] - it's not allowed to use a file name
//as part of cbs_http
cbs-export-source (fileRangePattern="job2r12A[1-160].raw")|
file-splitter(delimiter="(?<=</record>)")|
normalize-string |
substitute-string-pattern(replace="<record>", replacement="<record type=\"Bibliographic\">") |
encode-kafka-message(metadata="status=replace") |
write-kafka-configurable-writer(kafkaTopic="CBSEXPORT",bootstrapServers="sb-uka3:9092,sb-uka4:9092,sb-uka5:9092,sb-uka6:9092");