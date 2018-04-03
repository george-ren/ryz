<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.piptrade.listener.SessionListener"%> 
<%@page import="com.piptrade.constant.PIPTradeConstant"%>
<%@page import="com.piptrade.utils.SpringContextUtil"%>
<%@page import="com.piptrade.model.DealerDesk"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="com.piptrade.service.account.IAccountService"%>
<%@page import="com.piptrade.model.Account"%>
<%@page import="com.piptrade.service.marketerInfo.MarketerInfoService"%>
<%@page import="com.piptrade.model.MarketerInfo"%>
<%@page import="java.util.Date"%>
<%@page import="com.piptrade.utils.logutil.*"%>
<%@page import="java.util.Date"%>
<%@page import="com.piptrade.dao.marketerInfo.*"%>
<%@page import="com.piptrade.service.marketerInfo.*"%>
<%@page import="com.piptrade.utils.*"%>
<%
String username=(String)session.getAttribute(PIPTradeConstant.SESSION_KEY_USERNAME);
        //add by dengkeqin
        Logsentity log = new Logsentity(); 
		Logthread logThread = new Logthread();	
		//end dengkeqin
try{
	
	if(null != username && !"".equals(username.trim())){//找不到username说明session 过期
		Long mid = (Long)request.getSession().getAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID);
		IAccountService accountService=(IAccountService)SpringContextUtil.getBean("accountService");
		Account account=accountService.searchAccountByMarketerId(mid);
		String type = "L";
		int mt4id = 0;
		if(null != account){//如果 not equal null说名是live
			type = "L";
			mt4id = (int)account.getMt4id();
		}else{
			MarketerInfoService marketerService = (MarketerInfoService)SpringContextUtil.getBean("marketerInfoService");
			MarketerInfo marketer = marketerService.searchMarketerByusername(username);
			Integer vid = marketer.getVirtualmt4id();
			if(null != vid && !"".equals(vid)){//如果 not equal null说明是demo
				type = "D";
				mt4id = marketer.getVirtualmt4id();
				if(0==mt4id){
					mt4id=(int)marketer.getMarketerid();
					type="L";
				}
			}
		}

		
		MarketerInfoService marketerInfoService  = (MarketerInfoService)SpringContextUtil.getBean("marketerInfoService");
        MarketerInfo marketerInfo = marketerInfoService.searchMarketerByusername(username);
      //  System.out.println(username+" "+marketerInfo.getMt4id());
          //add by dengkeqin
		//共有日志
		log.setIp(request.getRemoteAddr());
		log.setUserName(username);
		log.setRequesturl(request.getRequestURL().toString());
		log.setPrograme(request.getRequestURL()+"PIPTrade.WebRoot.logouttossl.jsp");
		log.setOpertime(new Date());
		log.setOperation("logout");
		log.setType("General");
		log.setMessage("'<"+username+">': user loginOut [type:webclient]");
		log.setMessageId("LoginOut001");
	 		if(account != null){
				if(account.getMt4id() == 0 || "".equals(account.getMt4id())){	    	    
		    	       log.setAccountNo("");
		    	}else{
		    		   log.setAccountNo(String.valueOf(account.getMt4id()));
		    	}
				}else{
					log.setAccountNo("");
				}
	    logThread.run(log,request);
	//end dengkeqin
	}
 }catch(Exception e){
	 e.printStackTrace();
 }


String requestURL=request.getHeader("referer");
String language="english";
if(null!=requestURL){
	if(requestURL.indexOf("chinese")>0){
		language="chinese";
	}else if(requestURL.indexOf("traditional")>0){
		language="traditional";
	}else if(requestURL.indexOf("arabic")>0){
		language="arabic";
	}else if(requestURL.indexOf("russian")>0){
	    language="russian";
	}else if(requestURL.indexOf("australia")>0){
		 language="australia";
	}
}else{
  if(session.getAttribute("lanname") != null){
  if(session.getAttribute("lanname").equals("chinese")){
		language="chinese";
	}else if(session.getAttribute("lanname").equals("traditional")){
		language="traditional";
	}else if(session.getAttribute("lanname").equals("arabic")){
		language="arabic";
	}else if(session.getAttribute("lanname").equals("russian")){
	    language="russian";
	}else if(session.getAttribute("lanname").equals("australia")){
		 language="australia";
  }  
}
}

if(null!=request.getParameter("chineseLan")){
	if("chinese".equals(request.getParameter("chineseLan"))){
		language="chinese";
	}
}
//request.getSession().invalidate();
String fromDomain="http://"+request.getServerName();	
String url="/logout.jsp?language="+language+"&fromDomain="+fromDomain;
if(null != username && !"".equals(username.trim())){


session.removeAttribute(PIPTradeConstant.SESSION_KEY_USERNAME);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_LOGINTYPE);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_DEMOMT4);
session.removeAttribute(PIPTradeConstant.SESSION_KEY_WEBTRADETYPE);
//contest
session.removeAttribute(PIPTradeConstant.S_K_GROUPNAME_STATUS);
session.removeAttribute(PIPTradeConstant.S_K_CONTEST_NEW);
session.removeAttribute(PIPTradeConstant.S_K_CONTEST_DEMOGN);
session.removeAttribute(PIPTradeConstant.S_K_RANK_NUM);
session.removeAttribute("expriedStatus");
boolean flag=SessionListener.Logout(request.getSession(),username);

response.setHeader("Cache-Control", "no-cache");
response.setHeader("Cache-Control", "no-store"); 
response.setDateHeader("Expires", -1); 
response.setHeader("Pragma", "no-cache");

}
System.out.println("logout url is:"+url);


String domain1=request.getServerName();	
//System.out.println("domain111 is:"+domain1);
//String lanname = "english";
//System.out.println("ssslogin.jsp111 lanname is:"+lanname);
//if(session.getAttribute("lanname")!=null&&!"".equals(session.getAttribute("lanname").toString())){
//	lanname=session.getAttribute("lanname").toString();
//}
if(domain1.indexOf("127.0.0.1")>-1 || domain1.indexOf("w1")>-1 || domain1.indexOf("w3")>-1 || domain1.indexOf("v2")>-1){  
	url= "https://"+request.getServerName()+ "/"+language+"/login/login.hyml";
	System.out.println("lservername:"+request.getServerName());
}
System.out.println("logout url is:"+url);
%>

<SCRIPT LANGUAGE="JavaScript">
<!--
	window.location="<%=url%>"
//-->
</SCRIPT>