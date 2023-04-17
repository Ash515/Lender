import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import com.adventnet.persistence.*;
import com.adventnet.ds.query.Criteria;
import java.sql.Date;

public class AddStudent extends HttpServlet{
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException{
		PrintWriter out = res.getWriter();
		 
		try{
			DataObject dataObject = new WritableDataObject();
			String name = req.getParameter("Name");
			Date dob = Date.valueOf(req.getParameter("Dob"));
			String dept = req.getParameter("Dept");
			String email = name.toLowerCase()+"@clgmail.com";
			
			Row r = new Row("Students");
			
			r.set(2, name);
			r.set(3, dob);
			r.set(4, dept);
			r.set(6, email);
			
			dataObject.addRow(r);
			DataAccess.add(dataObject);
			out.println("Records created sucessfully!!!");
		}
		catch(DataAccessException e){
			out.println("Error in creating records....Please try again");
			System.err.println("Error in Creating Records....Please try again");
			e.printStackTrace();
		}
	}
}