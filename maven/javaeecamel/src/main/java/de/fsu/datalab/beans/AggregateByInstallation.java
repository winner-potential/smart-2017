package de.fsu.datalab.beans;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.inject.Named;
import javax.inject.Singleton;

import de.fsu.datalab.model.internal.EnergyData;

@Named("aggregateByInstallation")
@Singleton
public class AggregateByInstallation {
	private static final long timeout = 10000;
	private Map<String, List<EnergyData>> history;
	
	public EnergyData mean(EnergyData data) {
		List<EnergyData> list = getList(data.getStation());
		
		synchronized (list) {
			list.add(data);
			Date date = new Date();
			long now = date.getTime();
			double overall = 0;
			for(Iterator<EnergyData> it = list.iterator(); it.hasNext(); ) {
				EnergyData next = it.next();
				if(next.getTime() < now - timeout) {
			        it.remove();
		        } else {
		        	overall += next.getEnergy();
		        }
		    }
			return new EnergyData(data.getStation(), data.getId(), list.size() > 0 ? overall / list.size() : Double.NaN, now);
		}
	}

	private List<EnergyData> getList(String station) {
		if(history == null) {
			init();
		}
		List<EnergyData> list = history.get(station);
		if(list == null) {
			synchronized (history) {
				list = history.get(station);
				if(list == null) {
					list = new LinkedList<>();
					history.put(station, list);
				}
			}
		}
		return list;
	}

	private synchronized void init() {
		if(this.history != null) {
			return;
		}
		history = new HashMap<>();
	}
}
