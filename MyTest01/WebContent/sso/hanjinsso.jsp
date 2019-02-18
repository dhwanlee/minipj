<%@ page import="javax.servlet.http.*" %>
<%--@ include file="/include/wisehub_common.jsp"--%>
<%
	session = request.getSession(true);
	request.getSession().setAttribute("sso", "hanjinsso");
	String url = request.getParameter("urls");
	if (url == null) url = "";
%>
<%@page import="sun.misc.BASE64Decoder"%>
<%@page import="java.security.Security"%>
<%@page import="javax.crypto.spec.SecretKeySpec"%>
<%@page import="javax.crypto.spec.IvParameterSpec"%>
<%@page import="javax.crypto.Cipher"%>
<%@page import="javax.crypto.IllegalBlockSizeException"%>
<%@page import="javax.crypto.BadPaddingException"%>
<%@page import="java.security.InvalidKeyException"%>
<%@page import="java.security.InvalidAlgorithmParameterException"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="javax.crypto.NoSuchPaddingException"%>
<%--@page import="org.bouncycastle.jce.provider.BouncyCastleProvider"--%>
<%!
public String decodeString(String sabun)
{
    byte plainText[] = (byte[])null;
    String rst = null;
    try
    {
        BASE64Decoder dn = new BASE64Decoder();
        plainText = dn.decodeBuffer(sabun);									//BASE64 DECODE
    }     
    catch(Exception exception) 
    { 
    }
    try{
		//Security.addProvider(new BouncyCastleProvider());
    }
    catch(Exception e)
    {
    	e.printStackTrace();
    }
	
	byte[] keyBytes = new byte[] { 0x68,0x32,0x68,0x30,0x69,0x31,0x63,0x35 };
	byte[] ivBytes  = new byte[] { 0x68,0x32,0x68,0x30,0x69,0x31,0x63,0x35 };
	SecretKeySpec key = new SecretKeySpec(keyBytes, "DES");
	IvParameterSpec ivSpec = new IvParameterSpec(ivBytes);
	
	Cipher desCipher;
	try {
		desCipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
		try {
			desCipher.init(Cipher.DECRYPT_MODE,key,ivSpec);
			try {
				byte[] byteDecryptedText = desCipher.doFinal(plainText);	//DES DECODE
				rst = new String(byteDecryptedText);
			} catch (IllegalStateException e) {
				rst = "100";
			} catch (IllegalBlockSizeException e) {
				rst = "200";
			} catch (BadPaddingException e) {
				rst = "300";
			}
		} catch (InvalidKeyException e) {
			rst = "400";
		} catch (InvalidAlgorithmParameterException e) {
			rst = "500";
		}
	} catch (NoSuchAlgorithmException e) {
		rst = "600";
	} catch (NoSuchPaddingException e) {
		rst = "700";
	}

    return rst;
}
%>
<html>
<head>
<title>hanjinsso2</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" href="/kr/css/body.css" type="text/css">
</head>
<script>
	function goSSo() {
		<% if ("".equals(url)) { %>
			//alert('sso2.jsp');
			document.forms[0].action='/sso.jsp'
		<% } else { %>
			//�ϵ��ޱ⼺���û�� ��ũ �Ʒ��� �̵�
			document.forms[0].action='<%=url%>'
		<% } %>

		//alert('���� �غ���!');
		//window.close();
		//return;


		document.forms[0].method = 'POST';
		document.forms[0].submit();
	}	
