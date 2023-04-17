<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${i18n.title}</title>
        <script type="text/javascript" src="http://js.zohostatic.com/common/js/jquery/1.3.2/jquery.min.js"></script>
	 <link type="text/css" href="/accounts/css/signin.css" rel="stylesheet" />
	<!--ZOHO_ACCOUNTS_TEMPLATE-->
    </head>
   <body>
        <table border="0">
            <tr>
                <td width="25px"></td><td colspan="2"> <span id="headerAcc"></span></td><td width="25px"></td>
            </tr>
            <tr>
                <td></td>
                <td   width="60%" >
                    <div class="floatl" style="margin-top:-85px;">
                        <div class="pspace">
                            <div class="prioritize" ></div><font class="phead">${i18n.prioritizehead}</font>
                            <p class="ptxt"> ${i18n.prioritizedesc}
                        </div>
                        <div class="pspace">
                            <div class="contracts"></div><font class="phead">${i18n.contractshead}</font>
                            <p class="ptxt">${i18n.contractsdesc}</p>
                        </div>
                        <div class="pspace">
                            <div class="measure"></div><font class="phead">${i18n.measurehead}</font>
                            <p class="ptxt">${i18n.measuredesc}</p>
                        </div>
                    </div>
                <td class="floatr"><div id="logindiv" class="login"></div>
                    <p class="ptxt" style="margin-left:70px;"> ${i18n.noZohoAcc}&nbsp;&nbsp;<input type="button" onclick="document.location='/accounts/register'" class="signupbut" Value="Sign Up Now" ></p>
                </td>
                <td></td>

            </tr>
            <tr>
                <td colspan="4"><span id="footerAcc"></span></td>
            </tr>
        </table>
    </body>
</html>
