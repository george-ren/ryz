<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.piptrade.listener.SessionListener"%> 
<%@page import="com.piptrade.constant.PIPTradeConstant"%>

<%
String username=(String)session.getAttribute(PIPTradeConstant.SESSION_KEY_USERNAME);

//boolean flag=SessionListener.isLogined(request.getSession(),username);
String language="english";
String locale="?request_locale=en_US";
String requestURL=request.getHeader("referer");
if(requestURL.indexOf("chinese")>0){
	language="chinese";
	locale="?request_locale=zh_CN";
}else if(requestURL.indexOf("traditional")>0){
	language="traditional";
	locale="?request_locale=zh_TW";
}else if(requestURL.indexOf("arabic")>0){
	language="arabic";
	locale="?request_locale=ar";
}



request.getSession().invalidate();
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store"); 
response.setDateHeader("Expires", -1); 
response.setHeader("Pragma", "no-cache");
String url="/english/sales/login!logout.hyml"+locale+"&language="+language;
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
    
	window.location="<%=url%>"
//-->
</SCRIPT>