package mapreduce;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.tools.mapreduce.KeyValue;
import com.google.appengine.tools.mapreduce.MapReduceJob;
import com.google.appengine.tools.mapreduce.MapReduceSettings;
import com.google.appengine.tools.mapreduce.MapReduceSpecification;
import com.google.appengine.tools.mapreduce.Marshallers;
import com.google.appengine.tools.mapreduce.inputs.BlobstoreInput;
import com.google.appengine.tools.mapreduce.outputs.InMemoryOutput;

public class Process extends HttpServlet {
	
    private String blobKey;
    private int category;
    
    public void doPost(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {

    	//get blobkey
        blobKey = req.getParameter("blobKey");
        
        //get category
        String category = req.getParameter("category");
        this.category = category.equals("Passenger Class") ? 1 : category.equals("Gender")? 3 : 1;
        
        //mapreduce
        String pipelineId = mapreduce(10,5);
        
        //response
        res.sendRedirect("/results.jsp?pipelineId="+pipelineId);
    }
    
    //Run Map Reduce 
    private String mapreduce(int mapShardCount, int reduceShardCount) {
        return MapReduceJob.start(
            MapReduceSpecification.of(
                "titanic map reduce",
                new BlobstoreInput(blobKey,(byte)'\n',mapShardCount),
                new CountMapper(category),
                Marshallers.getStringMarshaller(),
                Marshallers.getLongMarshaller(),
                new CountReducer(),
                new InMemoryOutput<KeyValue<String, Long>>(reduceShardCount)), getSettings());
      }
    
    //Configure Map Reduce Settings - Set task queue names for Map Reduce controller and workers.
    private MapReduceSettings getSettings() {
        MapReduceSettings settings = new MapReduceSettings()
            .setWorkerQueueName("mapreduce-workers")
            .setControllerQueueName("default");
        return settings;
      }
    
}


