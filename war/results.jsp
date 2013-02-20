<%@ page import="com.google.appengine.tools.pipeline.JobInfo" %>
<%@ page import="com.google.appengine.tools.pipeline.PipelineService" %>
<%@ page import="com.google.appengine.tools.pipeline.PipelineServiceFactory" %>
<%@ page import="com.google.appengine.tools.mapreduce.impl.ResultAndCounters" %>
<%@ page import="com.google.appengine.tools.mapreduce.KeyValue" %>
<%@ page import="com.google.common.collect.ImmutableList" %>

<%
	PipelineService pipelineService = PipelineServiceFactory.newPipelineService();
	JobInfo jobInfo = pipelineService.getJobInfo(request.getParameter("pipelineId"));
	String pipelineStatusUrl = "/_ah/pipeline/status.html?root=" + request.getParameter("pipelineId");
%>

<html>
	<head><title>Map Reduce Results</title></head>
	<body>
	<h1>Map Reduce Output</h1>
	
	<%
		ResultAndCounters output = (ResultAndCounters)jobInfo.getOutput();
		if(output==null){
			out.println("Output is not ready. Refresh the page when the map reduce job is complete.");
		}else{
			out.println("<table border='1'><tr><th>Category</th><th>Count</th></tr>");
			ImmutableList level1 = (ImmutableList) output.getOutputResult();
			for(Object l2: level1){
				ImmutableList<KeyValue<String,Long>> level2 = (ImmutableList<KeyValue<String,Long>>) l2;
				for(KeyValue<String,Long> keyValuePair: level2){
					out.println("<tr><td>"+keyValuePair.getKey()+"</td><td>"+keyValuePair.getValue()+"</td></tr>");
				}
			}
			out.println("</table>");
		}
	%>
	
	<h1>Map Reduce Job Status</h1>
	<iframe src="<%=pipelineStatusUrl%>" height="500" width="1000" seamless="seamless"></iframe>
	
	</body>
</html>