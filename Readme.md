<!-- default badges list -->
![](https://img.shields.io/endpoint?url=https://codecentral.devexpress.com/api/v1/VersionRange/128577386/10.1.4%2B)
[![](https://img.shields.io/badge/Open_in_DevExpress_Support_Center-FF7200?style=flat-square&logo=DevExpress&logoColor=white)](https://supportcenter.devexpress.com/ticket/details/E2211)
[![](https://img.shields.io/badge/📖_How_to_use_DevExpress_Examples-e9f6fc?style=flat-square)](https://docs.devexpress.com/GeneralInformation/403183)
<!-- default badges end -->
<!-- default file list -->
*Files to look at*:

* [Default.aspx](./CS/WebSite/Default.aspx) (VB: [Default.aspx](./VB/WebSite/Default.aspx))
* [Default.aspx.cs](./CS/WebSite/Default.aspx.cs) (VB: [Default.aspx.vb](./VB/WebSite/Default.aspx.vb))
<!-- default file list end -->
# How to display pivot data on the Bing Maps


<p>The <strong>Bing Maps</strong>  service provides the capability to display sales reports on a map. The maps provide a <strong>JavaScript API</strong> to display maps, locate countries and businesses, and create pushpin indicators.</p><p>To send report data from the server to the client side, use the <strong>CustomJsProperties</strong> event.<br />
This event automatically serializes dictionary and list-typed property data, without any additional efforts.</p><p>These properties can be accessed on the client side as follows: <strong>[PivotGrid ClientInstanceName].[PropertyName]</strong></p><p>To display a sales report on a map, create a new instance of the <strong>SalesMap</strong> class and use<br />
the <strong>SalesMap.ShowMap</strong> method.</p>

<br/>


