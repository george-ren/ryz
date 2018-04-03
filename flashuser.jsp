<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.piptrade.listener.SessionListener"%> 
<%@page import="java.util.*"%> 
<%
String loginID=request.getParameter("username");

System.out.println("flashuser.jsp username is:"+loginID);
System.out.println("flashuser.jsp username is:"+session.getAttribute("USER_NAME"));
boolean Flag=false;

//Map map = SessionListener.hUserName; 
//Iterator iter = map.entrySet().iterator(); 
//while (iter.hasNext()) { 
//    Map.Entry entry = (Map.Entry) iter.next(); 
//    Object key = entry.getKey(); 
//    Object val = entry.getValue(); 
//    System.out.println("flashuser.jsp old key is:"+key);
//    System.out.println("flashuser.jsp old val is:"+val);
//} 


if(null!=request.getParameter("username")){
	Flag=SessionListener.isLogin(null,loginID);
}

//Iterator iter1 = map.entrySet().iterator(); 
//while (iter.hasNext()) { 
//    Map.Entry entry = (Map.Entry) iter1.next(); 
//    Object key = entry.getKey(); 
//    Object val = entry.getValue(); 
//    System.out.println("flashuser.jsp new key is:"+key);
//    System.out.println("flashuser.jsp new val is:"+val);
//} 
//Object mid=session.getAttribute("loginID");

//if(null!=mid)
//{
//	Flag=true;
//}

%>
<%=Flag%>