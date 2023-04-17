TableDOMModel.prototype.insertRowInDOM(index,templateTRId)
{
var tblBody = this.getTBody();
]var trEl = document.createElement("tr");
this.modifyTR(data,trEl,templateTRId);
trEl.setAttribute("rowidx",this.getRowCount());
tblBody.appendChild(tblBody);
this.add(trEl);
}
TableDOMModel.prototype.modifyRowInDOM(index,templateTRId)
{
var tblBody = this.getTBody();
var trEl = document.createElement("tr");
this.modifyTR(data,trEl,templateTRId);
trEl.setAttribute("rowidx",this.getRowCount());
tblBody.appendChild(trEl);
this.add(trEl);
}
TableDOMModel.prototype.modifyTREl(data,trEl,templateTRId)
{
var tplEl = document.getElementById(templateTRId);
trEl.innerHTML = tplEl.innerHTML;
var subEls = DOMUtils.getChildElsWithAttr(trRow,"name","*");
var dataMap = new Object();
for(var i =0;i< data.length
DOMUtils.fillData(subEls,data);
}
