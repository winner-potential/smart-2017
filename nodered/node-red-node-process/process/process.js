module.exports = function(RED) {
    var ConsumptionNode = function (config) {
        RED.nodes.createNode(this,config);
        var node = this;

        this.on('input', function (msg) {
          msg.payload = process.memoryUsage();
          node.send(msg);
        });
    }
    RED.nodes.registerType("process", ConsumptionNode);
}
