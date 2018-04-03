<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.piptrade.model.MarketerInfo"%>
<%@page import="com.piptrade.service.marketerInfo.MarketerInfoService"%>
<%@page import="com.piptrade.utils.SpringContextUtil"%>
<%@page import="com.piptrade.utils.ip.ipLookupCity"%>
<%@page import="com.piptrade.utils.FileUtils"%>
<%@page import="com.piptrade.admin.iplist.service.BlackListIPService"%>
<%@page import="com.piptrade.constant.PIPTradeConstant"%>
<%@page import="com.piptrade.service.account.IAccountService"%>
<%@page import="com.piptrade.model.Account"%>

<%@page import="com.piptrade.action.marketerInfo.LoginThread"%>
<%@page import="com.piptrade.model.TblSflogin"%>
<%@page import="com.piptrade.admin.country.manager.CountryManager"%>
<%@page import="com.piptrade.listener.SessionListener"%>
<%@page import="com.piptrade.utils.DesEncrypter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="com.piptrade.utils.logutil.*"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	
	String accounttype =request.getParameter("acctype");
//	System.out.println(accounttype+"进来了"+basePath);
	String version_lang="/chinese";//版本
	String ipgo ="";
	String returnUrl ="";//最终跳转的页面
	String info_flag = "";//错误信息
	MarketerInfo marketerInfo=null;
	
	
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	String requestURL = request.getParameter("requestURL");
	//add by dengkeqin
		Logsentity log = new Logsentity(); 
		Logthread logThread = new Logthread();
			Account accountmt4 =null;
		// return null;
		//共有日志
	
		log.setIp(request.getRemoteAddr());
		log.setUserName(username);
		log.setRequesturl(request.getRequestURL().toString());
	 	log.setPrograme(request.getRequestURL()+" [ver:<HYMarket.WebRoot.loginPro.jsp>]");
	 	log.setOpertime(new Date());
	 	log.setOperation("login");
	 	log.setLanguage("chinese");
	    //end dengkeqin
	//System.out.println("mingzi:"+username+"mima:"+password+"url:"+requestURL);
	BlackListIPService blipMan = (BlackListIPService) SpringContextUtil.getBean("blackListIpService");
	MarketerInfoService marketerInfoService = (MarketerInfoService) SpringContextUtil.getBean("marketerInfoService");
	CountryManager countryManager = (CountryManager) SpringContextUtil.getBean("countryManager");
	
	try{
		 marketerInfo=marketerInfoService.searchMarketerByusername(username);
		 //add by dengkeqin
		IAccountService accountServicemt4=(IAccountService)SpringContextUtil.getBean("accountService");
		if(marketerInfo != null){
		    accountmt4=accountServicemt4.searchAccountByMarketerId(marketerInfo.getMarketerid());
		}
			  		if(accountmt4 != null){
			  			request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_MT4ID, accountmt4.getMt4id());
				if(accountmt4.getMt4id() == 0 || "".equals(accountmt4.getMt4id())){	    	    
		    	       log.setAccountNo("");
		    	}else{
		    		   log.setAccountNo(String.valueOf(accountmt4.getMt4id()));
		    	}
				}else{
					log.setAccountNo("");
				}
		//end dengkeqin
	}catch (Exception se){
		se.printStackTrace();
	}
	if(marketerInfo!=null){
	    	
	   if(password.equals(marketerInfo.getPassword())){
	    		
    		String logs="ip is:"+request.getRemoteHost()+",username is:"+username+",mid is:"+marketerInfo.getMarketerid()+",ua is:"+request.getHeader("User-Agent");
    		FileUtils.writeFileToLocalDisk(logs, "login");
    		
    		String platform="0";
    		String Overduetime="";
    		String DemoExpiredDate="Y";
    		String DemoExpiredDateNum="";
    		try{
    		if(marketerInfo.getTrust()==0){
    			
    			String[] sIpCity = ipLookupCity.cityLookup(request.getRemoteHost());
    			if(sIpCity!=null){
    				/*
    				if(sIpCity[0]!=null && sIpCity[0].equals("United States")){   //IP限制 美国
    					//ipgo="../ip_us.html";
    					//add by dengkeqin
		    					log.setType("error");
		    			    	log.setMessage("user:"+username+",vercode:  ,this  city is United States");
		    			    	log.setMessageId("Login006");
		    			    	logThread.run(log,request);
		    			    	//end dengkeqin
    					returnUrl= version_lang+"/ip_us.html";
    					//response.sendRedirect(ipgo);
    					///return null;
    				}else 
    					*/
    					if(sIpCity[0]!=null && sIpCity[0].equals("Nigeria")){  //IP限制 尼日利亚
    					//ipgo= "../ip_ug.html";
    					//add by dengkeqin		     
		    					log.setType("error");
		    			    	log.setMessage("user:"+username+",vercode:  ,this  city is Nigeria");
		    			    	log.setMessageId("Login006");
		    			    	logThread.run(log,request);
		    			    	//end dengkeqin
    					returnUrl= version_lang+ "/ip_us.html";
    				///	response.sendRedirect(ipgo);
    					///return null;
    				}
    			}
    			
    			if(blipMan.findByIp(request.getRemoteHost())!=null){    //IP黑名单
    				//ipgo="../ip_blacklist.html";
    				//add by dengkeqin      
		    				log.setType("error");
		    				log.setMessage("user: "+username+" ,vercode:  ,this ip is black ip");
		    		    	log.setMessageId("Login006");
		    		    	logThread.run(log,request);
		    		    	//end dengkeqin
    				returnUrl= version_lang+"/ip_blacklist.html";
    				///response.sendRedirect(ipgo);
    				//getResponse().sendRedirect("/english/ip.jsp?country=blacklist");
		    		///return null;
		    	}
    			
    		}else{
    			if(blipMan.findByIp(request.getRemoteHost())!=null){      //IP黑名单
    				//ipgo="../ip_blacklist.html";
    				//add by dengkeqin		     
		    				log.setType("error");
		    				log.setMessage("user: "+username+" ,vercode:  ,this ip is black ip");
		    		    	log.setMessageId("Login006");
		    		    	logThread.run(log,request);
		    		    	//end dengkeqin
    				returnUrl= version_lang+"/ip_blacklist.html";
    				//response.sendRedirect(ipgo);
    				//getResponse().sendRedirect("/english/ip.jsp?country=blacklist");
		    		///return null;
		    	}
    		}
    		
    		
    		if(null!=marketerInfo.getStatus()){
    			if(marketerInfo.getStatus().equalsIgnoreCase("Illegal")){      //用户状态被限制
    			//add by dengkeqin	     
		    				log.setType("error");
		    		    	log.setMessage("user: "+username+" ,vercode:  ,the user's status is Illegal");
		    		    	log.setMessageId("Login007");
		    		    	logThread.run(log,request);
		    		    	//end dengkeqin
    				info_flag ="4";
    		    	returnUrl = version_lang+"/login/login.hyml?info_flag=4";   		    	
    				request.setAttribute("flag", "4");
    				request.getSession().setAttribute("flag", "4");
		    		///return "input";
    			}
    			if(marketerInfo.getStatus().equalsIgnoreCase("closed")){   //用户状态被限制
    			//add by dengkeqin 		          
		    				log.setType("error");
		    		    	log.setMessage("user: "+username+" ,vercode:  ,the user's status is closed");
		    		    	log.setMessageId("Login007");
		    		    	logThread.run(log,request);
		    		    	//end dengkeqin
    				info_flag ="5";
    		    	returnUrl = version_lang+"/login/login.hyml?info_flag=5";
    				request.setAttribute("flag", "5");
    				request.getSession().setAttribute("flag", "5");
		    		///return "input";
    			}
    		}
	    		
	    		
	    		if(null!=marketerInfo.getPlatform()){
	    	//		System.out.println("dologin marketerInfo.getPlatform() is:"+marketerInfo.getPlatform());
	    			platform=marketerInfo.getPlatform().toString();
	    			
	    			if(platform.equalsIgnoreCase("-1")){
	    				platform="1";
	    			}
	    			
	    		}
	    		//platform="1";
	    	//	System.out.println("dologin platform is:"+platform);
	    		request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_PLATFORM, platform);
	    		request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_DEMOEXPIREDDATE, "N");
	    		DemoExpiredDate="N";
	    		IAccountService accountService=(IAccountService)SpringContextUtil.getBean("accountService");
	
	    		Account account=accountService.searchAccountByMarketerId(marketerInfo.getMarketerid());
	
	    		 Overduetime=marketerInfo.getOverduetime().getTime()+"";
	    	//	System.out.println("dologin Overduetime is:"+Overduetime);
	    		request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_DEMOEXPIREDDATENUM, Overduetime);
	    		DemoExpiredDateNum=Overduetime;
	    		if(null!=account){
	
	    		}else{
	    			
	    			if(null!=marketerInfo.getDemoaccounttype() && marketerInfo.getDemoaccounttype()>0 ){
		    			Date now=new Date();
		    			//long regtime=0;
		    		
		    			if(null!=marketerInfo.getOverduetime()){
		    			
		    			if(now.getTime()>marketerInfo.getOverduetime().getTime()){
		    				request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_USERNAME, username);
		    				request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID, marketerInfo.getMarketerid());
				    		
		    				request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_DEMOEXPIREDDATE, "Y");
		    				DemoExpiredDate="Y";
				    		String language="&language=";
							if(request.getHeader("referer").indexOf("chinese")>0){
								language="&language=chinese";
							}else if(request.getHeader("referer").indexOf("traditional")>0){
								language="&language=traditional";
							}else if(request.getHeader("referer").indexOf("arabic")>0){
								language="&language=arabic";
							}else if(request.getHeader("referer").indexOf("russian")>0){
								language="&language=russian";
							}
							
							request.getSession().setAttribute("requestURL", requestURL);
							request.getSession().setAttribute("ssllanguage", language);   //用户帐号过期
							//add by dengkeqin
								log.setType("login");
								log.setMessage("user: "+username+" ,vercode:  ,login success");
						    	log.setMessageId("Login001");
						    	log.setLogin(true);//表示登录成功
						    	logThread.run(log,request);
						    	//end dengkeqin
							//info_flag ="expired";
				    		//returnUrl = "/expiredtowww.jsp";
				    		
		    				///return "expired";
		    			}
		    			}
		    		}
	    			
	    		}
	    		
	    		boolean flag=SessionListener.iswwwLogined(request.getSession(),username);
	    		request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_USERNAME, username);
	    		request.getSession().setAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID, marketerInfo.getMarketerid());
	    		//选择的登录类型
	    		if(null!=accounttype&&!"".equals(accounttype)){
	    			request.getSession().setAttribute("acctype", accounttype);
	    			session.setAttribute(PIPTradeConstant.SESSION_KEY_LOGINTYPE, accounttype);
	    	//		System.out.println(request.getSession().getAttribute("acctype")+"--------------------------------acctype-------------");
	    		}
	    		
	    		String cname=countryManager.getCountryInfoByCode(marketerInfo.getCountry(), "en");
	    		request.getSession().setAttribute("Reidence", cname);
	    	
	    		
	    		
	    		if(null!=marketerInfo.getSleadid()){
		    		TblSflogin sFLoginDTO=new TblSflogin();
		    		sFLoginDTO.setLeadid(marketerInfo.getSleadid());
		    		sFLoginDTO.setFromsite("PIPTrade>>>"+request.getRemoteHost());
		    		sFLoginDTO.setLastlogintime(new Date());
		    		LoginThread thread=new LoginThread(sFLoginDTO);
		    		thread.start();
	    		}
	    		String language="&language=";
				if(request.getHeader("referer").indexOf("chinese")>0){
					language="&language=chinese";
				}else if(request.getHeader("referer").indexOf("traditional")>0){
					language="&language=traditional";
				}else if(request.getHeader("referer").indexOf("arabic")>0){
					language="&language=arabic";
				}else if(request.getHeader("referer").indexOf("russian")>0){
					language="&language=russian";
				}
				
				request.getSession().setAttribute("requestURL", requestURL);
				request.getSession().setAttribute("ssllanguage", language);
				
				String type = "L";
				int mt4id = 0;
				if(null!=account){
					type = "L";
					mt4id = (int)account.getMt4id();
				}else if(null != marketerInfo.getVirtualmt4id()){
					type = "D";
					mt4id = marketerInfo.getVirtualmt4id();
					if(0 == mt4id){
						mt4id = (int)marketerInfo.getMarketerid();
						type="L";
					}
				}else{
					mt4id = (int)marketerInfo.getMarketerid();
					type="L";
				}
				//WriteLogThread thread = new WriteLogThread("login",marketerInfo.getUsername(),type,mt4id,request.getRemoteAddr());
				//thread.start();
				//add by bini end
	    	}catch(Exception e){
				e.printStackTrace();
			}
				///return "success";
			//判断成功了
			//add by dengkeqin
		    	log.setMessage("user: "+username+" ,vercode:  ,login success");
		    	log.setMessageId("Login001");
		    	log.setLogin(true);//表示登录成功
		    	log.setType("login"); 
		    	logThread.run(log,request);
		    	//end dengkeqin
			String domain1="http://"+request.getServerName();	
			String domain="https://secure.piptrade.com";
			if(domain1.indexOf("127.0.0.1")>-1 || domain1.indexOf("localhost")>-1 || domain1.indexOf("test")>-1){  
				domain="";
			}
			
			
			username=DesEncrypter.getBASE64(username);
			username=username.replaceAll("\n","");
			System.out.println("loginpro.jsp username is:"+username);
			
	    	returnUrl =domain+"/window_loginSecuritydirect.jsp?DemoExpiredDateNum="+DemoExpiredDateNum+"&DemoExpiredDate="+DemoExpiredDate+"&fromdomain="+domain1+"&platform="+platform+"&username="+username+"&marketerId="+marketerInfo.getMarketerid();
	    	System.out.println(returnUrl);
	    	}else{           //密码错误
	    	     //add by dengkeqin
	    			log.setAccountNo("");
		    		log.setType("error");
			    	log.setMessage("'"+username+"':"+"invalid password [group:<"+marketerInfo.getGroupname()+">, type:webclient]");
			    	log.setMessageId("Login003");
			    	logThread.run(log,request);
			    	//end dengkeqin
	    		request.setAttribute("flag", "3");
	    		request.getSession().setAttribute("flag", "3");
	    		info_flag ="3";
	    		returnUrl =version_lang+"/login/login.hyml?info_flag=3";
	    	}
	    	
	    }else{                          //用户名不存在
	    //add by dengkeqin
	        log.setAccountNo("");
		    log.setType("error");
		    log.setMessage("user:"+username+" ,vercode: ,the username is wrong [type:webclient]");
		    log.setMessageId("Login002");
		    logThread.run(log,request);	
		    //end dengkeqin
	    	request.setAttribute("flag", "2");
	    	request.getSession().setAttribute("flag", "2");
	    	info_flag ="2";
	    	returnUrl = version_lang+"/login/login.hyml?info_flag=2";
	    	///return "input";
	   }

//System.out.println("loginpro.jsp returnUrl:"+returnUrl);
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
	System.out.println("test date >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
}
%>

<script type="text/javascript">
window.open ('/chinese/pop_rmb.html', '', 'width=350,height=222,top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes,location=no, status=no');
window.parent.location.href="<%=returnUrl%>"; 
if("1"=="<%=timeflag%>"){
window.open ('/chinese/sdown.html', 'newwindow', 'width=695,height=475,top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no');
}
</script>
