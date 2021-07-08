
$(function(){
    //Cropper初始化
    initCropperInModal($('#photo'),$('#photoInput'),$('#changeModal'));

    //点击修改头像，打开模态窗口
    $("#changePhoto").click(function (){
        $("#changeModal").modal("show");
    })

    //点击修改密码，弹出修改密码的模态窗口
    $("#editPwd").click(function (){

        $("#editPwdModal").modal("show");
        $("#oldPwd").val("");
        $("#newPwd").val("");
        $("#confirmPwd").val("");
        $("#msg").text("");

    });

    //点击更新密码，对密码进行修改
    $("#updatePwdBtn").click(function (){

        var loginAct = $("#user-loginAct").val();
        var oldPwd = $("#oldPwd").val();
        var newPwd = $("#newPwd").val();
        var confirmPwd = $("#confirmPwd").val();

        if (newPwd.length<6 ||newPwd.length>16){
            $("#msg").text("密码应该在6位至16位之间");
            return false;
        }

        if (newPwd != confirmPwd){
            $("#msg").text("新密码与确认密码不一致");
            return false;
        }

        $.ajax({

            url:"settings/user/editPwd.do",
            data :{
                "loginAct":loginAct,
                "oldPwd":oldPwd,
                "newPwd":newPwd
            },
            type:"post",
            dataType : "json",
            success :function (data){
                if (data.flag){
                    $("#msg").text(data.msg);

                    var time=3;
                    var timer = setInterval(function(){
                        if(time==0){
                            $("#editPwdModal").modal("hide");
                            clearInterval(timer);
                        }else{
                            time--;
                        }
                    },1000)

                }else {
                    $("#msg").text(data.msg);
                }
            }
        })
    })

});

$(".dropdown").mouseover(function () {
    $(this).addClass("open");
});

$(".dropdown").mouseleave(function () {
    $(this).removeClass("open");
});

//修改头像
var initCropperInModal = function(img, input, modal){
    var $image = img;
    var $inputImage = input;
    var $modal = modal;
    var options = {
        aspectRatio: 1, // 纵横比
        viewMode: 2,
        preview: '.img-preview' // 预览图的class名
    };
    // 模态框隐藏后需要保存的数据对象
    var saveData = {};
    var URL = window.URL || window.webkitURL;
    var blobURL;

    $modal.on('show.bs.modal',function () {
        // 如果打开模态框时没有选择文件就自动点击“打开图片”按钮
        if(!$inputImage.val()){
            $inputImage.click();
        }
    }).on('shown.bs.modal', function () {
        // 重新创建
        $image.cropper( $.extend(options, {
            ready: function () {
                // 当剪切界面就绪后，恢复数据
                if(saveData.canvasData){
                    $image.cropper('setCanvasData', saveData.canvasData);
                    $image.cropper('setCropBoxData', saveData.cropBoxData);
                }
            }
        }));
    }).on('hidden.bs.modal', function () {
        // 保存相关数据
        saveData.cropBoxData = $image.cropper('getCropBoxData');
        saveData.canvasData = $image.cropper('getCanvasData');
        // 销毁并将图片保存在img标签
        $image.cropper('destroy').attr('src',blobURL);
    });

    if (URL) {
        $inputImage.change(function() {
            var files = this.files;
            var file;
            if (!$image.data('cropper')) {
                return;
            }
            if (files && files.length) {
                file = files[0];
                if (/^image\/\w+$/.test(file.type)) {

                    if(blobURL) {
                        URL.revokeObjectURL(blobURL);
                    }
                    blobURL = URL.createObjectURL(file);

                    // 重置cropper，将图像替换
                    $image.cropper('reset').cropper('replace', blobURL);

                    // 选择文件后，显示和隐藏相关内容
                    $('.img-container').removeClass('hidden');
                    $('.img-preview-box').removeClass('hidden');
                    $('#changeModal .disabled').removeAttr('disabled').removeClass('disabled');
                    $('#changeModal .tip-info').addClass('hidden');

                } else {
                    window.alert('请选择一个图像文件！');
                }
            }
        });
    } else {
        $inputImage.prop('disabled', true).addClass('disabled');
    }
}
//修改头像
var sendPhoto = function(){
    // 得到PNG格式的dataURL
    var photo = $('#photo').cropper('getCroppedCanvas', {
        width: 300,
        height: 300
    }).toDataURL('image/png');

    $.ajax({
        url: 'settings/user/savePhoto.do', // 要上传的地址
        type: 'post',
        data: {
            'id':"${user.id}",
            'imgData': photo
        },
        dataType: 'json',
        success: function (data) {
            if (data.flag) {
                // 将上传的头像的地址填入
                $('.img-circle').attr('src', data.imgPath);
                $('#changeModal').modal('hide');
            } else {
                alert(data.msg);
            }
        }
    });
}