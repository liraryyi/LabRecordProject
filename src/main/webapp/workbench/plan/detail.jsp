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

</head>
<body>

    <!-- 创建state的模态窗口 -->
    <div class="modal fade" id="createPlanStateModal" role="dialog">
		<input type="hidden" id="create-PlanStatePlanId" value="${plan.id}">
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">创建计划中的一个阶段</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">

					<div class="form-group">
						<label for="create-PlanStateLoginAct" class="col-sm-2 control-label">用户名<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-PlanStateLoginAct">
						</div>
						<label for="create-PlanStateName" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-PlanStateName">
						</div>
					</div>

					<div class="form-group">
						<label for="create-PlanStateStartDate" class="col-sm-2 control-label">开始日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control start_time" id="create-PlanStateStartDate"  readonly="readonly" placeholder="请直接点击选择时间">
						</div>
						<label for="create-PlanStateEndDate" class="col-sm-2 control-label">结束日期</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control end_time" id="create-PlanStateEndDate" readonly="readonly" placeholder="请直接点击选择时间">
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

					<div style="position: relative;top: 20px;">
						<div class="form-group">
							<label for="create-PlanStateDescription" class="col-sm-2 control-label">阶段具体描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-PlanStateDescription"></textarea>
							</div>
						</div>
					</div>
				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="saveStateBtn">保存</button>
			</div>
		</div>
	</div>
