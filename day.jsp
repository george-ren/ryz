<%@ page language="java" contentType="text/html;charset=UTF-8"%> 
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@page import="com.piptrade.utils.SpringContextUtil"%>
<%@page import="java.io.File"%>
<%@page import="com.piptrade.utils.FileReader"%>
<%@page import="com.piptrade.service.account.IAccountService"%>
<%@page import="com.piptrade.model.Account"%>
<%@page import="com.piptrade.constant.PIPTradeConstant"%>
<%@page import="com.piptrade.utils.logutil.*"%>
<%@page import="java.util.Date"%>
<%@page import="com.piptrade.model.MarketerInfo"%>
<%@page import="com.piptrade.dao.marketerInfo.*"%>
<%@page import="com.piptrade.service.marketerInfo.*"%>
<%@page import="com.piptrade.utils.*"%>
<html>
<%
long mid=0;
long mt4id=0;
String lanname = "english";
String newReg ="";
String lastday="";
String close="Close";
String c="NO DATA !";
        MarketerInfoService marketerInfoService  = (MarketerInfoService)SpringContextUtil.getBean("marketerInfoService");
        
     	String iflogin = "true";
        if(null==request.getSession().getAttribute(PIPTradeConstant.SESSION_KEY_USERNAME)||"".equals(request.getSession().getAttribute(PIPTradeConstant.SESSION_KEY_USERNAME))){
        	iflogin = "false";
        	
        }else{
        	 String username = (String)request.getSession().getAttribute(PIPTradeConstant.SESSION_KEY_USERNAME);
             MarketerInfo marketerInfo = marketerInfoService.searchMarketerByusername(username);
          //   System.out.println(username+" "+marketerInfo.getMt4id());
             //add by dengkeqin
             Logsentity log = new Logsentity(); 
     		Logthread logThread = new Logthread();	
     		System.out.println(request.getRemoteAddr());
     		log.setIp(request.getRemoteAddr());
     		log.setUserName(username);
     		log.setRequesturl(request.getRequestURL().toString());
     	 	log.setPrograme(request.getRequestURL()+" [ver:<PIPTrade.WebRoot.day.jsp>]");
     	 	log.setOpertime(new Date());
     	 	log.setOperation("Statement");
     	 	//end dengkeqin
     		 lanname = (String) session.getAttribute("lanname");
     	 	
     //lanname="chinese";
     if(null!=session.getAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID)){
     	mid=(Long)session.getAttribute(PIPTradeConstant.SESSION_KEY_MARKETERID);
     }
     System.out.println("mid is:"+mid);
     IAccountService accountService=(IAccountService)SpringContextUtil.getBean("accountService");

     Account account=accountService.searchAccountByMarketerId(mid);
       //add by dengkeqin
     			if(account != null){
     				if(account.getMt4id() == 0 || "".equals(account.getMt4id())){	    	    
     		    	       log.setAccountNo("");
     		    	}else{
     		    		   log.setAccountNo(String.valueOf(account.getMt4id()));
     		    	}
     				}else{
     					log.setAccountNo("");
     				}
                  //add by dengkeqin
     	 newReg = request.getParameter("newReg");//用户判断图片

     if(null!=account){
     	mt4id=account.getMt4id();
     }
     //System.out.println("mt4id is:"+mt4id);

     String day=request.getParameter("day");
     //System.out.println("day is:"+day);
     if(mid != 0){
     //add by dengkeqin
        log.setType("Report");
        log.setMessage("'<"+username+">': statement review [date:<"+day+">, type:webclient]");
        log.setMessageId("Statements001");
        logThread.run(log,request);
        //end dengkeqin
     }else{
     //add by dengkeqin
        log.setType("error");
        log.setMessage("'<"+username+">': statement not available  [date:<"+day+">, type:webclient]");
        log.setMessageId("Statements002");
        logThread.run(log,request);
        //end dengkeqin
     }

     day=day.replace("-", "");
     String path=day+".daily"+File.separator+mt4id+"_mail.htm";
     FtpUtil ftputil=new FtpUtil();
      c=ftputil.filereadremote(path);
     if(null==c||c.length()==0){
     	c="NO DATA !";
     	if(lanname.equals("english")){
     		c="NO DATA!";
     	}else if(lanname.equals("chinese") ){
     		c="没有数据!";
     	}else if(lanname.equals("traditional")){
     		c="沒有數據!";
     	}else if(lanname.equals("arabic")){
     		c="ا توجد بيانات";
     	}
     	else if(lanname.equals("russian")){
     		c="НЕТ ДАННЫХ";
     	}
     	
     }
      close="Close";
     String copy="";
     if(lanname.equals("english") ){
     	close="Close";
     }else if(lanname.equals("chinese") ){
     	close="关闭";
     	
     }else if(lanname.equals("traditional")){
     	close="關閉";
     }
     else if(lanname.equals("arabic")){
     	close="إغلاق";
     }else if(lanname.equals("russian")){
     	close="закрывать";
     }
        }
       
