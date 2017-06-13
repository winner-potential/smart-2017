package de.fsu.datalab.model.internal;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "energy")
@XmlAccessorType(XmlAccessType.FIELD)
public class EnergyData {
	@XmlElement(name = "station")
	private String station;
	@XmlElement(name = "id")
	private String id;
	@XmlElement(name = "energy")
	private double energy;
	@XmlElement(name = "time")
	private long time;

	public EnergyData() {
	}

	public EnergyData(String station, String id, double energy, long time) {
		this.station = station;
		this.id = id;
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

	public long getTime() {
		return time;
	}

	public void setTime(long time) {
		this.time = time;
	}
	
	public boolean isValid() {
		return !Double.isNaN(this.energy);
	}

	@Override
	public String toString() {
		return "EnergyData [station=" + station + ", energy=" + energy + ", time=" + time + "]";
	}
}
