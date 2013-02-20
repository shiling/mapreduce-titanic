package mapreduce;

import com.google.appengine.tools.mapreduce.KeyValue;
import com.google.appengine.tools.mapreduce.Reducer;
import com.google.appengine.tools.mapreduce.ReducerInput;

import java.util.logging.Logger;

class CountReducer extends Reducer<String, Long, KeyValue<String, Long>> {
	private static final long serialVersionUID = 1316637485625852869L;

	@SuppressWarnings("unused")
	private static final Logger log = Logger.getLogger(CountReducer.class
			.getName());

	public CountReducer() {
	}

	private void emit(String key, long outValue) {
		getContext().emit(KeyValue.of(key, outValue));
	}

	@Override
	public void reduce(String key, ReducerInput<Long> values) {
		long total = 0;
		while (values.hasNext()) {
			long value = values.next();
			total += value;
		}
		emit(key, total);
	}

}
