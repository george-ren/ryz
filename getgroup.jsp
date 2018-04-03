<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.piptrade.constant.PIPTradeConstant"%>
<%@page import="com.piptrade.admin.grouptype.manager.GroupTypeManager"%> 

<%@page import="com.piptrade.model.AccountGroupType"%>
<%@page import="com.piptrade.utils.SpringContextUtil"%>    
<%@page import="javax.servlet.http.HttpServletRequest"%>   
<%@page import="org.apache.struts2.ServletActionContext"%>
<%@page import="java.util.List"%>
<%

String AffiliateCode ="";
String language ="en";
String tem="";
String str="";
String tem1="";
String str1="";
if(null!=request.getParameter("language")){
	language=request.getParameter("language");
}
 
 System.out.println("getgroup.jsp language is:"+language);
try{
   
	if(null!=request.getParameter("utm_affiliatecode")){
		AffiliateCode=request.getParameter("utm_affiliatecode");
	}else{
		if(null!=session.getAttribute("AFFILIATE_CODE")){
			AffiliateCode=(String)session.getAttribute("AFFILIATE_CODE");
		}
		if(null==AffiliateCode || AffiliateCode.equals("")){
			Cookie [] cookies=null;
			if(null!=request.getCookies()){
				cookies = request.getCookies();
			}
			
	   	
	   	  if(cookies!=null && cookies.length>0){
	   		  for (int i=0;i<cookies.length;i++){
	   			 if(cookies[i].getName().equalsIgnoreCase("AFFILIATE_CODE")){
	   				AffiliateCode=cookies[i].getValue();
	   			 }
	   		  }    		  
			}
		}
	}
	if(null==AffiliateCode || AffiliateCode.equals("")){
		AffiliateCode="HYM";
	}
	
	GroupTypeManager groupManager=(GroupTypeManager) SpringContextUtil.getBean("groupManager");
	List list = null;

		list = groupManager.getGroupTypeByPlatform(AffiliateCode,"webtrader");

		for (int i =0; i<list.size(); i++) {
			AccountGroupType accountGroupType=(AccountGroupType)list.get(i);
			//System.out.println("getgroup.jsp accountGroupType is:"+accountGroupType.getGroupName());
			if(language.equalsIgnoreCase("cn")){
				tem=tem+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getZh_CN_Description()+"</option>";	
			}else if(language.equalsIgnoreCase("tr")){
				tem=tem+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getZh_TW_Description()+"</option>";	
			}else if(language.equalsIgnoreCase("ar")){
				tem=tem+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getEn_Description()+"</option>";	
			}else if(language.equalsIgnoreCase("ru")){
				tem=tem+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getRu_Description()+"</option>";	
			}else{
				tem=tem+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getEn_Description()+"</option>";	
			}
			
			
		}
		
		List list1 = null;

		list1 = groupManager.getGroupTypeByPlatform(AffiliateCode,"hyt4");

		for (int i =0; i<list1.size(); i++) {
			AccountGroupType accountGroupType=(AccountGroupType)list1.get(i);
			//System.out.println("getgroup.jsp accountGroupType is:"+accountGroupType.getGroupName());
			if(language.equalsIgnoreCase("cn")){
				tem1=tem1+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getZh_CN_Description()+"</option>";	
			}else if(language.equalsIgnoreCase("tr")){
				tem1=tem1+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getZh_TW_Description()+"</option>";	
			}else if(language.equalsIgnoreCase("ar")){
				tem1=tem1+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getEn_Description()+"</option>";	
			}else if(language.equalsIgnoreCase("ru")){
				tem1=tem1+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getRu_Description()+"</option>";	
			}else{
				tem1=tem1+"<option value="+accountGroupType.getAccountType()+">"+accountGroupType.getEn_Description()+"</option>";	
			}
		}

	 }catch(Exception e){
			e.printStackTrace();
		}
		 str="<select name='web_accounttype'  style='display: block;' id='web' onmouseover='FixWidth(this)'>"+tem+"</select>";
		 str1="<select name='mt4_accounttype'  style='display:none;' id='mt4' onmouseover='FixWidth(this)'>"+tem1+"</select>";
%>
<%=str+str1%>