<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.piptrade.listener.SessionListener"%> 
<%@page import="com.piptrade.utils.DesEncrypter"%>
<%@page import="com.piptrade.constant.PIPTradeConstant"%>
<%
	String language ="english";
	
	if(null!=request.getParameter("language")){
		language =request.getParameter("language");
	}
	if(language.equals("")){
		language ="english";
	}
	String marketerId=request.getParameter("marketerId");
	marketerId=DesEncrypter.getFromBASE64(marketerId);
	System.out.println("marketerId  is:"+marketerId);
	String username=request.getParameter("username");
	System.out.println("username is:"+username);
	username=DesEncrypter.getFromBASE64(username);
	System.out.println("username  is:"+username);
	//boolean flag=SessionListener.isLogined(request.getSession(),username);
	//System.out.println("login.jsp  flag is:"+flag);

	session.setAttribute(PIPTradeConstant.SESSION_KEY_USERNAME, username);
	session.setAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID, Long.valueOf(marketerId));
	System.out.println("logindirect mid  is:"+marketerId);
	if(null!=session.getAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID)){
		System.out.println("logindirect is null mid  is:"+marketerId);
	}
	String midd=((Long)session.getAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID)).toString();
	System.out.println("logindirect midd  is:"+midd);
	
	String DemoExpiredDateNum=request.getParameter("DemoExpiredDateNum");
	System.out.println("expirefroms DemoExpiredDateNum is:"+DemoExpiredDateNum);
	session.setAttribute(PIPTradeConstant.SESSION_KEY_DEMOEXPIREDDATENUM, DemoExpiredDateNum);
	//long midl=(Long)session.getAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID);
	//System.out.println("logindirect midl  is:"+midd);
	
	String platform=request.getParameter("platform");
	System.out.println("expirefroms platform is:"+platform);
	
	String[] name = {"username", "marketerId"};
		String[] value = {username, marketerId};
		Cookie[] cookies = request.getCookies();
		
			int length = name.length;
		boolean[] hasCookie = new boolean[length];
		for(int i=0; i<length; i++){
			hasCookie[i] = false;
		}
		Cookie acookie = null;
		if (cookies != null && cookies.length > 0) {
			for (int i = 0; i < cookies.length; i++) {
				for(int j=0; j<length; j++){
					if(cookies[i].getName().equalsIgnoreCase(name[j])){
						hasCookie[j]=true;
						cookies[i].setPath("/");
						cookies[i].setValue(java.net.URLEncoder.encode(value[j]));
						cookies[i].setMaxAge(60 * 60 * 24 * 60);
						response.addCookie(cookies[i]);
					}
				}				
			}
		}
		for(int i=0; i<length; i++){
			if(!hasCookie[i]){
				acookie = new Cookie(name[i], java.net.URLEncoder.encode(value[i]));
				acookie.setPath("/");
				acookie.setMaxAge(60 * 60 * 24 * 60);
				response.addCookie(acookie);
			}
		}
		String url="/"+language+"/accounts_demo_expired.html";
		//去掉mt4demo过期跳转,统一为webtrade跳转
		//if(platform.equalsIgnoreCase("1")){
		//	url="/pipmt4/"+language+"/register_democ.html";
		//}
		if(null!=request.getParameter("requestURL") && (request.getParameter("requestURL").trim()).length()>0){
			url=request.getParameter("requestURL");
		}
		
		//System.out.println("login.jsp Session loginID is:"+request.getSession().getAttribute("loginID"));

		System.out.println("login.jsp url is:"+url);
		response.sendRedirect(url);
%>
