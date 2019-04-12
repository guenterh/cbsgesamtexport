//only as example - remove it later

//cbs_http = "http://localhost:40000/JOB2/RUN13/";
cbs_http = "http://sb-rcbs4i.swissbib.unibas.ch:40000/JOB2/RUN13/";


cbs_http|
//if we provide a file range - always the pattern  [\d*?-\d*?] - it's not allowed to use a file name
//as part of cbs_http
cbs-export-source (fileRangePattern="job2r13A[1-164].raw")|
file-splitter(delimiter="(?<=</record>)")|
normalize-string |
substitute-string-pattern(replace="<record>", replacement="<record type=\"Bibliographic\" xmlns=\"http://www.loc.gov/MARC21/slim\">") |
encode-kafka-message(status="CREATE") |
write-kafka-configurable-writer(kafkaTopic="sb-all",bootstrapServers="sb-uka3:9092,sb-uka4:9092,sb-uka5:9092,sb-uka6:9092");
