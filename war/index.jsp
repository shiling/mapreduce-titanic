<%@ page import="java.util.Iterator" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobInfoFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobInfo" %>

<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	Iterator<BlobInfo> blobInfos = new BlobInfoFactory().queryBlobInfos();
	SimpleDateFormat fmt = new SimpleDateFormat("MMM dd yyyy h:mm aaa");
%>

<html>
    <head>
        <title>Titanic Map Reduce</title>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
		<script type="text/javascript" src="/js/jquery.tablesorter.min.js"></script> 
		<script type="text/javascript">
			$(document).ready(function() 
			    { 
			        $("#blobTable").tablesorter({sortList: [[0,1]]}); 
			    } 
			); 
		</script>
    </head>
    <body>
    
        <form action="<%= blobstoreService.createUploadUrl("/index.jsp") %>" method="post" enctype="multipart/form-data">
            Analyse new data: 
            <input type="file" name="myFile">
            <input type="submit" value="Submit">
        </form>
        
        <table border="1" id="blobTable" class="tablesorter">
        	<thead>
        	<tr>
	        	<th>Time Uploaded</th><th>Filename</th><th>Size (KB)</th><th>Actions</th>
	        </tr>
	        </thead>
	        <tbody>
		        <%
		        	while(blobInfos.hasNext()){
		        		BlobInfo blobInfo = blobInfos.next();
		   		%>
		   		<tr>
		   			<td><%=fmt.format(blobInfo.getCreation()) %></td>
		   			<td><%=blobInfo.getFilename() %></td>
		   			<td><%=blobInfo.getSize()/1024%></td>
		   			<td>
					<form action="/process" method="post">
		   				<input type="hidden" name="blobKey" value="<%=blobInfo.getBlobKey().getKeyString()%>"/>
		   				Analyse Death Count By: 
		   				<input type="submit" name="category" value="Passenger Class"/>
		   				<input type="submit" name="category" value="Gender"/>
		   			</form>
		   			</td>
		 		</tr>
		   		<%
		        	}
		        %>
        	</tbody>
        </table>
    </body>
</html>