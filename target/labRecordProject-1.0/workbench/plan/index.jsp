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
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<style type="text/css">
	body {
		font-family: Calibri;
		background-color: #f0f0f0;
		padding: 0em 1em;
		overflow-x:hidden;
	}
	td {
		text-overflow: ellipsis; /* for IE */
		-moz-text-overflow: ellipsis; /* for Firefox,mozilla */
		overflow: hidden;
		white-space: nowrap;
		text-align: left
	}
	.tdCheckBox {
		width: 3%;
	}
	.tdDescription{
		width: 50%;
	}
	.tdDate {
		width: 10%;
	}
	.tdGroup{
		width: 10%;
	}
</style>

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--分页查询的插件-->
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		pageList(1,10);

		//为创建按钮绑定事件，点击打开创建线索的模态窗口
		$("#addBtn").click(function (){

			var loginAct = "${user.loginAct}";

			$("#create-PlanLoginAct").val(loginAct);

			$("#createPlanModal").modal("show");
		})

		//为保存按钮绑定事件，点击将已经填写好的数据保存到数据库中
		$("#saveBtn").click(function (){

			$.ajax({

				url:"workbench/plan/saveplan.do",
				data :{

					"loginAct":$.trim($("#create-PlanLoginAct").val()),
					"name":$.trim($("#create-PlanName").val()),
					"group":$.trim($("#create-PlanGroup").val()),
					"startDate":$.trim($("#create-PlanStartDate").val()),
					"endDate":$.trim($("#create-PlanEndDate").val()),
					"description":$.trim($("#create-PlanDescription").val()),

				},
				type:"post",
				dataType : "json",
				success :function (data){
					if (data.success){
						pageList(1,10);
						$("#createIdeaModal").modal("hide");
					}else {
						alert("保存失败")
					}
				}
			})
		})

		//为搜索按钮绑定事件，点击查询
		$("#searchBtn").click(function (){
			//先把搜索框中的信息保存到隐藏域中
			$("#hidden-PlanName").val($.trim($("#search-PlanName").val()));
			$("#hidden-PlanLoginAct").val($.trim($("#search-PlanLoginAct").val()));
			$("#hidden-PlanGroup").val($.trim($("#search-PlanGroup").val()));
			$("#hidden-PlanStartDate").val($.trim($("#search-PlanStartDate").val()));
			$("#hidden-PlanEndDate").val($.trim($("#search-PlanEndDate").val()));
			$("#hidden-PlanDescription").val($.trim($("#search-PlanDescription").val()));

			pageList(1,10);
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

		//为selectBox选择框绑定事件，点击全选下面的选择框
		$("#selectBox").click(function (){
			$("input[name = subSelectBox]").prop("checked",this.checked);
		})

		$("#tbodyContext").on("click",$("input[name = subSelectBox]"),function (){

			$("#selectBox").prop("checked",$("input[name = subSelectBox]").length == $("input[name = subSelectBox]:checked").length);
		})

		//为”修改“按钮绑定事件，点击打开模态窗口
		$("#updateBtn").click(function (){

			//修改时应该只能修改选中的唯一一个复选框的信息
			var $xz = $("input[name = subSelectBox]:checked");
			if ($xz.length == 0){
				alert("请选择您想修改的活动")
			}else if ($xz.length > 1){
				alert("不能同时修改多个活动的信息")
			}else {

				$.ajax({

					url:"workbench/plan/getPlan.do",
					data :{
						"id": $xz.val(),
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
			}
		})

		//为更新按钮绑定事件，点击将已经修改的信息保存到数据库中
		$("#edit-updateBtn").click(function (){

			var $xz = $("input[name = subSelectBox]:checked");
			$.ajax({

				url:"workbench/plan/updatePlan.do",
				data :{
					"id":$xz.val(),
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
						$("#ideaEditForm")[0].reset();

						$("#editPlanModal").modal("hide");

						pageList($("#planPage").bs_pagination('getOption', 'currentPage')
								,$("#planPage").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert("保存失败")
					}
				}
			})
		})

		//为delete按钮绑定事件，点击按复选框（subSelectBox）的checked状态删除查询数据
		$("#deleteBtn").click(function (){

			//找到复选框中所有checked的jquery对象
			var $xz = $("input[name = subSelectBox]:checked");

			if ($xz.length == 0){
				alert("请选择需要删除的记录");
			}else {

				var param = "";

				//遍历$xz中的每一个dom对象遍历出来，取其value值》取得需要删除的记录的id
				for (var i = 0; i < $xz.length; i++) {

					param += "id=" + $($xz[i]).val();
					if (i < $xz.length - 1){
						param += "&"
					}
				}

				if (confirm("是否打算删除该数据")){
					$.ajax({

						url:"workbench/plan/deletePlan.do",
						data : param,
						type:"post",
						dataType : "json",
						success :function (data){
							//需要传递出来的信息：success：true or false
							if (data.success){
								//删除成功后刷新当前页

								pageList($("#ideaPage").bs_pagination('getOption', 'currentPage')
										,$("#ideaPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("数据删除失败")
							}
						}
					})
				}
			}
		})

	});

	function pageList(pageNo,pageSize){

		//搜索前将隐藏域中的值赋给搜索框
		$("#search-PlanName").val($.trim($("#hidden-PlanName").val()));
		$("#search-PlanLoginAct").val($.trim($("#hidden-PlanLoginAct").val()));
		$("#search-PlanGroup").val($.trim($("#hidden-PlanGroup").val()));
		$("#search-PlanStartDate").val($.trim($("#hidden-PlanStartDate").val()));
		$("#search-PlanEndDate").val($.trim($("#hidden-PlanEndDate").val()));
		$("#search-PlanDescription").val($.trim($("#hidden-PlanDescription").val()));

		$.ajax({

			url:"workbench/plan/getPlanList.do",
			data :{
				//传参--做分页的相关参数
				"pageNo":pageNo,
				"pageSize":pageSize,
				//传参--线索列表
				"name":$.trim($("#search-PlanName").val()),
				"loginAct":$.trim($("#search-PlanLoginAct").val()),
				"group":$.trim($("#search-PlanGroup").val()),
				"startDate":$.trim($("#search-PlanStartDate").val()),
				"endDate":$.trim($("#search-PlanEndDate").val()),
				"description":$.trim($("#search-PlanDescription").val()),
			},
			type:"post",
			dataType : "json",
			success :function (data){

				/**
				 * 前端需要的参数：市场活动信息列表
				 * {{市场活动1}，{2}，{3}}
				 * 一会分页插件需要的，查询出来的总记录数
				 * {“total”：100}
				 * {“total：100，“datalist”：[{市场活动1}，{2}，{3}]}
				 */

				var html ="";

				$.each(data.list,function (i,n){
					html +='<tr>';
					html +='<td><input value="'+n.id+'" name="subSelectBox" type="checkbox"/></td>';
					html +='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/plan/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html +='<td>'+n.loginAct+'</td>';
					html +='<td>'+n.group+'</td>';
					html +='<td>'+n.description+'</td>';
					html +='<td>'+n.startDate+'</td>';
					html +='<td>'+n.endDate+'</td>';
					html +='</tr>';
				})

				$("#tbodyContext").html(html);

				//计算总页数
				var totalPages = data.total%pageSize ==0?data.total/pageSize:data.total/pageSize+1;

				//分页组件
				$("#planPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数》需要计算
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//回调函数在点击分页组件的时候触发
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}
	
</script>
</head>
<body>

    <!--用隐藏域储存搜索框中填写的信息-->
    <input type="hidden" id="hidden-PlanName"/>
    <input type="hidden" id="hidden-PlanLoginAct"/>
    <input type="hidden" id="hidden-PlanGroup"/>
	<input type="hidden" id="hidden-PlanStartDate"/>
	<input type="hidden" id="hidden-PlanEndDate"/>
	<input type="hidden" id="hidden-PlanDescription"/>

	<!-- 创建plan的模态窗口 -->
	<div class="modal fade" id="createPlanModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建一个计划</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-PlanLoginAct" class="col-sm-2 control-label">用户名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-PlanLoginAct">
							</div>
							<label for="create-PlanName" class="col-sm-2 control-label">计划<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-PlanName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-PlanGroup" class="col-sm-2 control-label">分组</label>
							<div class="col-sm-10" style="width: 300px;">
								<input class="form-control" type="text" id="create-PlanGroup" list="create-planGroup-list">
								<datalist id="create-planGroup-list">
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
							<label for="create-PlanStartDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control start_time" id="create-PlanStartDate"  readonly="readonly" placeholder="请直接点击选择时间(默认为今天)">
							</div>
							<label for="create-PlanEndDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control end_time" id="create-PlanEndDate" readonly="readonly" placeholder="请直接点击选择时间">
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-PlanDescription" class="col-sm-2 control-label">计划具体描述</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-PlanDescription"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
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
					<form class="form-horizontal" id="ideaEditForm" role="form">

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
							<label for="create-PlanGroup" class="col-sm-2 control-label">分组</label>
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
	

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3 style="text-align: center;
			               font-size: 50px;
			               text-shadow: 0 0px 30px rgba(0, 0, 0, 0.2);">Plan List</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">计划</div>
				      <input class="form-control" type="text" id="search-PlanName">
				    </div>
				  </div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">用户名</div>
							<input class="form-control" type="text" id="search-PlanLoginAct">
						</div>
					</div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">分组</div>
						<input class="form-control" type="text" id="search-planGroup" list="search-planGroup-list">
						<datalist id="search-planGroup-list">
							<option></option>
							<c:forEach items="${PlanGroup}" var="group">
								<option value="${group.value}">${group.text}</option>
							</c:forEach>
						</datalist>
				    </div>
				  </div>
				  
				  <%--<div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">状态</div>
						<select class="form-control" id="search-IdeaState">
							<option></option>
							<c:forEach items="${IdeaState}" var="state">
								<option value="${state.value}">${state.text}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
						<select class="form-control" id="search-IdeaSource">
							<option></option>
							<c:forEach items="${IdeaSource}" var="source">
								<option value="${source.value}">${source.text}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>--%>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">开始日期</div>
							<input class="form-control start_time" type="text" id="search-PlanStartDate" readonly="readonly">
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">结束日期</div>
							<input class="form-control end_time" type="text" id="search-PlanEndDate" readonly="readonly">
						</div>
					</div>

					<%--<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">是否公开</div>
							<select class="form-control" id="search-IdeaIsPublic">
								<option></option>
								<option value="1">公开</option>
								<option value="0">私有</option>
							</select>
						</div>
					</div>--%>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">描述</div>
				      <input class="form-control" type="text" id="search-PlanDescription">
				    </div>
				  </div>


				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>

			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>

			<div style="position: relative;top: 50px;">
				<table class="table table-hover" width="100%" style="table-layout: fixed">
					<thead>
						<tr style="color: #B3B3B3;">
							<td class="tdCheckBox"><input type="checkbox" id="selectBox" /></td>
							<td>计划</td>
							<td>用户名</td>
							<td class="tdGroup">分组</td>
							<td class="tdDescription">描述</td>
							<td class="tdDate">开始时间</td>
							<td class="tdDate">结束时间</td>
						</tr>
					</thead>
					<tbody id="tbodyContext">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="planPage"></div>
			</div>
			
		</div>
		
	</div>


</body>
</html>