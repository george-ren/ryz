<%@page language = "java" contentType="text/html;charset=UTF-8"%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.piptrade.constant.PIPTradeConstant"%>

<%
	
	String lanname="english";
	String platform="0";
	String domain="http://www.hymarkets.com";
	String requestURL=null;
   if(null!=request.getSession().getAttribute("lanname")){
	  lanname=request.getSession().getAttribute("lanname").toString();
	}
	if(null!=request.getSession().getAttribute("")){
		requestURL = (String)session.getAttribute("requestURL");	
	}
	if(null!=session.getAttribute("fromDomain")){
		domain=(String)session.getAttribute("fromDomain");
	}
	if(domain.indexOf("http")<0){
		domain="http://"+domain;
	}
	if(null!=session.getAttribute(PIPTradeConstant.SESSION_KEY_PLATFORM)){
		platform=session.getAttribute(PIPTradeConstant.SESSION_KEY_PLATFORM).toString();	
	}
	
	String logintype=(String)session.getAttribute(PIPTradeConstant.SESSION_KEY_LOGINTYPE);
	//String url="/flashtrader/FlashTrader.jsp?language="+lanname;
	String url="/"+lanname+"/webtools.html";
	String domain1=request.getServerName();	
	if(domain1.indexOf("127.0.0.1")>-1 || domain1.indexOf("localhost")>-1){  
		url="/"+lanname+"/webtools.html";
		if(null!=requestURL && !requestURL.equalsIgnoreCase("null") && (requestURL.trim()).length()>0){
			url=requestURL;
		}
	}
	if(null!=request.getSession().getAttribute("expriedStatus")){
		if("expried".equals(request.getSession().getAttribute("expriedStatus"))){
			url="/"+lanname+"/accounts_demo_expired.html";
		}
	}
	Object objContest = request.getSession().getAttribute("GROUPSTATUS");
	System.out.println("-----------objContest----------"+objContest);
	if(null!=objContest&&!"".equals(objContest)){
		url="/event/contest/"+lanname+"/index.html";
	}
	url=url.replaceAll("\n","");
	System.out.println("-----2------0000--loginSecurity.jsp url is:"+url);
	Date now=new Date();
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	java.util.Date start = df.parse("2011-08-19 05:00:00");
	java.util.Date end=df.parse("2011-08-19 08:00:00");
	long l=now.getTime();
	long startl=start.getTime();
	long endl=end.getTime();
	String timeflag="0";
	if(l>startl && l<endl){
		timeflag="1";
		if(platform.equalsIgnoreCase("1")){
			timeflag="2";
		}
	}
%>
<SCRIPT LANGUAGE="JavaScript">
if("arabic"!="<%=lanname%>" && "russian"!="<%=lanname%>"){
//window.open ('/<%=lanname%>/pop_rmb.html', 'newwindow2', 'width=350,height=222,top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes,location=no, status=no');
}
	if("1"=="<%=timeflag%>"){
	window.open ('/<%=lanname%>/sdown.html', 'newwindow', 'width=695,height=475,top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no');
	}

	window.location="<%=url%>"

</SCRIPT>