</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1">
<input type="hidden" name="sso" value="hanjinsso">
<%
    //sso.GWSso2 Osso2 = new sso.GWSso2();
	//wise.ses.WiseInfo info = null;

    String type     = request.getParameter("type");

    // �Ǽ� : p_emp_no
    // userid
    // type CC


	String new_emp_no  = "";
	String new_type    = "";

	if ((type != null) && (type.length() == 2)) {
		new_type = type.substring(0,1);
	} else {
		new_type = type;
	}

    String emp_no      = "C".equals(new_type) ? request.getParameter("p_emp_no") : request.getParameter("userid");
    String head_emp_no = "";	//20150506 WJKIM ������ �Ǽ������ �߰�
    if (emp_no == null) emp_no = request.getParameter("emp_no");

	System.out.println("0dddd===========================================emp_no==="+emp_no);

	String real_company_code = "";

	if ("S".equals(new_type)) {
		real_company_code="hsa";
	} else if ("C".equals(new_type)) {
		real_company_code="hca";
	} else if ("K".equals(new_type)) {
		real_company_code="kka";
	} else if ("D".equals(new_type)) {
		real_company_code="dda";
	}
	System.out.println("0===========================================real_company_code==="+real_company_code);
	System.out.println("0===========================================emp_no==="+emp_no);
	if (!"".equals(url)) {				//�󼼳��� ��ư�� Ŭ���� ��� ����� 2020204		
		emp_no = decodeString(emp_no);	//emp_no = Osso2.decodeString(emp_no);
	} else {							//�׷���� ��ũ�� �α׿� hca2020204		
		emp_no = decodeString(emp_no);	//emp_no = Osso2.decodeString(emp_no);
		int lenEmpno = emp_no.length();	
		head_emp_no = emp_no.substring(0,3).toString();		//20150506 WJKIM ������ �Ǽ������ �߰�
		emp_no = emp_no.substring(3,lenEmpno).toString();	//ȸ�縶�� ������̰� �ٸ��Ƿ� ��ü���̸� Ȯ��
		if ("hsa".equals(real_company_code))	//20150506 WJKIM ������ �Ǽ������ �߰�
		{
			if ("HCA".equals(head_emp_no))
			{
				emp_no = "C"+emp_no.substring(1,7).toString();
			}
		}								//20150506 WJKIM ������ �Ǽ������ �߰�
	}
	System.out.println("1===========================================emp_no==="+emp_no);
	System.out.println("2===========================================type  ==="+type);
	//emp_no = Osso2.webDecrypt(emp_no,new_type);
	//emp_no = emp_no+' '+new_type+' '+real_company_code;	//'Pi?BJUJ C hca'	//emp_no = "2040081";
	System.out.println("2===========================================emp_no==="+emp_no);

	if (type.length() == 2) {
		String first_char  = type.substring(0,1);
		String second_char = type.substring(1,2);

		if (first_char.equals(second_char)) {
			new_emp_no = emp_no;
		} else {
			new_emp_no = second_char + emp_no;
		}
	} else {
		new_emp_no = emp_no;
	}

    String COMPANY_NAME_LOC;
	String USER_ID;
    String nickName2 = "p0030";
	String conType2 = "CONNECTION";
	String MethodName2 = "getHanjinSSO";
	WiseOut value2 = null;
	WiseRemote ws2 = null;
	try {
	ws2 = new WiseRemote(nickName2, conType2, new WiseInfo("100","ID=IF ^@^LANGUAGE=KO^@^COMPANY_CODE=D10^@^EMPLOYEE_NO=9999999^@^NAME_LOC=INTERFACE^@^NAME_ENG=INTERFACE^@^DEPARTMENT_NAME_LOC=ALL^@^DEPARTMENT=ALL^@^PLANT_CODE=ALL^@^CTRL_CODE=ALL^@^"));
//	String[] args = { emp_no,type };
	String[] args = { new_emp_no, new_type };

    Object[] object = {(Object[])args};
	value2 = ws2.lookup(MethodName2, object);
	if(value2.status == 1) {
		WiseFormater wf = new WiseFormater(value2.result[0]);
		//passwd = wf.getValue(0,0);
		int iRowCount = wf.getRowCount();

		if (!"".equals(url) && iRowCount !=0) {
			session = request.getSession(true);
			session.setAttribute("HOUSE_CODE","100");
			session.setAttribute("ID",emp_no);
			session.setAttribute("COMPANY_CODE",type);
			session.setAttribute("USER_TYPE","B");
		}
		if (iRowCount>1){  %>
		<script>winObj=self;
		winObj.moveTo(screen.width/2-100,screen.height/2-90);
		winObj.resizeTo(200,180);</script>
		<table>
		<tr><td>
			<select name="userid" class="input_re">
				<%
				for(int i=0;i<iRowCount;i++) {
				%>
				<option value="<%=wf.getValue("USER_ID",i)%>"><%=wf.getValue("COMPANY_NAME_LOC",i)%></option>
				<%}
				%>
			</select></td><td>
			<input type="hidden" name="hanjin_company" value="<%=real_company_code%>">
			<script language="javascript">btn("javascript:goSSo()",1,"�α���")   </script>
		</td></tr>
		</table>
<%		}else if (iRowCount==1){%>
			<input type="hidden" name="userid" value="<%=wf.getValue("USER_ID",0)%>">
			<input type="hidden" name="hanjin_company" value="<%=real_company_code%>">
			<script>goSSo();</script>
<%		}else {%>
			<script>
				alert('�α��� �Ұ�');
				location.href = "/index.htm";
			</script>
<%
		}
	}
	} catch (Exception e) {
		Logger.err.println("e.getMessage = " + e.getMessage());
	} finally {
		try {
			ws2.Release();
		} catch (Exception exception1) {
		}
	}
%>
</form>
</body>
</html>