<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.piptrade.constant.PIPTradeConstant"%>

<%
String language=request.getParameter("language");
//request.getSession().invalidate();
session.removeAttribute(PIPTradeConstant.SESSION_KEY_USERNAME);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_DEMOMT4);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_LOGINTYPE);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_DEMOMT4);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_WEBTRADETYPE);

session.removeAttribute("fromDomain");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store"); 
response.setDateHeader("Expires", -1); 
response.setHeader("Pragma", "no-cache");

String fromDomain=request.getParameter("fromDomain");
	//session.setAttribute("fromDomain", refererpage);

String url="/"+language+"/login/login.hyml?fromDomain="+fromDomain;
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
	window.location="<%=url%>"
//-->
</SCRIPT>