%>
<head>
<title><s:text name="hyinvestment.statement.Statements"></s:text></title>
<style type="text/css">
.copyright{
	line-height: 120%;
    margin-bottom: 15px;
    font-size: 11px;
    text-align: center;
}
</style>
</head>
<script type="text/javascript">

	var iflogin = "<%=iflogin%>";
	if(iflogin=="false"){
		if(null==window.opener){
			window.location.href="<%=lanname%>/login/login.hyml";
		}else{
			window.opener.location.href="<%=lanname%>/login/login.hyml";
		}
		window.close();
	}
	
var mid="<%=mid%>";
if(mid==0){
window.close();
}

	function wclose(){
	//window.opener   =   "meizz";  
  	window.close();
  }
</script>
<body>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="48" bgcolor="#FFFFFF" class="news_line2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>
        	<%if(null!=newReg && "1".equals(newReg)){ %>
        	<img src="/pipmt4/${lanname}/images/head_logo.gif"  hspace="10">
        	<%}else{ %>
        	<img src="/${lanname}/images/logo_webtop.gif"  hspace="10">
        	<%} %>
        </td>
        <td width="50" class="text_12"><a href="#" onclick="wclose()" ><%=close %></a></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td align="center" bgcolor="#FFFFFF" >
<span class="text_14"><%=c %></span></td>
  </tr>

  <tr>
    <td height="25" align="center" bgcolor="#D4D4D4" class="text_11"><span id="spanYear" class="copyright"></span></td>
  </tr>
</table>
<script type="text/javascript">

  	var date = new Date();
  	var year = date.getFullYear();
  	var month = date.getMonth()+1;
  	var day =
  	
 	var jsLan= "<%=lanname%>";
	
 	var copyRight="COPYRIGHT© "+year+" - HY Markets, the trading name of Henyep Capital Markets (UK) Limited. ALL RIGHTS RESERVED"; 
 	if(jsLan=="chinese"){
 		copyRight="COPYRIGHT© "+year+" - 兴业市场是兴业资本市场（英国）有限公司的交易名称。版权所有"; 
 		copyRight+="英国伦敦EC2N 2AN，思罗克英顿大街28号3楼";
 	}else if(jsLan=="english"){
 		copyRight="COPYRIGHT© "+year+" - HY Markets, the trading name of Henyep Capital Markets (UK) Limited. ALL RIGHTS RESERVED"; 
 		copyRight+="<br/>HY Markets,3rd Floor 28 Throgmorton Street, London EC2N 2AN, United Kingdom ";
 	}else if(jsLan=="arabic"){
 		 copyRight="حقوق الطبع © "+ year+ " - اتش واي ماركتس. جميع الحقوق محفوظة.";
 		 copyRight+="الطابق الثالث, 28 شارع ثروغمورتون, لندن EC2N 2AN المملكة المتحدة. ";
 	}else if(jsLan=="traditional"){
 		copyRight="COPYRIGHT© "+year+" - 興業市場是興業資本市場（英國）有限公司的交易名稱。版權所有";
 		copyRight+="英國倫敦EC2N 2AN，思羅克英頓大街28號3樓";
 	}else if(jsLan=="russian"){
 		copyRight="COPYRIGHT© "+year+" - HY Markets, название торговой марки Henyep Capital Markets (UK) Limited. ВСЕ ПРАВА ЗАЩИЩЕНЫ";
 		copyRight+="HY Markets,Великобритания,Лондон EC2N 2AN, ул. Трогмортон 28, 3-й этаж";
 	}
 	
 		document.getElementById("spanYear").innerHTML=copyRight;
</script>
</body>
<!--DO NOT REMOVE baijs -->
<script type="text/javascript" src="<%=request.getContextPath()%>/js/global.js"></script>

<!--DO NOT REMOVE baijs -->
</html>