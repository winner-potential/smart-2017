package de.fsu.datalab.model.kairosdb;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "tags")
@XmlAccessorType(XmlAccessType.FIELD)
public class Tags {
	@XmlElement(name = "station")
	private String station;

	public Tags() {
	}

	public Tags(String station) {
		super();
		this.station = station;
	}

	public String getStation() {
		return station;
	}

	public void setStation(String station) {
		this.station = station;
	}
}
