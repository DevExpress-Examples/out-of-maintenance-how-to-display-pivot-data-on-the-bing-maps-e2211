Imports Microsoft.VisualBasic
Imports System
Imports System.Data
Imports System.Configuration
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls
Imports System.Collections.Generic
Imports DevExpress.Web.ASPxClasses

Partial Public Class _Default
	Inherits System.Web.UI.Page
	Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
		If IsPostBack And Not IsCallback Then
	            		ASPxPivotGrid1.DataBind()
		End If
	End Sub
	Protected Sub ASPxPivotGrid1_CustomJsProperties(ByVal sender As Object, ByVal e As CustomJSPropertiesEventArgs)
		e.Properties.Add("cpCountrySales", GetCountrySales())
	End Sub

	Private Function GetCountrySales() As Dictionary(Of String, Decimal)
		Dim res As New Dictionary(Of String, Decimal)()
		Dim isColumn As Boolean = fieldCountry.IsColumn
		Dim count As Integer
		If isColumn Then
			count = ASPxPivotGrid1.ColumnCount
		Else
			count = ASPxPivotGrid1.RowCount
		End If
		For i As Integer = 0 To count - 1
			Dim country As String = CStr(ASPxPivotGrid1.GetFieldValue(fieldCountry, i))
			If String.IsNullOrEmpty(country) Then
				Continue For
			End If
			Dim value As Decimal
			If isColumn Then
				If isColumn Then
					value = Convert.ToDecimal(ASPxPivotGrid1.GetCellValue(i,ASPxPivotGrid1.RowCount - 1))
				Else
					value = Convert.ToDecimal(ASPxPivotGrid1.GetCellValue(i,i))
				End If
			Else
				If isColumn Then
					value = Convert.ToDecimal(ASPxPivotGrid1.GetCellValue(ASPxPivotGrid1.ColumnCount - 1,ASPxPivotGrid1.RowCount - 1))
				Else
					value = Convert.ToDecimal(ASPxPivotGrid1.GetCellValue(ASPxPivotGrid1.ColumnCount - 1,i))
				End If
			End If
			res.Add(country, value)
		Next i
		Return res
	End Function
End Class
