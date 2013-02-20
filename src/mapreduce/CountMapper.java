package mapreduce;

import com.google.appengine.tools.mapreduce.Mapper;

import java.util.logging.Level;
import java.util.logging.Logger;

class CountMapper extends Mapper<byte[], String, Long> {
  private static final long serialVersionUID = 4973057382538885270L;

  @SuppressWarnings("unused")
  private static final Logger log = Logger.getLogger(CountMapper.class.getName());
  private int category;
  
  public CountMapper(int category) {
	  this.category = category;
  }

  private void emit(String outKey, long outValue) {
    getContext().emit(outKey, outValue);
  }

  private void emit1(String outKey) {
    emit(outKey, 1);
  }

  @Override public void map(byte[] input) {
    String record = new String(input);
    String[] fields = record.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");	//split csv record into fields
    String key = fields[category] + "-" + (fields[0].equals("0")?"Died":"Survived");
    emit1(key);
  }

}
