<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
			request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">

		$(function (){

			//设置当前页面始终为顶层窗口
			if (window.top != window){
				window.top.location = window.location;
			}

			//页面加载完毕后，清空用户文本框
			$("#loginAct").val("");

			//页面加载完毕后，让用户的文本框自动获得焦点
			$("#email").focus();

			//登录按钮绑定事件，进行登陆操作
			$("#registerBtn").click(function (){
				register();
			})

			//键盘的回车键绑定事件，进行登陆操作
			$(window).keydown(function (){
				if (event.keyCode ==13){
					register();
				}
			})
		})

		//注册方法
		function register(){

			//账号，密码不能为空
			//$.trim():去掉文本中的左右空格
			var exp = /^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
			var email = $.trim($("#email").val());
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			var reLoginPwd = $.trim($("#reLoginPwd").val());

			if (!exp.test(email)){
				$("#msg").html("邮箱格式不正确");
				return false;
			}

			if (loginAct == "" || loginPwd == ""){
				$("#msg").html("账号密码不能为空");
				return false;
			}
			if (loginPwd.length < 6 || loginPwd.length >16){
				$("#msg").html("请输入6-16位的字符串作为密码");
				return false;
			}
			if (reLoginPwd == ""){
				$("#msg").html("请再次输入确认密码");
				return false;
			}

			if (loginPwd != reLoginPwd){
				$("#msg").html("两次密码输入不一致");
				return false;
			}

			$.ajax({

				url:"settings/user/register.do",
				data :{
					"email":email,
					"loginAct":loginAct,
					"loginPwd":loginPwd
				},
				type:"post",
				dataType : "json",
				success :function (data){

					/**
					 * data:传过来的数据json
					 * {"success":true/false  , "msg":"错误的种类"}
					 */
					if (data.success){

						var time=5;
						var timer=setInterval(function(){
							if(time==0){
								window.location.href = "login.jsp";
							}else{
								$("#msg").html(data.msg);
								time--;
							}
						},1000)

					} else {
						$("#msg").html(data.msg);
					}
				}
			})

		}
	</script>
</head>
<body>
	<div style="position: absolute; top: 150px; right: 100px;width:450px;height:400px;">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1 >注册</h1>
			</div>
			<form action="login.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="注册邮箱" id="email">
					</div>
					<br/>
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码(6-16位组成，区分大小写)" id="loginPwd">
					</div>
					<br/>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="确认密码" id="reLoginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: #c7254e"></span>
						
					</div>
					<button type="button" id="registerBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">注册</button>
				</div>
			</form>

		</div>
	</div>
</body>
</html>