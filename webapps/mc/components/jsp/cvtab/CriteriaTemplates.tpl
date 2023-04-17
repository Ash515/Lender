<%-- $Id$ --%>


<!--TPL-start-CriteriaTemplates--> 

<script language="javascript" src="${Context_Path}/components/javascript/calendar.js"></script>
<script language="javascript" src="${Context_Path}/components/javascript/calendar-en.js"></script>
<script language="javascript" src="${Context_Path}/components/javascript/calendar-setup.js"></script>

<div style="display:none">
    <table>
        <tbody>

            <tr id="PREFIX">
                <td class="crMatchValTD">        
                    <div hideforfirst="true" style="width:100%;text-align:right" name="MATCHVAL" fixedname="true"></div><input type="hidden" fixedname="true" name="ROWIDX" value=""/>
                </td>   
                <td>
                    <select name="COLNAME" function="colChanged"  onchange="Criteria.invoke(this);"></select>
                </td>

            </tr>
  
            <tr id="SUFFIX">
                <td> 
                    <div nullhide="true" name="UNIT"></div>
                </td>
                <td width="30px">
                    <input type="button" value="Close" name="DELETECR" hideforfirst="true" function="deleteRow" onclick="Criteria.invoke(this);"   class="crDeleteBtn"/>
                </td>
                <td>
                   <div name="COLVALUEID"></div>
                </td>
            </tr>


            <tr id="CHAR_CRDEF">
                <td>
                    <select name="COMPARATOR" class="charclass" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);">
                        <OPTION VALUE="12">${contains}</OPTION>
                        <OPTION VALUE="13">${doesn't contain}</OPTION>
                        <OPTION VALUE="11">${ends with}</OPTION>
                        <OPTION VALUE="10">${starts with}</OPTION>
                        <OPTION VALUE="0">${is}</OPTION>
                        <OPTION VALUE="1">${isn't}</OPTION>
                    </select>
                </td>

                <td>
                    <input nullhide="true" name="COLVALUE" class="crTxtFld" type="text" errormsg="Please specify the search criteria" isnullable="false" validatemethod="isNotEmpty">
                </td>
                
            </tr>

        </tr><tr id="FLOAT_CRDEF">
                <td><select name="COMPARATOR" class="floatclass" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);">
                        <OPTION VALUE="0">${is}</OPTION>
                        <OPTION VALUE="1">${isn't}</OPTION>
                        <OPTION VALUE="5">${is higher than}</OPTION>
                        <OPTION VALUE="7">${is lower than}</OPTION>
                    </select>
                    <td>
                        <input nullhide="true" name="COLVALUE" class="crTxtFld" type="text">
                    </td>
            </tr>
            <tr id="INTEGER_CRDEF" >
                <td><select name="COMPARATOR" class="integerclass"onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);">
                        <OPTION VALUE="0">${is}</OPTION>
                        <OPTION VALUE="1">${isn't}</OPTION>
                        <OPTION VALUE="5">${is higher than}</OPTION>
                        <OPTION VALUE="7">${is lower than}</OPTION>
                    </select>
                </td>
                <td>
                    <input nullhide="true" name="COLVALUE" class="crTxtFld" type="text" errormsg="Please specify a valid number" isnullable="false" validatemethod="isInteger">
                </td>
                
            <tr id="DATE_CRDEF">
                <td><select class="dateclass" name="COMPARATOR" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);">
                        <OPTION VALUE="0">${is}</OPTION>
                        <OPTION VALUE="1">${isn't}</OPTION>
                        <OPTION VALUE="5">${is after}</OPTION>
                        <OPTION VALUE="7">${is before}</OPTION>
                    </select>
                </td>
                <td>
                   <input nullhide="true" name="COLVALUE" type="text" value="" class="crDateTxtFld" errormsg="Please specify a valid date" isnullable="false" validatemethod="isDate" isnullable="false"/> <input nullhide="true" type="button"    onupdatefunc="Criteria.displayCalendar(this);" class="crDateBtn">
                </td>                
            </tr>

<tr id="DATEASLONG_CRDEF">                                                                                                            <td><select name="COMPARATOR" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);">                                                                                                                                                  <OPTION VALUE="54">is</OPTION>                                                                                               <OPTION VALUE="55">is not</OPTION>                                                                                            <OPTION VALUE="45">is after</OPTION>                                                                                         <OPTION VALUE="47">is before</OPTION>                                                                                    </select>                                                                                                               </td>                                                                                                                       <td>                                                                                                                           <input  name="COLVALUE" type="text" value="" class="crDateTxtFld" errormsg="Please specify a valid date" isnullable="false" nullhide="true" validatemethod="isDate" isnullable="false"/> </td><td><input  nullhide="true"  type="button"   onupdatefunc="Criteria.displayCalendar(this);" class="crDateBtn">                                                                               </td>                                                                                                                   </tr>

		
	<tr id="ALLOWEDSTRING_CRDEF">
                <td><select name="COMPARATOR" class="allowedstringclass" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);
">
                        <OPTION VALUE="0">${is}</OPTION>
                        <OPTION VALUE="1">${isn't}</OPTION>
                    </select>
		</td>	
                    <td>
                        <select  nullhide="true" name="COLVALUE" class="crTxtFld"></select>
                    </td>
            </tr>
            
            <tr id="ALLOWEDSTRING1_CRDEF">
                <td><select name="COMPARATOR" class="allowedstring1class" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);
">
                        <OPTION VALUE="0">${is}</OPTION>
                    </select>
		</td>	
                    <td>
                        <select  nullhide="true" name="COLVALUE" class="crTxtFld"></select>
                    </td>
            </tr>

		<tr id="ALLOWEDNUMERIC_CRDEF">
                <td><select name="COMPARATOR" class="allowednumericclass" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);
">
                        <OPTION VALUE="0">${is}</OPTION>
                        <OPTION VALUE="1">${isn't}</OPTION>
						<OPTION VALUE="5">${is higher than}</OPTION>
                        <OPTION VALUE="7">${is lower than}</OPTION>

                    </select>
                </td>
                    <td>
                        <select  nullhide="true" name="COLVALUE" class="crTxtFld"></select>
                    </td>
            </tr>


	<tr id="YESNOBOOLEAN_CRDEF">
		<td>
					<select class="yesnoclass" name="COMPARATOR" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);">
                        <OPTION VALUE="0">${is}</OPTION>
                        <OPTION VALUE="1">${isn't}</OPTION>
                    </select>
		</td>
                <td>
                      <input type="hidden" name="COMPARATOR" value="0"/>
                      <select name="COLVALUE" class="yesnovalueclass">
                        <OPTION VALUE="1">${Yes}</OPTION>
                        <OPTION VALUE="0">${No}</OPTION>
                    </select>
                </td>
                    <td>
                    </td>
            </tr>
	
	<tr id="TFBOOLEAN_CRDEF">
	<td>
					<select class="truefalseclass" name="COMPARATOR" onupdatefunc="Criteria.handleNull" onchange="Criteria.handleNull(this);">
                        <OPTION VALUE="0">${is}</OPTION>
                        <OPTION VALUE="1">${isn't}</OPTION>
                    </select>
                <td>
                      <input type="hidden" name="COMPARATOR" value="0"/>
                      <select name="COLVALUE" class="tfvalueclass">
                        <OPTION VALUE="1">${True}</OPTION>
                        <OPTION VALUE="0">${False}</OPTION>
                    </select>
                </td>
                    <td>
                    </td>
            </tr>

        </tbody>
    </table>
</div>


<!--TPL-end-CriteriaTemplates--> 