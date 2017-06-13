package de.fsu.datalab.model.kairosdb;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "metric")
@XmlAccessorType(XmlAccessType.FIELD)
public class Metric {
	@XmlElement(name = "name")
	private String name;
	@XmlElement(name = "value")
	private double value;
	@XmlElement(name = "time")
	private long time;
	@XmlElement(name = "tags")
	private Tags tags;
	@XmlElement(name = "id")
	private String id;

	public Metric() {
	}
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}

	public double getValue() {
		return value;
	}

	public void setValue(double value) {
		this.value = value;
	}

	public long getTime() {
		return time;
	}

	public void setTime(long time) {
		this.time = time;
	}

	public Tags getTags() {
		return tags;
	}
	
	public void setTags(Tags tags) {
		this.tags = tags;
	}
	
	public static void main(String[] args) throws Exception {
        JAXBContext context = JAXBContext.newInstance(Metric.class);
        Marshaller marshaller = context.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

        Metric mt = new Metric();
        mt.setTags(new Tags("test"));;

        marshaller.marshal(mt, System.out); 
    }

}
