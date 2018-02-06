var StreamCallback =  Java.type("org.apache.nifi.processor.io.StreamCallback");
var IOUtils = Java.type("org.apache.commons.io.IOUtils");
var StandardCharsets = Java.type("java.nio.charset.StandardCharsets");
var attrMap = {};

var flowFile = session.get();
if (flowFile != null) {
    flowFile = session.write(flowFile,
    new StreamCallback(function(inputStream, outputStream) {
        var text = IOUtils.toString(inputStream, StandardCharsets.UTF_8);
        var content = JSON.parse(text);
        var attributes = flowFile.getAttributes();
        content = {
            "name"    : "pvenergy",
            "value"   : attributes.energy,
            "time"    : attributes.time,
            "tags": {
                "station": attributes.station
            },  
            "id": attributes.id
        };
        outputStream.write(JSON.stringify(content).getBytes(StandardCharsets.UTF_8));
    }));
}
session.transfer(flowFile, REL_SUCCESS);
