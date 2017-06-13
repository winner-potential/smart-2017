package de.fsu.datalab.beans;

import javax.inject.Named;

import de.fsu.datalab.model.internal.EnergyData;
import de.fsu.datalab.model.kairosdb.Metric;
import de.fsu.datalab.model.kairosdb.Tags;

@Named("kairosprepare")
public class KairosDbPrepare {
	public Metric prepare(EnergyData message) {
		Metric metric = new Metric();
		metric.setName("pvenergy");
		metric.setId(message.getId());
		metric.setValue(message.getEnergy());
		metric.setTime(message.getTime());
		metric.setTags(new Tags(message.getStation()));
		return metric;
	}
}
