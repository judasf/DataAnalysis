<%@ Page Language="C#" %>

<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%--引入Jquery文件--%>
    <script src="Script/easyui/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="Script/easyui/jquery.easyui.min.js" type="text/javascript"></script>
    <%--引入easyui文件--%>
    <link href="Script/easyui/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="Script/easyui/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="Script/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
    <script src="Script/extJquery.js" type="text/javascript"></script>
    <script src="Script/extEasyUI.js" type="text/javascript"></script>
    <style>
        body { margin: 0; padding: 0; }
        .STYLE1 { font-size: 13px; color: #FFFFFF; }
        .STYLE3 { font-size: 12px; color: #033d61; }
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
                    $.messager.alert("error", result.msg, "error");
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
            function addTab(params) {
                $("#I2", parent.document.body).attr("src", params.url);
                //var iframe = '<iframe src="' + params.url + '" frameborder="0" style="border:0;width:100%;height:98%;" name="' + params.iframeName + '"></iframe>';
            }
        });
    </script>
</head>
<body>
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
                            <div align="center" class="STYLE1" style="font-family: Arial;">Copyright &copy; 安阳市联通公司</div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
