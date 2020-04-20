<%@ page import="cn.linkey.factory.BeanCtx,cn.linkey.dao.Rdb,cn.linkey.util.Tools,cn.linkey.doc.Document,java.util.*" %>
<%@page errorPage="../error.jsp"%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8"%> 

<%
String sqlTableName="BPM_RuleList";
String checked="",sql,checkStr="";;
String docunid=BeanCtx.g("wf_docunid",true);
String elid=BeanCtx.g("wf_elid");
if(Tools.isNotBlank(elid)){
	sql="select * from "+sqlTableName+" where RuleNum='"+elid+"'";
}else{
	sql="select * from "+sqlTableName+" where WF_OrUnid='"+docunid+"'";
}
Document eldoc=Rdb.getDocumentBySql(sqlTableName,sql); //得到rule文档数据
elid=eldoc.g("RuleNum"); //id编号
docunid=eldoc.g("WF_OrUnid");//文档unid
if(eldoc.isNull()){
		BeanCtx.showErrorMsg(response,"Error : Could not find the rule! WF_OrUnid="+docunid);
		BeanCtx.close();
		return;
}
%>
<!DOCTYPE html><html><head><title>Rule Attribute</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!--insert-->
<%String designerHtmlHeader=Rdb.getValueBySql("select ConfigValue from BPM_SystemConfig where Configid='DesignerHtmlHeader'"); %>
<%=designerHtmlHeader%>
<!--insert end-->
<!--#<link rel="stylesheet" type="text/css" href="../linkey/bpm/easyui/themes/gray/easyui.css">#-->
<!--#<link rel="stylesheet" type="text/css" href="../linkey/bpm/easyui/themes/icon.css">#-->
<!--#<link rel="stylesheet" type="text/css" href="../linkey/bpm/css/app_openform.css">#-->
<script type="text/javascript" src="../linkey/bpm/easyui/jquery.min.js"></script>
<script type="text/javascript" src="../linkey/bpm/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../linkey/bpm/jscode/sharefunction.js"></script>
<script type="text/javascript" src="../linkey/bpm/jscode/app_openform.js"></script>
<script>
function formonload(){
    //表单打开时执行
    
}

function formonsubmit(){
    //return false表示退出提交

}

$(function(){
	if($("#RuleNum").val()==""){
		$("#RuleNum").val("R_"+$('#WF_Appid').val()+"_0");
	}
})

$.extend($.fn.validatebox.defaults.rules, {
		elementid : {// 验证RuleNum有没有重复
			validator : function(v) {
						var vflag=false;
						$.ajax({
						type : "post", 
						url : "../rule?wf_num=R_S001_B005",
						data : {WF_OrUnid:'<%=docunid%>',WF_TableName:'BPM_RuleList',WF_TableColName:'RuleNum',WF_Elid:v}, 
          				async : false, 
          				success : function(data){vflag=data.Status;} 
          				});
          				return vflag;
			},
			message : 'duplicate RuleNum!'
		}
});

function serializeForm(){
	//统一的序列化表单方法
	var formData=$("form").serialize();
	var checkBoxData=getNoCheckedBoxValue();
	if(checkBoxData!=""){
		formData+="&"+checkBoxData;
	}
	return formData;
}

function SaveDocument(btnAction){
	mask();
	$('#linkeyform').form({
    	url:'../rule?wf_num=R_S001_B002',
    	onSubmit: function(param){
    		setNoCheckedBoxValue(param);
    		param.WF_TableName="BPM_RuleList";
    		param.WF_Action=btnAction;
    		var isValid = $(this).form('validate');
			if (isValid){
				var r=formonsubmit();
				if(r==false){
					unmask();
					return false;
				}
			}else{
				unmask();
				return false;
			}
    	},
    	success:function(data){
    		try{
    			unmask();
        		var data = eval('(' + data + ')');
        		if(data.Status=="error"){
        			unmask();
        			alert(data.msg);
        		}
        	}catch(e){unmask();alert(data);}
    	}
	});
	$('#linkeyform').submit();
}

function PreviewView(){
	alert("Java Bean不支持预览!");
}

</script>
</head>
<body style="margin:1px;overflow:hidden" >
<form method='post' id="linkeyform" style="padding:5px" >
<fieldset style="padding:5px" ><legend>JavaBean基本属性</legend>
<table id="mytable" class="linkeytable" border="0" cellspacing="1" cellpadding="2" width="100%"><tbody>
<tr valign="top"><td valign="middle" width="21%" align="right">所属应用:</td><td width="79%">
<%=cn.linkey.app.AppUtil.getAppSelected(eldoc.g("WF_Appid"),false)%>
</td></tr>

<tr><td valign="middle" width="21%" align="right">JavaBean名称:</td>
<td width="79%"><input value="<%=eldoc.g("RuleName")%>"  class="easyui-validatebox" required name="RuleName" size="60"/></td>
</tr>

<tr><td valign="middle" width="21%" align="right">类名称(英文字母):</td>
<td width="79%"><input value="<%=elid%>" name="RuleNum" id="RuleNum" class="easyui-validatebox" validType='elementid' required size="60"/></td>
</tr>

<tr><td valign="middle" width="21%" align="right">规则类型:</td>
<td width="79%">
<%=eldoc.g("RuleType")%>
</td>
</tr>

<tr><td valign="middle" width="21%" align="right">类路径:</td>
<td width="79%"><input value="<%=eldoc.g("ClassPath")%>" name="ClassPath" id="ClassPath" validType='Servletid' size='60' style="border:none" /></td>
</tr>

<tr><td width="21%">可选项:</td>
<td width="79%">
<% if(eldoc.g("Singleton").equals("1") || Tools.isBlank(eldoc.g("Singleton")) || eldoc.isNewDoc()){checked="checked";}else{checked="";} %>
<input class="lschk" name="Singleton" value="1" <%=checked%> type="checkbox"/>单例类

<% 
	if(eldoc.g("WF_NoUpdate").equals("1")){checked="checked";}else{checked="";} 
%>
<input class="lschk" name="WF_NoUpdate" value="1" <%=checked%> type="checkbox"/>禁止升级本设计 

</td></tr>


<tr valign="top"><td valign="middle" width="21%" align="right">版本:</td>
<%
String version=eldoc.g("WF_Version");
if(Tools.isBlank(version)){version="8.0";}
%>
<td width="79%"><input value="<%=version%>" name="WF_Version" size="20" required="true" class="easyui-validatebox" /></td>
</tr>

</tbody></table><br/>
<%
	BeanCtx.close();
%>
<!-- Hidden Field Begin--><div style='display:none'>
<input name='WF_DocUnid' id="WF_DocUnid" value="<%=docunid%>" ><!-- 表单的docunid-->
</div><!-- Hidden Field End-->
</fieldset></form></body></html>