</div>

	<!-- 关联日历活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<input type="hidden" id="stateId">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联日历活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入日历活动名称，支持模糊查询" id="calendarName">
						    <span id class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>用户名</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="calendarTbody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="bindBtn">关联</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改plan的模态窗口 -->
	<div class="modal fade" id="editPlanModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改这个想法</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="planEditForm" role="form">

						<div class="form-group">
							<label for="edit-PlanLoginAct" class="col-sm-2 control-label">用户名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-PlanLoginAct">
							</div>
							<label for="edit-PlanName" class="col-sm-2 control-label">想法<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-PlanName">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-PlanGroup" class="col-sm-2 control-label">分组</label>
							<div class="col-sm-10" style="width: 300px;">
								<input class="form-control" type="text" id="edit-PlanGroup" list="edit-planGroup-list">
								<datalist id="edit-planGroup-list">
									<option></option>
									<c:forEach items="${PlanGroup}" var="group">
										<option value="${group.value}">${group.text}</option>
									</c:forEach>
								</datalist>
							</div>

							<%--<label for="create-IdeaIsPublic" class="col-sm-2 control-label">是否公开</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-IdeaIsPublic">
									<option></option>
									<option value="1">公开</option>
									<option value="0">私有</option>
								</select>
							</div>--%>
						</div>

						<div class="form-group">
							<label for="edit-PlanStartDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control start_time" id="edit-PlanStartDate"  readonly="readonly" placeholder="请直接点击选择时间(默认为今天)">
							</div>
							<label for="edit-PlanEndDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control end_time" id="edit-PlanEndDate" readonly="readonly" placeholder="请直接点击选择时间">
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-PlanDescription" class="col-sm-2 control-label">想法具体描述</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-PlanDescription"></textarea>
								</div>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="edit-updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 1%;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 15%; top: -30px;">
		<div class="page-header">
			<h3>${plan.loginAct}&nbsp;<small>${plan.name}&nbsp;</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 55%;">
			<button type="button" class="btn btn-primary" id="createStateBtn"><span class="glyphicon glyphicon-plus"></span> 创建阶段</button>
			<button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; left: 15%; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">用户名</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${plan.loginAct}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">想法</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${plan.name}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">分组</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${plan.group}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">&nbsp;</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期&nbsp;</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${plan.startDate}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期&nbsp;</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${plan.endDate}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${plan.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${plan.createTime}&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${plan.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${plan.editTime}&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${plan.description}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>

	</div>
	
	<!-- 日历计划 -->
	<div class="bindHref" id="stateDiv"></div>

	<div style="height: 200px;"></div>


	<script type="text/javascript" src="jquery/jquery.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<script type="text/javascript">

		//默认情况下取消和保存按钮是隐藏的
		var cancelAndSaveBtnDefault = true;

		$(function(){

			updateState();

			$("#cancelBtn").click(function(){
				//显示
				$("#cancelAndSaveBtn").hide();
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","90px");
				cancelAndSaveBtnDefault = true;
			});

			$(".start_time").datetimepicker({
				//格式化：年月日时分秒
				format: 'yyyy-mm-dd hh:ii',
				//	选择后自动关闭
				autoclose: true,
				//  最精确的时间   1小时
				minView:1,
				//	语言
				language: 'zh-CN',
				//	显示今天按钮
				todayBtn: true,
			}).on('changeDate', function (e) {
				var startDate = $('.start_time').val();
				$(".end_time").datetimepicker('setStartDate', startDate);
				$(".start_time").datetimepicker('hide');
			});
			$('.end_time').datetimepicker({
				format: 'yyyy-mm-dd hh:ii',
				autoclose: true,
				//  最精确的时间   1小时
				minView:1,
				language: 'zh-CN',
				todayBtn: true,
			}).on('changeDate', function (e) {
				var returnDate = $(".end_time").val();
				$(".start_time").datetimepicker('setReturnDate', returnDate);
				$(".end_time").datetimepicker('hide');
			});

			//为创建阶段绑定事件，点击打开模态窗口
			$("#createStateBtn").click(function (){

				var loginAct = '${plan.loginAct}';

				$("#create-PlanStateLoginAct").val(loginAct);

				$("#createPlanStateModal").modal("show");
			})

			//为保存阶段绑定事件，点击保存计划的阶段
			$("#saveStateBtn").click(function (){

				$.ajax({

					url:"workbench/plan/saveState.do",
					data :{
						"planId":$("#create-PlanStatePlanId").val(),
						"loginAct":$("#create-PlanStateLoginAct").val(),
						"name":$("#create-PlanStateName").val(),
						"startDate":$("#create-PlanStateStartDate").val(),
						"endDate":$("#create-PlanStateEndDate").val(),
						"description":$("#create-PlanStateDescription").val(),
					},
					type:"post",
					dataType : "json",
					success :function (data){
						if (data.success){
							updateState();
							$("#createPlanStateModal").modal("hide");
						}else {
							alert("保存失败");
						}
					}
				})
			})

			//为”修改“按钮绑定事件，点击打开模态窗口
			$("#updateBtn").click(function (){

				//修改时应该只能修改选中的唯一一个复选框的信息

				$.ajax({

					url:"workbench/plan/getPlan.do",
					data :{
						"id":"${plan.id}"
					},
					type:"get",
					dataType : "json",
					success :function (data){

						$("#edit-PlanLoginAct").val(data.loginAct);
						$("#edit-PlanName").val(data.name);
						$("#edit-PlanGroup").val(data.group);
						$("#edit-PlanStartDate").val(data.startDate);
						$("#edit-PlanEndDate").val(data.endDate);
						$("#edit-PlanDescription").val(data.description);
					}
				})

				$("#editPlanModal").modal("show");
			})

			//为更新按钮绑定事件，点击将已经修改的信息保存到数据库中
			$("#edit-updateBtn").click(function (){

				$.ajax({

					url:"workbench/plan/updatePlan.do",
					data :{
						"id":"${plan.id}",
						"loginAct":$.trim($("#edit-PlanLoginAct").val()),
						"name":$.trim($("#edit-PlanName").val()),
						"group": $.trim($("#edit-PlanGroup").val()),
						"startDate":$.trim($("#edit-PlanStartDate").val()),
						"endDate":$.trim($("#edit-PlanEndDate").val()),
						"description":$.trim($("#edit-PlanDescription").val())
					},
					type:"post",
					dataType : "json",
					success :function (data){

						//传过来的数据success
						if (data.success){
							$("#planEditForm")[0].reset();

							$("#editPlanModal").modal("hide");

						}else {
							alert("保存失败")
						}
					}
				})
			})

			//为删除按钮绑定事件，点击删除该计划
			$("#deleteBtn").click(function (){

				if (confirm("确定要删除吗")){
				$.ajax({

					url:"workbench/plan/deletePlan_1.do",
					data :{
						"id":"${plan.id}"
					},
					type:"post",
					dataType : "json",
					success :function (data){

						if (data.success){

							window.location.href="workbench/plan/index.jsp";
						}else {
							alert("删除失败");
						}
					}
				})
				}
			})

			//点击关联日历活动按钮，展示模态窗口，同时拿到stateId的值
			$(".bindHref").on("click",'#bindBtn',function (){

				var $stateId = $(this).val();

				$("#stateId").val($stateId);

				$("#bundModal").modal("show");
			})

			//点击删除按钮，删除当前的阶段
			$(".bindHref").on("click",'#deleteStateBtn',function (){

				var stateId = $(this).val();

				$.ajax({

					url:"workbench/plan/deleteState.do",
					data :{
						"stateId":stateId
					},
					type:"post",
					dataType : "json",
					success :function (data){

						if (data.success){
							updateState();
						}else {
							alert("删除失败");
						}
					}
				})
			})

			//按下回车，展现关联市场活动列表
			$("#calendarName").keydown(function (event){
				if (event.keyCode == 13){
					updateModalRelation();

					//展现完列表后，记得将模态窗口默认的回车行为禁用掉
					return false;
				}
			})

			//为关联按钮绑定事件，点击关联
			$("#bindBtn").click(function (){
				//这里关联的意思是将ideaId和calendarId加入到表tbl_idea_calendar_relation

				//找到复选框中所有checked的jquery对象
				var $xz = $("input[name = xz]:checked");
				var stateId = $("#stateId").val();

				if ($xz.length == 0){
					alert("请选择需要关联的市场活动")
				}else{

					//需要传递的数据的形式是
					//workbench/idea/bind.do?iid=xxx&cid=xxx&cid=xxx...
					var param ="stateId="+stateId+"&";

					for (var i =0;i<$xz.length;i++){

						//$()将DOM对象转换为jQuery对象
						param +="cid="+$($xz[i]).val();

						if (i<$xz.length-1){
							param +="&";
						}
					}
				}

				$.ajax({

					url:"workbench/plan/bind.do",
					data :param,
					type:"get",
					dataType : "json",
					success :function (data){
						if (data.success){

							updateState();

							$("#bundModal").modal("hide");
						}else {
							alert("关联失败");
						}
					}
				})

			})


		});

		//刷新计划的阶段
		function updateState(){

			//根据plan的id找到对应的state
			$.ajax({

				url:"workbench/plan/getStateList.do",
				data :{
					"planId":"${plan.id}"
				},
				type:"get",
				dataType : "json",
				success :function (data){

					//分析传过来的数据，是含有state的list
					var html = "";

					$.each(data,function (i,n){

						html +='<div style="position: relative; top: 60px; left: 250px;">';
						html +='<div class="page-header">';
						html +='<h4>'+n.name+'<small>&nbsp;'+n.startDate+'----'+n.endDate+'</small></h4>';
						html +='<p style="width: 600px;">'+n.description+'</p>'
						html +='</div>';
						html +='<div style="position: relative;top: -20px;">';
						html +='<table class="table table-hover" style="width: 900px;">';
						html +='<thead>';
						html +='<tr style="color: #B3B3B3;">';
						html +='<td>名称</td>';
						html +='<td>开始日期</td>';
						html +='<td>结束日期</td>';
						html +='<td>用户名</td>';
						html +='<td></td>';
						html +='</tr>';
						html +='</thead>';
						html +='<tbody name="stateTbody" id="'+n.id+'">';
						$.each(n.calendarList,function (i,m){
							html +='<tr>';
							html +='<td>'+m.name+'</td>';
							html +='<td>'+m.startDate+'</td>';
							html +='<td>'+m.endDate+'</td>';
							html +='<td>'+m.loginAct+'</td>';
							html +='<td><a href="javascript:void(0);" onclick="unbind(\''+m.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
							html +='</tr>';
						})
						html +='</tbody>';
						html +='</table>';
						html +='</div>';
						html +='<div>';
						html +='<button type="button" name="bindButton" id="bindBtn" class="btn btn-default" value="'+n.id+'"><span class="glyphicon glyphicon-edit"></span> 关联日历活动</button>';
						html +='&nbsp;<button type="button" id="deleteStateBtn" class="btn btn-danger" value="'+n.id+'"><span class="glyphicon glyphicon-minus"></span> 删除</button>';
						html +='</div>';
						html +='</div>';
					})

					$("#stateDiv").html(html);
				}
			})
		}

		//刷新关联日历活动列表
		//这里刷新的时候，我们希望1.正常的连表查询; 2.不显示已经关联好的日历活动
		function updateModalRelation(){

			$.ajax({

				url:"workbench/plan/getCalendarListByName_Plan.do",
				data :{
					"name":$.trim($("#calendarName").val()),
					"loginAct":"${user.loginAct}"
				},
				type:"get",
				dataType : "json",
				success :function (data){

					var html = "";

					//这里每一个n就是遍历出来的一个calendar对象
					$.each(data,function (i,n){
						html +='<tr>';
						html +='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html +='<td>'+n.name+'</td>';
						html +='<td>'+n.startDate+'</td>';
						html +='<td>'+n.endDate+'</td>';
						html +='<td>'+n.loginAct+'</td>';
						html +='</tr>';
					})

					$("#calendarTbody").html(html);

				}
			})
		}

		//解除关联
		function unbind(id){
			$.ajax({

				url:"workbench/plan/unbind.do",
				data :{
					"id":id
				},
				type:"post",
				dataType : "json",
				success :function (data){
					if (data.success){
						updateState();
					}else {
						alert("解除关联失败")
					}
				}
			})
		}

	</script>


</body>
</html>