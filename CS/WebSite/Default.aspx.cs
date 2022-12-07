using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using DevExpress.Web;

public partial class _Default : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {
        if(IsPostBack && !IsCallback)
            ASPxPivotGrid1.DataBind();
    }
    protected void ASPxPivotGrid1_CustomJsProperties(object sender, CustomJSPropertiesEventArgs e) {
        e.Properties.Add("cpCountrySales", GetCountrySales());
    }

    Dictionary<string, decimal> GetCountrySales() {
        Dictionary<string, decimal> res = new Dictionary<string, decimal>();
        bool isColumn = fieldCountry.IsColumn;
        int count = isColumn ? ASPxPivotGrid1.ColumnCount : ASPxPivotGrid1.RowCount;
        for(int i = 0; i < count; i++) {
            string country = (string)ASPxPivotGrid1.GetFieldValue(fieldCountry, i);
            if(string.IsNullOrEmpty(country)) continue;
            decimal value = Convert.ToDecimal(
                ASPxPivotGrid1.GetCellValue(isColumn ? i : ASPxPivotGrid1.ColumnCount - 1,
                    isColumn ? ASPxPivotGrid1.RowCount - 1 : i));
            res.Add(country, value);
        }
        return res;
    }
}