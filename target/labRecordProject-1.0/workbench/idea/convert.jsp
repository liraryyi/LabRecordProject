<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<style type="text/css">
		body {
			font-family: Calibri;
			background-color: #f0f0f0;
			padding: 0em 1em;
			overflow-x:hidden;
		}
	</style>

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//为转换按钮绑定一个事件，点击产生一个plan
		$("#convertBtn").click(function (){

			$.ajax({

				url:"workbench/plan/savePlan.do",
				data :{

					"name":$.trim($("#planName").val()),
					"loginAct":$("#planLoginAct").val(),
					"group":$("#"),
					"startDate":$("#planStartDate").val(),
					"endDate":$("#planEndDate").val(),
					"description":$.trim($("#planDescription").val()),
					"ideaId":$("#ideaId").val(),
				},
				type:"post",
				dataType : "json",
				success :function (data){
					if (data.success){
						window.location.href='workbench/plan/index.jsp';
					}else {
						alert("转换失败");
					}
				}
			})

		})

		$("#cancelBtn").click(function (){

			window.history.back();
		})


		$(".start_time").datetimepicker({
			//格式化：年月日时分秒
			format: 'yyyy-mm-dd hh:ii',
			//	选择后自动关闭
			autoclose: true,
			//	分钟的步长
			minuteStep: 1,
			//	语言
			language: 'zh-CN',
			//	显示今天按钮
			todayBtn: true,
			//	层级
			bootcssVer: 3,
		}).on('changeDate', function (e) {
			var startDate = $('.start_time').val();
			$(".end_time").datetimepicker('setStartDate', startDate);
			$(".start_time").datetimepicker('hide');
		});
		$('.end_time').datetimepicker({
			format: 'yyyy-mm-dd hh:ii',
			autoclose: true,
			minuteStep: 1,
			language: 'zh-CN',
			todayBtn: true,
			bootcssVer: 3,
		}).on('changeDate', function (e) {
			var returnDate = $(".end_time").val();
			$(".start_time").datetimepicker('setReturnDate', returnDate);
			$(".end_time").datetimepicker('hide');
		});
	});
</script>

</head>
<body>

<div style="position: relative; left: 400px; top: 30px;">
	<input type="hidden" id="ideaId" value="${param.ideaId}">
	<div id="title" class="page-header" style="position: relative; left: 20px; ">
		<h4>转换想法-将想法转换成一个具体的行动计划吧 <small>${param.name}</small></h4>
		<p>PS.计划可以创建不同的阶段，可以对多个日历活动按阶段进行管理(创建阶段再计划的详细页面)</p>
	</div>
	<div class="form-group" style="width: 400px; position: relative; left: 20px;">
		<label for="planName">计划名称</label>
		<input type="text" class="form-control" id="planName">
	</div>
	<div class="form-group" style="width: 400px; position: relative; left: 20px;">
		<label for="planGroup">计划名称</label>
		<input class="form-control" type="text" id="planGroup" list="planGroup-list">
		<datalist id="planGroup-list">
			<option></option>
			<c:forEach items="${PlanGroup}" var="group">
				<option value="${group.value}">${group.text}</option>
			</c:forEach>
		</datalist>
	</div>
	<div class="form-group" style="width: 400px; position: relative; left: 20px;">
		<label for="planStartDate">计划开始时间</label>
		<input type="text" class="form-control start_time" id="planStartDate" readonly="readonly" placeholder="请直接点击选择时间">
	</div>
	<div class="form-group" style="width: 400px; position: relative; left: 20px;">
		<label for="planEndDate">计划结束时间</label>
		<input type="text" class="form-control end_time" id="planEndDate" readonly="readonly" placeholder="请直接点击选择时间">
	</div>
	<div class="form-group" style="width: 400px; position: relative; left: 20px;">
		<label for="planDescription">描述</label>
		<textarea class="form-control" rows="3" id="planDescription"></textarea>
	</div>
	
	<div class="form-group" style="width: 400px; position: relative; left: 20px;">
		<label for="planLoginAct">用户名</label>
		<input type="text" class="form-control" id="planLoginAct" readonly="readonly" value="${param.loginAct}">
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 20px;">
		<input class="btn btn-primary" type="button" id="convertBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" id="cancelBtn" value="取消">
	</div>
</div>
</body>
</html>