<%@page import="com.piptrade.constant.PIPTradeConstant"%>
<%@page import="com.piptrade.service.marketerInfo.MarketerInfoService"%> 
<%@page import="com.piptrade.service.account.IAccountService"%> 
<%@page import="com.piptrade.model.MarketerInfo"%>
<%@page import="com.piptrade.model.Account"%>
<%@page import="com.piptrade.utils.SpringContextUtil"%>    
<%@page import="javax.servlet.http.HttpServletRequest"%>   
<%@page import="org.apache.struts2.ServletActionContext"%>
<%
try{
    MarketerInfoService marketerService = (MarketerInfoService)SpringContextUtil.getBean("marketerInfoService");
	IAccountService accountServicemt4=(IAccountService)SpringContextUtil.getBean("accountService");
	String username=(String)session.getAttribute(PIPTradeConstant.SESSION_KEY_USERNAME);
	String loginType=(String)session.getAttribute(PIPTradeConstant.SESSION_KEY_LOGINTYPE);
	 String contest = null;
	  if(session.getAttribute("GROUPSTATUS") != null){
	    System.out.println("goto_webtrader.jsp GROUPSTATUS is:"+session.getAttribute("GROUPSTATUS"));
      contest=(String)session.getAttribute("GROUPSTATUS");
    }
	MarketerInfo marketer = null;
	Account accountmt4= null ;
	if(username!= null){         
	 	 marketer = marketerService.searchMarketerByusername(username);
	}
	String language = "english";
	if(request.getParameter("language") != null){
	     language = request.getParameter("language");
	}else if(session.getAttribute("lanname") != null){
	  language = (String)session.getAttribute("lanname");
	}
	if(marketer != null){
	 accountmt4 = accountServicemt4.searchAccountByMarketerId(marketer.getMarketerid());
	 if(contest != null && (loginType.equals("webdemo") || loginType.equals("mt4demo")) ){
		 
		 System.out.println("goto_webtrader.jsp language is:"+language);
		 if(language.equalsIgnoreCase("traditional") || language.equalsIgnoreCase("russian")){
			 language = "english";
		 }
		 
	 response.sendRedirect("/event/contest/"+language+"/index.html");
	 }else if(accountmt4 != null && accountmt4.getMt4id() != 0 || marketer.getStatus().equals("Pre_Register") || loginType.equals("webdemo") || loginType.equals("mt4demo")){
	response.sendRedirect("/flashtrader/FlashTrader.jsp?language="+language);
	}else{
	response.sendRedirect("/"+language+"/deposit_choose.html");
	}
	}else{
	response.sendRedirect("/"+language+"/reg/reg.hyml");
	}
	 }catch(Exception e){
			e.printStackTrace();
		}
				
%>
