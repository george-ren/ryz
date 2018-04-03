<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.piptrade.service.marketerInfo.MarketerInfoService"%>
<%@page import="com.piptrade.utils.SpringContextUtil"%>
<%@page import="java.io.PrintWriter"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
MarketerInfoService marketerInfoService = (MarketerInfoService) SpringContextUtil.getBean("marketerInfoService");

response.setContentType("application/json");//这个一定要加

  // response.setHeader("Cache-Control", "no-cache");
	
	try
	{
		StringBuffer sb = new StringBuffer();
		sb.append("{");
		if("yes".equalsIgnoreCase(request.getParameter("ifCode"))){
			String scode=request.getSession().getAttribute("imagesCode").toString();
			sb.append("code:'"+scode+"'");
		}else{
			String username=request.getParameter("username");
			if(!marketerInfoService.validateName(username)){
				sb.append("username:"+1);
			}else{
				sb.append("username:"+0);
			}
		}
		sb.append("}");
		String jsoncallback=request.getParameter("jsoncallback");
		String str=jsoncallback+"(" + sb.toString() + ")";
		
		out.print(str);
	}catch(Exception e)
	{
		throw e;
	}finally
	{
		
	}
	
	

%>

