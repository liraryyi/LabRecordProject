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

	<!-- Bootstrap core CSS -->
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootStrap-colorpicker/css/bootstrap-colorpicker.css" type="text/css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

	<style type="text/css">
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
    <!--颜色选择器插件-->
	<script type="text/javascript" src="jquery/bootStrap-colorpicker/js/bootstrap-colorpicker.js"></script>
	<!--分页查询的插件-->
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		pageList(1,10);

		//为”创建“按钮绑定事件，点击打开模态窗口
		$("#addBtn").click(function (){

			var loginAct = "${user.loginAct}";

			$("#create-calendarOwner").val(loginAct);

			$("#createCalendarModal").modal("show");
		})

		//为创建模态窗口的保存按钮绑定事件，实现信息的保存
		$("#saveBtn").click(function (){

			//使用ajax请求传输数据实现页面的局部刷新
			$.ajax({

				url:"workbench/calendar/saveCalendar.do",
				data :{
					"loginAct":$.trim($("#create-calendarOwner").val()),
					"name":$.trim($("#create-calendarName").val()),
					"startDate":$("#create-startDate").val(),
					"endDate":$("#create-endDate").val(),
					"color":$("#create-colordemo").val(),
					"url":$.trim($("#create-url").val()),
					"description":$("#create-describe").val()
				},
				type:"post",
				dataType : "json",
				success :function (data){

					//后台传输一个boolean值表示信息是否存储成功，true表示成功，false表示失败
					//如果数据存储成功，刷新下面的active页面，清空表单中的数据,并关闭模态窗口
					if (data.success){

						//需要先将jquery对象转换为dom对象，再执行操作
						$("#CalendarAddForm")[0].reset();
						//颜色栏重置
						$('#create-colordemo').css('background-color', '#FFFFFF');
						$("#create-color").text("");

						$("#createCalendarModal").modal("hide");
						pageList(1,10);
					}else{
						//如果数据存储失败，弹出一个弹框提示
						alert("市场活动保存失败！");
					}
				}
			})
		})

		//为搜索按钮绑定时间，点击查询日历活动
		$("#searchBtn").click(function (){

			//点击查询之前，先将内容保存到隐藏域中
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-description").val($.trim($("#search-description").val()));
			$("#hidden-startDate").val($("#search-startDate").val());
			$("#hidden-endDate").val($("#search-endDate").val());

			pageList(1,10);
		})

		//为selectBox选择框绑定事件，点击全选下面的选择框
		$("#selectBox").click(function (){
			$("input[name = subSelectBox]").prop("checked",this.checked);
		})

		//为subSelectBox选择框绑定事件，当subSelectBox全部为checked的时候，将selectBox状态变为checked
		/*$("#subSelectBox").click(function (){
            alert(123);
        })
        而上面这种方法是不行的，这是因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作

        动态生成的元素，需要以on方法的形式来触发事件

        语法：
            $(需要绑定元素的有效的外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
        */
		$("#calendarList").on("click",$("input[name = subSelectBox]"),function (){

			$("#selectBox").prop("checked",$("input[name = subSelectBox]").length == $("input[name = subSelectBox]:checked").length);
		})

		//为delete按钮绑定事件，点击按复选框（subSelectBox）的checked状态删除查询数据
		$("#deleteBtn").click(function (){

			//找到复选框中所有checked的jquery对象
			var $xz = $("input[name = subSelectBox]:checked");

			if ($xz.length == 0){
				alert("请选择需要删除的记录");
			}else {

				//url:workbench/activity/delete.do?id=xxx&id=xxx
				//拼接参数
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

						url:"workbench/calendar/deleteCalendar.do",
						data : param,
						type:"post",
						dataType : "json",
						success :function (data){
							//需要传递出来的信息：success：true or false
							if (data.success){
								//删除成功后刷新当前页

								pageList($("#calendarPage").bs_pagination('getOption', 'currentPage')
										,$("#calendarPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("数据删除失败")
							}
						}
					})
				}
			}
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

					url:"workbench/calendar/getCalendar.do",
					data :{
						"id": $xz.val(),
					},
					type:"get",
					dataType : "json",
					success :function (data){

						$("#edit-calendarOwner").val(data.loginAct);
						$("#edit-calendarName").val(data.name);
						$("#edit-startDate").val(data.startDate);
						$("#edit-endDate").val(data.endDate);
						$("#edit-colordemo").val(data.color);
						$("#edit-colordemo").css('background-color',data.color);
						$("#edit-color").text(data.color);
						$("#edit-url").val(data.url);
						$("#edit-description").val(data.description);
					}
				})

				$("#editCalendarModal").modal("show");
			}
		})

		//为更新按钮绑定事件，点击将已经修改的信息保存到数据库中
		$("#edit-updateBtn").click(function (){

			var $xz = $("input[name = subSelectBox]:checked");
			$.ajax({

				url:"workbench/calendar/updateCalendar.do",
				data :{
					"id":$xz.val(),
					"loginAct": $.trim($("#edit-calendarOwner").val()),
					"name": $.trim($("#edit-calendarName").val()),
					"startDate": $.trim($("#edit-startDate").val()),
					"endDate":$.trim($("#edit-endDate").val()),
					"color":$.trim($("#edit-color").val()),
					"url":$.trim($("#edit-url").val()),
					"description":$.trim($("#edit-description").val())
				},
				type:"post",
				dataType : "json",
				success :function (data){

					//传过来的数据success
					if (data.success){
						$("#CalendarEditForm")[0].reset();

						$("#editCalendarModal").modal("hide");

						//更新后，原本在哪一页，应该回到哪一页
						/*
						bootstrap的插件
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

						操作后停留在当前页面
						$("#activityPage").bs_pagination('getOption', 'currentPage')

						操作后维持已经设置好的每页展现的记录数
						$("#activityPage").bs_pagination('getOption', 'rowsPerPage')
						*/
						pageList($("#calendarPage").bs_pagination('getOption', 'currentPage')
								,$("#calendarPage").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert("保存失败")
					}
				}
			})
		})

		//模态窗口日历栏中加入日历插件
		/**
		 * 插件加入可能导致乱码问题
		 * 注意：
		 * 1.jsp文件头部：charset=UTF-8
		 * 2.引入的js文件的编码格式为utf-8
		 * 3.File》Settings》Editor》File Encodings  --utf-8
		 * 4.Tomcat服务器设置中 ：VM option：-Dfile.encoding=UTF-8
		 */
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

		// 加入颜色选择插件 基本实例化:
		$('#create-colordemo').colorpicker({
			preferredFormat : "hex" ,
			showAlpha: false
	    });
		// 添加change事件 改变背景色,为了让数据格式为十六进制的颜色数据，这里用toHexString
		$('#create-colordemo').on('change', function (event) {
			$('#create-colordemo').css('background-color', event.color.toHexString()).val('');
			$("#create-color").text(event.color.toHexString());
			$("#create-colordemo").val(event.color.toHexString());
		});

		$('#edit-colordemo').colorpicker({
			preferredFormat : "hex" ,
			showAlpha: false
		});
		// 添加change事件 改变背景色
		$('#edit-colordemo').on('change', function (event) {
			$('#edit-colordemo').css('background-color', event.color.toHexString()).val('');
			$("#edit-color").text(event.color.toHexString());
			$("#edit-colordemo").val(event.color.toHexString());
		});
	});

	function pageList(pageNo, pageSize){

		//将全选框和复选框中checked状态干掉
		$("#selectBox").prop("checked",false);

		//使用ajax进行局部刷新前，将隐藏域中保存的值赋给搜索框中的值
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-description").val($.trim($("#hidden-description").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()))

		$.ajax({

			url:"workbench/calendar/pageList.do",
			data :{

				//传参--做分页的相关参数
				"pageNo":pageNo,
				"pageSize":pageSize,
				//传参--查询的相关条件
				"name":$.trim($("#search-name").val()),
				"description":$.trim($("#search-description").val()),
				"startDate":$.trim($("#search-startDate").val()),
				"endDate":$.trim($("#search-endDate").val())
			},
			type:"get",
			dataType : "json",
			success :function (data){

				/**
				 * 前端需要的参数：市场活动信息列表
				 * {{市场活动1}，{2}，{3}}
				 * 一会分页插件需要的，查询出来的总记录数
				 * {“total”：100}
				 * {“total：100，“datalist”：[{市场活动1}，{2}，{3}]}
				 */
				var html = "";

				//每一个n就是一个市场活动对象
				$.each(data.list,function (i,n){
					html +='<tr class="active">';
					html +='	<td><input type="checkbox" name="subSelectBox" value="'+n.id+'" /></td>';
					html +='	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/calendar/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html +='	<td>'+n.description+'</td>';
					html +='    <td><a style="text-decoration: none;cursor: pointer;" onclick="window.open(\''+n.url+'\')";">'+n.url+'</a></td>';
					html +='	<td>'+n.startDate+'</td>';
					html +='	<td>'+n.endDate+'</td>';
					html +='</tr>';

				})

				$("#calendarList").html(html);

				//计算总页数
				var totalPages = data.total%pageSize ==0?data.total/pageSize:data.total/pageSize+1;

				//分页组件
				$("#calendarPage").bs_pagination({
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
		<!-- 创建日历活动的模态窗口 -->
		<div class="modal fade" id="createCalendarModal" role="dialog">
			<div class="modal-dialog" role="document" style="width: 85%;">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">×</span>
						</button>
						<h4 class="modal-title" id="myModalLabel1">创建日历计划</h4>
					</div>
					<div class="modal-body">

						<form class="form-horizontal" role="form" id="CalendarAddForm">

							<div class="form-group">
								<label for="create-calendarOwner" class="col-sm-2 control-label">用户名<span style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-calendarOwner">
								</div>
								<label for="create-calendarName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-calendarName">
								</div>
							</div>

							<%--<div class="form-group">
                                <label for="create-group" class="col-sm-2 control-label">分组</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control start_time" id="create-group">
                                </div>
                            </div>--%>

							<div class="form-group">
								<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control start_time" id="create-startDate"  readonly="readonly" placeholder="请直接点击选择时间(默认为今天)">
								</div>
								<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control end_time" id="create-endDate" readonly="readonly" placeholder="请直接点击选择时间">
								</div>
							</div>

							<div class="form-group">

								<label for="create-colordemo" class="col-sm-2 control-label">颜色</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-colordemo" style="background-color: #ff0000" value="#ff0000" placeholder="点击可以选择颜色(默认为红色)" readonly >
									<span id="create-color"></span>
								</div>
								<label for="create-url" class="col-sm-2 control-label">URL</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-url" >
								</div>
							</div>

							<div class="form-group">
								<label for="create-describe" class="col-sm-2 control-label">描述</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-describe"></textarea>
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

		<!-- 修改日历活动的模态窗口 -->
		<div class="modal fade" id="editCalendarModal" role="dialog">
			<div class="modal-dialog" role="document" style="width: 85%;">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">×</span>
						</button>
						<h4 class="modal-title" id="myModalLabel2">修改日历计划</h4>
					</div>
					<div class="modal-body">

						<form class="form-horizontal" role="form" id="CalendarEditForm">

							<div class="form-group">
								<label for="edit-calendarOwner" class="col-sm-2 control-label">用户名<span style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-calendarOwner">
								</div>
								<label for="edit-calendarName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-calendarName">
								</div>
							</div>

							<div class="form-group">
								<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control start_time" id="edit-startDate">
								</div>
								<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control end_time" id="edit-endDate">
								</div>
							</div>

							<div class="form-group">
								<label for="edit-colordemo" class="col-sm-2 control-label">颜色</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-colordemo" value="" placeholder="点击可以选择颜色" readonly >
									<span id="edit-color"></span>
								</div>
								<label for="edit-url" class="col-sm-2 control-label">URL</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-url">
								</div>
							</div>

							<div class="form-group">
								<label for="edit-description" class="col-sm-2 control-label">描述</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-description"></textarea>
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
			               text-shadow: 0 0px 30px rgba(0, 0, 0, 0.2);"
				>Calendar List</h3>
			</div>
		</div>
	</div>

		<!--用隐藏域储存搜索框中填写的信息-->
		<input type="hidden" id="hidden-name"/>
		<input type="hidden" id="hidden-description"/>
		<input type="hidden" id="hidden-startDate"/>
		<input type="hidden" id="hidden-endDate"/>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">内容</div>
				      <input class="form-control" type="text" id="search-description">
				    </div>
				  </div>

<%--					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">分组</div>
							<input class="form-control start_time" type="text" id="search-group"  />
						</div>
					</div>--%>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control start_time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control end_time" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover" width="100%" style="table-layout: fixed">
					<thead>
						<tr style="color: #B3B3B3;">
							<td class="tdCheckBox"><input type="checkbox" id="selectBox" /></td>
							<td>名称</td>
                            <td class="tdDescription">内容</td>
							<td>URL</td>
							<td class="tdDate">开始日期</td>
							<td class="tdDate">结束日期</td>
						</tr>
					</thead>
					<tbody id="calendarList">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="calendarPage"></div>
			</div>

		</div>
	</div>


</body>
</html>