package de.fsu.datalab.beans;

import java.util.Date;

import javax.inject.Named;

import de.fsu.datalab.model.internal.EnergyData;
import de.fsu.datalab.model.pvreceiver.PvReceiverData;

@Named("pvenrich")
public class EnrichPvReceiverData {
	public EnergyData handle(PvReceiverData message) {
		String station = message.getStation();
		double energy = message.getEnergy();
		String datetime = message.getTime();
		String id = message.getId();
		
		long timestamp = 0;
		if(datetime == null || "".equals(datetime)) {
			timestamp = new Date().getTime();
		} else {
			timestamp = Long.valueOf(datetime);
//			timestamp = DatatypeConverter.parseDateTime(datetime).getTimeInMillis();
		}
		if (station == null || "".equals(station))
			station = "Test";
		
		return new EnergyData(station, id, energy, timestamp);
	}
}
