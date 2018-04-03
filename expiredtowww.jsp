<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.piptrade.utils.DesEncrypter"%>
<%@page import="com.piptrade.constant.PIPTradeConstant"%>
<%@page import="java.util.Date"%>

<%
	String language="";
	if(null!=session.getAttribute("ssllanguage")){
		language =(String)session.getAttribute("ssllanguage");
	}

	String marketerId=((Long)session.getAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID)).toString();
	marketerId=DesEncrypter.getBASE64(marketerId);
	String username=(String)session.getAttribute(PIPTradeConstant.SESSION_KEY_USERNAME);
	System.out.println("username first______"+username);
	username=DesEncrypter.getBASE64(username);
	String platform="";
if(null!=session.getAttribute(PIPTradeConstant.SESSION_KEY_PLATFORM)){
	platform=session.getAttribute(PIPTradeConstant.SESSION_KEY_PLATFORM).toString();
}
	
	String requestURL=(String)session.getAttribute("requestURL");		
	String parm="";

	if(null!=requestURL&&!"null".equals(requestURL)&&!"".equals(requestURL)){
		parm=parm+"&requestURL="+requestURL;
	}
	
String fromDomain=(String)session.getAttribute("fromDomain");
	
Date now=new Date();
String DemoExpiredDateNum=now.getTime()+"";

if(null!=session.getAttribute(PIPTradeConstant.SESSION_KEY_DEMOEXPIREDDATENUM)){
	DemoExpiredDateNum=(String)session.getAttribute(PIPTradeConstant.SESSION_KEY_DEMOEXPIREDDATENUM);
}

	String url=fromDomain+"/expiredfroms.jsp?DemoExpiredDateNum="+DemoExpiredDateNum+"&platform="+platform+"&username="+username+"&marketerId="+marketerId+"&firstname="+parm+language;	
	
	
	String domain1=request.getServerName();	

	String lanname = (String) session.getAttribute("lanname");
	
	if(domain1.indexOf("w1.hymarkets.com")>-1 || domain1.indexOf("127.0.0.1")>-1 || domain1.indexOf("localhost")>-1 || domain1.indexOf("test")>-1){  
		
		
		url="http://"+domain1+"/expiredfroms.jsp?DemoExpiredDateNum="+DemoExpiredDateNum+"&platform="+platform+"&username="+username+"&marketerId="+marketerId+"&firstname="+parm+language;	
	}
	System.out.println(fromDomain+"----ww.jsp---------------url-"+url);
	response.sendRedirect(url);		
	
%>
<SCRIPT LANGUAGE="JavaScript">
	var trimUrl= "<%=url%>"; 
	window.location= trimUrl.replace("\\n","");

</SCRIPT>
<form name="myform">

</form>
