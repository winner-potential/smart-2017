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
        content.time    = new Date(content.time || new Date()).getTime();
        content.station = content.station       || "unknown";
        content.energy  = content.energy        || 0;
        content.id      = content.id            || "ERROR";
        attrMap = { 'time'      :   content.time.toString(), 
                    'station'   :   content.station.toString(),
                    'id'        :   content.id.toString(),
                    'energy'    :   content.energy.toString()};
        content = "";
        outputStream.write(JSON.stringify(content).getBytes(StandardCharsets.UTF_8));
    }));
}
session.putAllAttributes(flowFile, attrMap);
session.transfer(flowFile, REL_SUCCESS);
