import com.adventnet.authentication.AAAUSER;
import com.adventnet.authentication.AAALOGIN;
import com.adventnet.authentication.AAAPASSWORD;
import com.adventnet.authentication.AAAACCOUNT;
import com.adventnet.authentication.AAAACCPASSWORD;
import com.adventnet.authentication.AAAACCOWNERPROFILE;
import com.adventnet.authentication.AAAAUTHORIZEDROLE;
import com.adventnet.authentication.PasswordException;
import com.adventnet.authentication.util.AuthUtil;
import com.adventnet.persistence.DataAccessException;
import com.adventnet.persistence.DataObject;
import com.adventnet.persistence.Row;
import com.adventnet.mfw.bean.BeanUtil;
import com.adventnet.persistence.Persistence;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;



public class Admin_addpeople extends HttpServlet{
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{

// Extract form data
String userName= req.getParameter("userName");
String userEmail= req.getParameter("userEmail");
String userID= req.getParameter("userID");
String userPassword = req.getParameter("userPassword");
String serviceName = "System";
String accAdminProfile = "Profile 1";
String passwordProfile = "Profile 1";

PrintWriter out = res.getWriter();

try{
    Persistence persistence = (Persistence) BeanUtil.lookup("Persistence");
    DataObject dobj=persistence.constructDataObject();
    Row userRow = new Row("AaaUser");
    userRow.set("NAME",userName);
    userRow.set("EMAIL",userEmail);
    dobj.addRow(userRow);
    
    Row loginRow = new Row("AaaLogin");
    loginRow.set("USER_ID",userID);
    dobj.addRow(loginRow);

    Row accRow= new Row("AaaAccount");
    accRow.set(AAAACCOUNT.SERVICE_ID,AuthUtil.getServiceId(serviceName));
    accRow.set(AAAACCOUNT.ACCOUNTPROFILE_ID,AuthUtil.getAccountProfileId(accAdminProfile));
    dobj.addRow(accRow);

    Row passwordRow = new Row("AaaPassword");
	passwordRow.set("PASSWORD", userPassword);
	passwordRow.set("PASSWDPROFILE_ID", AuthUtil.getPasswordProfileId(passwordProfile));
	dobj.addRow(passwordRow);


    Row accPassRow = new Row("AaaAccPassword");
    accPassRow.set("ACCOUNT_ID", accRow.get("ACCOUNT_ID"));
	accPassRow.set("PASSWORD_ID", passwordRow.get("PASSWORD_ID"));
	dobj.addRow(accPassRow);

    Row authPeople = new Row("AaaAuthorizedRole");
    authPeople.set("ACCOUNT_ID",accRow.get("ACCOUNT_ID"));
    authPeople.set("ROLE_ID",AuthUtil.getRoleId("CUSTOMER"));
    dobj.addRow(authPeople);

    AuthUtil.createUserAccount(dobj);
    out.println("Account created Successfully !");

}
catch(PasswordException pe){
    out.println("User creation failed!!!");
			pe.printStackTrace();
}
catch(DataAccessException dae)
		{	
			out.println("User creation failed!!!");
			dae.printStackTrace();
		}

        catch(Exception e)
		{	
			out.println("User creation failed!!!");
			e.printStackTrace();
		}



}
}