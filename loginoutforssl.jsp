<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.piptrade.listener.SessionListener"%> 
<%@page import="com.piptrade.constant.PIPTradeConstant"%>

<%
String language=request.getParameter("language");
//request.getSession().invalidate();
session.removeAttribute(PIPTradeConstant.SESSION_KEY_USERNAME);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID);
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store"); 
response.setDateHeader("Expires", -1); 
response.setHeader("Pragma", "no-cache");
String fromDomain="http://"+request.getServerName();	
String url="https://secure.piptrade.com/"+language+"/login/login.hyml?fromDomain="+fromDomain;
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
	window.location="<%=url%>"
//-->
</SCRIPT>