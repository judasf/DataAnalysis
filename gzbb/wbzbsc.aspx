<%@ Page Language="C#" AutoEventWireup="true" CodeFile="wbzbsc.aspx.cs" Inherits="gzbb_wbzbsc" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>工作报表管理</title>
        <link type="text/css" href="../css/style.css"   rel="Stylesheet"/>

</head>
<body>
    <form id="form1" runat="server">
    <div id="content">
      <p class="sitepath">
            <b>当前位置：</b>工作报表管理 > <a href="wbzbsc.aspx">工作周报上传</a>
        </p>
        <br />
        <div>工作周报上传：
        <asp:FileUpload ID="FileUpload1" runat="server"  />
        <span class="btnp">            <asp:Button ID="upload" runat="server" Text="上传" 
                onclick="upload_Click" />
</span>
        </div>
    </div>
    </form>
</body>
</html>
