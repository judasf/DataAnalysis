<%@ Page Language="C#" %>

<!DOCTYPE html>
<html>
<head>
    <title>运维信息管理系统</title>
    <!--引入My97日期文件-->
    <script src="Script/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
    <!--引入Jquery文件-->
    <script src="Script/easyui/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="Script/easyui/jquery.easyui.min.js" type="text/javascript"></script>
     <%--引入uploadify文件--%>
    <link rel="stylesheet" type="text/css" href="Script/uploadify/uploadify.css" />
    <script type="text/javascript" src="Script/uploadify/jquery.uploadify.js"></script>
    <!--引入easyui文件-->
    <link href="Script/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="Script/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="Script/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="Script/extJquery.js" type="text/javascript"></script>
    <script src="Script/extEasyUI.js" type="text/javascript"></script>
      <%--引入图片展示插件--%>
    <link href="Script/ImgPopup/ImgPopup.css" rel="stylesheet" />
    <script src="Script/ImgPopup/ImgPopup.min.js"></script>
    <link href="css/table.css" rel="stylesheet" />
    <style>
        .STYLE1 { font-size: 13px; color: #FFFFFF; }
        .STYLE3 { font-size: 12px; color: #033d61; }
        .navPoint { COLOR: white; CURSOR: pointer; FONT-FAMILY: Webdings; FONT-SIZE: 9pt; }
        .inputBorder { border: 1px solid #ccc; height: 20px; line-height: 20px; }
    </style>
    <script type="text/javascript">
        $(function () {
            //初始化导航菜单
            $.ajax({
                type: "post",
                dataType: "json",
                url: "ajax/FetchMenu.ashx",
                data: { method: "CreatMenu", userid: "1" }
            }).done(function (result) {
                //成功调用后处理返回结果
                if (result.flag === "0")
                    $.messager.alert("error", result.msg, "error", function () {
                        parent.location.replace('logout.aspx');
                    });
                else {
                    //遍历json数据，生成结果
                    $('#navgation').empty();
                    var menuContent = "";
                    $.each(result.menus, function (i, _menus) {
                        menuContent += $.formatString('<div title="{0}" iconCls="{1}" style="overflow:auto;padding:10px;"><ul class="easyui-tree" >', _menus.menuname, _menus.icon);
                        $.each(_menus.menus, function (j, o) {
                            menuContent += $.formatString('<li data-options="iconCls:\'{0}\',attributes:{url:\'{1}\',iframeName:\'{2}\'}">{3}</li>', o.icon, o.url, o.iframename, o.menuname);
                        });
                        menuContent += "</ul></div>"
                    });
                    $('#navgation').append(menuContent).accordion();
                    //处理tree节点
                    $('.easyui-tree').tree({
                        onClick: function (node) {
                            addTab({
                                url: node.attributes.url,
                                title: node.text,
                                iconCls: node.iconCls,
                                iframeName: node.attributes.iframeName
                            });
                        }
                    });
                }
            }
            );
            //增加tab
            var addTab = function (params) {
                $("#I2", document.body).attr("src", params.url);
            }
        });
        //显示隐藏
        var switchSysBar = function () {
                $('body').layout('collapse', 'west');
        };
    </script>
</head>
<body class="easyui-layout">
    <div data-options="region:'north',border:false" style="overflow: hidden; height: 98px">
        <iframe src="top.aspx" frameborder="0" style="border: 0; width: 100%; height: 100%;"></iframe>
    </div>
    <div data-options="region:'south',border:false" style="height: 12px; overflow: hidden;">
        <iframe src="down.html" frameborder="0" style="border: 0; width: 100%; height: 100%;"></iframe>
    </div>
    <div data-options="region:'west',border:false"  style="width: 178px; overflow: hidden;">
        <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
            <tr>
                <td bgcolor="#1873aa" style="width: 6px;">&nbsp;</td>
                <td width="165" id="frmTitle" name="fmTitle" height="100%" align="center" valign="top">
                    <table width="165" height="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td height="28" background="images/main_40.gif">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="19%">&nbsp;</td>
                                        <td width="81%" height="20"><span class="STYLE1">管理菜单</span></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="navgation" data-options="fit:true,border:false">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td height="18" background="images/main_58.gif">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td height="18" valign="bottom">
                                            <div align="center" class="STYLE1" style="font-family: Arial;">Copyright &copy; Fun Lt</div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                </td>
                <td style="width: 6px;" valign="middle" bgcolor="1873aa" onclick="switchSysBar()">
                    <span class="navPoint"
                        id="switchPoint" title="关闭/打开左栏">
                        <img src="images/main_55.gif" name="img1" width="6" height="40" id="img1" /></span>
                </td>

            </tr>
        </table>
    </div>
    <div data-options="region:'center',border:false" style="overflow-y: hidden">
        <iframe src="right.aspx" name="I2" id="I2" frameborder="0" style="border: 0; width: 100%; height: 100%;"></iframe>
    </div>
    <div data-options="region:'east',border:false" style="width: 2px; background: #1873aa; overflow: hidden;">
    </div>
</body>
</html>
