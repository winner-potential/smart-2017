package de.fsu.datalab;

import javax.ejb.Startup;
import javax.enterprise.context.ApplicationScoped;
import javax.ws.rs.core.MediaType;

import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.apache.camel.model.rest.RestBindingMode;
import org.wildfly.extension.camel.CamelAware;

import de.fsu.datalab.model.pvreceiver.PvReceiverData;

@Startup
@CamelAware
@ApplicationScoped
public class DataLabRouteBuilder extends RouteBuilder {
	@Override
	public void configure() throws Exception {
		restConfiguration().component("servlet").bindingMode(RestBindingMode.json);

		rest("/endpoints")
			.post("/pvreceiver")
				.produces(MediaType.APPLICATION_JSON)
				.consumes(MediaType.APPLICATION_JSON)
				.type(PvReceiverData.class)
				.to("direct:pvreceiver");

		from("direct:pvreceiver").to("seda:pvreceiver?waitForTaskToComplete=Never");

		from("seda:pvreceiver?concurrentConsumers=5").bean("pvenrich").multicast()
			.pipeline()
				.bean("kairosprepare")
				.marshal().json(JsonLibrary.Jackson)
				.to("http4://receiver:1880/dbmessages?bridgeEndpoint=true")
				.end()
			.pipeline()
				.bean("aggregateByInstallation")
				.choice()
					.when(body().method("isValid"))
						.marshal().json(JsonLibrary.Jackson)
						.to("http4://receiver:1880/averagemessages?bridgeEndpoint=true")
					.endChoice()
				.end()
			.end();
	}
}
