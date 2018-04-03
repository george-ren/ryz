<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%--
<%@page import="com.piptrade.listener.SessionListener"%> 
<%@page import="com.piptrade.constant.PIPTradeConstant"%>
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
    //save need infomation
	String saleType = (String)request.getSession().getAttribute("adminType");
	String saleName = (String)request.getSession().getAttribute("adminUserName");

	request.getSession().invalidate();
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store"); 
	response.setDateHeader("Expires", -1); 
	response.setHeader("Pragma", "no-cache");
	// set need infomation
	request.getSession().setAttribute("adminType",saleType);
	request.getSession().setAttribute("adminUserName",saleName);

	
	String url="/english/sales/salesAdmin.hyml"+locale+"&language="+language;

--%>

<SCRIPT LANGUAGE="JavaScript">
<!--
	window.location="/english/sales/salesAdmin.hyml" ;
//-->
</SCRIPT>