<%@page language = "java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.piptrade.listener.SessionListener"%> 
<%@page import="com.piptrade.utils.DesEncrypter"%>
<%@page import="com.piptrade.constant.PIPTradeConstant"%>
<%@page import="com.piptrade.utils.SpringContextUtil"%>
<%@page import="com.piptrade.model.AccountGroupType"%>
<%@page import="com.piptrade.model.MarketerInfo"%>
<%@page import="com.piptrade.service.marketerInfo.MarketerInfoService"%>
<%@page import="com.piptrade.admin.grouptype.manager.GroupTypeManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>


<%
	String language ="english";

	if(null!=request.getParameter("language")){
		language =request.getParameter("language");
	}
	if(language.equals("") || language.trim().length()==0){
		language ="english";
	}
	
	System.out.println("language  is:"+language);
	String marketerId=request.getParameter("marketerId");
	marketerId=DesEncrypter.getFromBASE64(marketerId);
	System.out.println("marketerId  is:"+marketerId);
	String username=request.getParameter("username");
	System.out.println("username is:"+username);
	username=DesEncrypter.getFromBASE64(username);
	System.out.println("username  is:"+username);
	boolean flag=SessionListener.iswwwLogined(request.getSession(),username);
	System.out.println("login.jsp  flag is:"+flag);
	
	String platform=request.getParameter("platform");
	System.out.println("platform is:"+platform);
	String DemoExpiredDate=request.getParameter("DemoExpiredDate");
	System.out.println("DemoExpiredDate is:"+DemoExpiredDate);
	
	String DemoExpiredDateNum=request.getParameter("DemoExpiredDateNum");
	System.out.println("DemoExpiredDateNum is:"+DemoExpiredDateNum);
	
	String logintype=request.getParameter("logintype");
	System.out.println("logintype is:"+logintype);
	System.out.println("login_mt4 is:"+request.getParameter("login_mt4"));
	if(null!=request.getParameter("login_mt4")){
		session.setAttribute(PIPTradeConstant.SESSION_KEY_MT4ID, new Long(1));
	}
	
	try { 
		
		session.setAttribute(PIPTradeConstant.SESSION_KEY_PLATFORM, platform);
		session.setAttribute(PIPTradeConstant.SESSION_KEY_LOGINTYPE, logintype);
	session.setAttribute(PIPTradeConstant.SESSION_KEY_USERNAME, username);
	session.setAttribute(PIPTradeConstant.SESSION_KEY_DEMOEXPIREDDATE, DemoExpiredDate);
	session.setAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID, Long.valueOf(marketerId));
	session.setAttribute(PIPTradeConstant.SESSION_KEY_DEMOEXPIREDDATENUM, DemoExpiredDateNum);
	System.out.println("logindirect mid  is:"+marketerId);
	 } 
    catch (Exception ex){
   	 
   	 ex.printStackTrace();
    } 
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
		//String url=language+"/english/webtrader/tradeCenter.hyml";
		String url="/"+language+"/webtrader/tradeCenter.hyml";
if(logintype.indexOf("web")<0){
		if(platform.equalsIgnoreCase("1")){
			url="/"+language+"/webtools.html";
		}
}
		MarketerInfoService marketerInfoService=(MarketerInfoService)SpringContextUtil.getBean("marketerInfoService");

		MarketerInfo marketerInfo=marketerInfoService.searchMarketerByusername(username);

		GroupTypeManager groupManager=(GroupTypeManager)SpringContextUtil.getBean("groupManager");

		AccountGroupType group =groupManager.serachAccountGroupTypeByAccountTypeCode(marketerInfo.getAccounttype());
		String groupname="";
		
		if(null!=group){
			groupname=group.getGroupName();
		}
		

		if(groupname.indexOf("PIP-Contest-D")>-1 || groupname.indexOf("TPT-Contest-Ds")>-1){
			url="/chinese/account_dasai_home.html";
		}
		if(groupname.indexOf("PIP-Contest-W")>-1 || groupname.indexOf("TPT-Contest-Ws")>-1){
			url="/chinese/webtrader/tradeCenter.hyml";
		}
		if(null!=request.getParameter("requestURL") && (request.getParameter("requestURL").trim()).length()>0){
			url=request.getParameter("requestURL");
		}
		
		//System.out.println("login.jsp Session loginID is:"+request.getSession().getAttribute("loginID"));

		System.out.println("login.jsp url is:"+url);
		
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
			if(platform.equalsIgnoreCase("1")){
				timeflag="2";
			}
		}
		
		//response.sendRedirect(url);
%>
<script type="text/javascript">

if("1"=="<%=timeflag%>"){
window.open ('/<%=language%>/sdown.html', 'newwindow', 'width=695,height=475,top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no');
}
//if("2"=="<%=timeflag%>"){
//window.open ('/pipmt4/<%=language%>/sdown.html', 'newwindow', 'width=695,height=475,top=0, left=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes,location=no, status=no');
//}
window.location="<%=url%>"
</script>