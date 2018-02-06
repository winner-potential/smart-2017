/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package fsu.wdl.processors.customProcessor;

import org.apache.commons.io.IOUtils;
import org.apache.nifi.components.PropertyDescriptor;
import org.apache.nifi.components.PropertyValue;
import org.apache.nifi.flowfile.FlowFile;
import org.apache.nifi.processor.*;
import org.apache.nifi.processor.io.OutputStreamCallback;
import org.apache.nifi.annotation.behavior.ReadsAttribute;
import org.apache.nifi.annotation.behavior.ReadsAttributes;
import org.apache.nifi.annotation.behavior.WritesAttribute;
import org.apache.nifi.annotation.behavior.WritesAttributes;
import org.apache.nifi.annotation.lifecycle.OnScheduled;
import org.apache.nifi.annotation.documentation.CapabilityDescription;
import org.apache.nifi.annotation.documentation.SeeAlso;
import org.apache.nifi.annotation.documentation.Tags;
import org.apache.nifi.processor.exception.ProcessException;
import org.apache.nifi.processor.util.StandardValidators;

import java.util.*;
import java.io.IOException;
import java.io.OutputStream;

@Tags({"Aggregator"})
@CapabilityDescription("Aggregate specific values over specific time")
@SeeAlso({})
@ReadsAttributes({@ReadsAttribute(attribute="", description="")})
@WritesAttributes({@WritesAttribute(attribute="", description="")})
public class MyProcessor extends AbstractProcessor {

    public static final PropertyDescriptor Interval = new PropertyDescriptor
            .Builder().name("Interval")
            .description("Interval for caching messages and calculating average on them")
            .required(true)
            .addValidator(StandardValidators.NON_EMPTY_VALIDATOR)
            .build();

    public static final PropertyDescriptor DataField = new PropertyDescriptor
            .Builder().name("DataField")
            .description("Name of the attribute that should be aggregated")
            .required(true)
            .addValidator(StandardValidators.NON_EMPTY_VALIDATOR)
            .build();

    public static final Relationship REL_SUCCESS = new Relationship.Builder()
            .name("success")
            .description("Successfully aggregated")
            .build();
    
    public static final Relationship REL_FAILURE = new Relationship.Builder()
            .name("failure")
            .description("Failed to aggregate")
            .build();

    private List<PropertyDescriptor> descriptors;

    private Set<Relationship> relationships;

    
    private HashMap<Long,Double> measurements = new HashMap<Long, Double>();
    private String fieldToAggregate = "";
    private long interval = 0;
    
    @Override
    protected void init(final ProcessorInitializationContext context) {
        final List<PropertyDescriptor> descriptors = new ArrayList<PropertyDescriptor>();
        descriptors.add(Interval);
        descriptors.add(DataField);
        
        this.descriptors = Collections.unmodifiableList(descriptors);

        final Set<Relationship> temprelationships = new HashSet<Relationship>();
        temprelationships.add(REL_SUCCESS);
        temprelationships.add(REL_FAILURE);
        this.relationships = Collections.unmodifiableSet(temprelationships);
    }

    @Override
    public Set<Relationship> getRelationships() {
        return this.relationships;
    }

    @Override
    public final List<PropertyDescriptor> getSupportedPropertyDescriptors() {
        return descriptors;
    }

    @OnScheduled
    public void onScheduled(final ProcessContext context) {
        fieldToAggregate = context.getProperty(DataField).getValue();
        interval = context.getProperty(Interval).asLong();
    }

    @Override
    public void onTrigger(final ProcessContext context, final ProcessSession session) throws ProcessException {
        FlowFile flowFile = session.get();
        if ( flowFile == null ) {
            return;
        }
        
        try
        {
            String rawtime  = flowFile.getAttribute("time");
            String rawvalue = flowFile.getAttribute(fieldToAggregate);
            long timevalue          = Long.parseLong(rawtime);
            Double measurementvalue = Double.parseDouble(rawvalue);
            
            
            if(rawtime != null && rawvalue != null){
                if(timevalue >= System.currentTimeMillis()-interval){
                    measurements.put(timevalue,measurementvalue);
                }
            }
            Double avg = 0.0;
            long counter = 0;
            for (Map.Entry<Long, Double> entry : measurements.entrySet()) {
                long timeentry = entry.getKey();
                Double valueentry = entry.getValue();
                if(timeentry >= System.currentTimeMillis()-interval){
                    counter++;
                    avg = avg + valueentry;
                }else{
                    measurements.remove(timeentry);
                }
            }
            
            final Double avginner = avg/counter;
//            FlowFile output = session.write(flowFile, new OutputStreamCallback(){
//            @Override
//            public void process(OutputStream outputStream) throws IOException {
//                if(avginner.isNaN()){
//                    IOUtils.write("NaN", outputStream, "UTF-8");
//                }else{
//                    IOUtils.write(String.valueOf(avginner), outputStream, "UTF-8");
//                }
//            }
//            });
            if(avginner.isNaN()){
                flowFile = session.putAttribute(flowFile, fieldToAggregate, "NaN");
            }else{
                flowFile = session.putAttribute(flowFile, fieldToAggregate, String.valueOf(avginner));
            }
            
            session.transfer(flowFile, REL_SUCCESS);
        } catch (ProcessException e){
            getLogger().error("Unable to aggregate on flowFile with time"+flowFile.getAttribute("time"));
            session.transfer(flowFile, REL_FAILURE);
        }
//        try 
//        {
//            //Read in Data
//            InputStream stream = session.read(flowFile);
//            String csv = IOUtils.toString(stream, "UTF-8");
//            stream.close();
//            
//            //Convert CSV data to JSON
//            List<Map<?,?>> objects = this.readObjectsFromCsv(csv);
//            
//            //Convert to JSON String
//            String json = this.writeAsJson(objects);
//            
//            //Output Flowfile
//            FlowFile output = session.write(flowFile, new OutputStreamCallback(){
//                @Override
//                public void process(OutputStream outputStream) throws IOException {
//                    IOUtils.write(json, outputStream, "UTF-8");
//                }
//            });
//            output = session.putAttribute(output, CoreAttributes.MIME_TYPE.key(), APPLICATION_JSON);
//            
//            output = session.putAttribute(output, CoreAttributes.FILENAME.key(), UUID.randomUUID().toString()+".json");
//            session.transfer(output, REL_SUCCESS);
//        } catch (IOException e) {
//            getLogger().error("Unable to process Change CSV to JSON for this file "+flowFile.getAttributes().get(CoreAttributes.FILENAME));
//            session.transfer(flowFile, REL_FAILURE);
//        }
    }
}
