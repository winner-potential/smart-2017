package de.fsu.datalab.model.pvreceiver;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "pvreceiver")
@XmlAccessorType(XmlAccessType.FIELD)
public class PvReceiverData {
	@XmlElement(name = "station")
	private String station;
	@XmlElement(name = "energy")
	private double energy;
	@XmlElement(name = "time")
	private String time;
	@XmlElement(name = "id")
	private String id;

	public PvReceiverData() {
	}

	public PvReceiverData(String station, double energy, String time) {
		this.station = station;
		this.energy = energy;
		this.time = time;
	}
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}

	public String getStation() {
		return station;
	}

	public void setStation(String station) {
		this.station = station;
	}

	public double getEnergy() {
		return energy;
	}

	public void setEnergy(double energy) {
		this.energy = energy;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}
}
