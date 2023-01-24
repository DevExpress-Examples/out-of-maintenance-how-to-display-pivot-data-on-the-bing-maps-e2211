<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.ASPxPivotGrid.v13.1, Version=13.1.14.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
	Namespace="DevExpress.Web.ASPxPivotGrid" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v13.1, Version=13.1.14.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
	Namespace="DevExpress.Web" TagPrefix="dx" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Untitled Page</title>

	<script type="text/javascript">  
<!--
		// It is necessary to include a Bing Maps script file using the document.write method to produce valid XHTML markup.
		document.write('<scr' + 'ipt charset="UTF-8" type="text/javascript" src="' + 
			'http://ecn.dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=6.2&mkt=en-us' + '"></scr' + 'ipt>'); 
//-->
	</script>

	<script type="text/javascript">
		function SalesMap(mapContainerId, loadingPanel) {
			// Create a new map.
			this.map = new VEMap(mapContainerId);
			this.map.LoadMap();

			// Link to the loading panel.
			this.loadingPanel = loadingPanel;

			// The currently displayed country. This field will be accessed via the VEMap.Find method's callback function.
			this.displayingCountry = null;

			// The sales per country dictionary.
			this.salesPerCountry = null;

			// This method iterates through the sales dictionary.
			this.getNextCountry = function(country) {
				var found = false;
				for(name in this.salesPerCountry) {
					if(name == country) {
						found = true;
						continue;
					}
					if(found || country == null) 
						return name;
				}
				return null;
			}

			// VEMap.Find method's callback function.
			this.findCallback = function(layer, resultsArray, places, hasMore, veErrorMessage)
			{
				// The previously saved '_owner' variable is used instead of 'this' because 
				// the findCallback method is executed in the Bing object context and  
				// 'this' isn't a valid reference to the SalesMap object.
				var owner = layer._owner;

				// Get sales for the current country from the sales dictionary.
				var sales = owner.salesPerCountry[owner.displayingCountry];               

				// Create a pushpin indicator.
				var place = places[0];
				var shape = new VEShape(VEShapeType.Pushpin, place.LatLong);
				shape.SetTitle(owner.displayingCountry);
				shape.SetDescription(owner.displayingCountry + ' sales: ' + sales + ' pieces');
				layer.AddShape(shape);            

				// Set next country...
				owner.displayingCountry = owner.getNextCountry(owner.displayingCountry);
				if(owner.displayingCountry != null) {
					// ...and locate it
					owner.findCountry(layer);
				} else {
					// ...or exit if all countries are alreay located.

					// Best fit the map to show all pushpins.
					rect = layer.GetBoundingRectangle();                    
					owner.map.SetMapView(rect);

					// Hide the loading panel.
					owner.loadingPanel.Hide();

					// Free sales dictionary.
					owner.salesPerCountry = null;
					owner.displayingCountry = null;
				}
			}

			this.findCountry = function(layer) {
				this.map.Find(
					null,                   // The business name, category, or another item, for which the search is conducted. Set to null since we don't find for any business in this demo.
					this.displayingCountry, // The address or place name of the area, for which the search is conducted. Set to country name.
					VEFindType.Businesses,  // A VEFindType Enumeration value that specifies the type of the performed search. The only currently supported value is VEFindType.Businesses.
					layer,                  // A reference to the VEShapeLayer Class object, which contains the pins that result from this search if a what parameter is specified. We need this to provide the layer into the callback function since we create pushpins manually.
					0,                      // The starting index of returned results. 
					1,                      // The number of results to be returned, starting at startIndex. In this demo we need only one result.
					false,                  // A Boolean value that specifies whether the resulting pushpins are visible. Set to false to create pushpins manually.
					false,                  // A Boolean value that specifies whether pushpins are created when a what parameter is supplied. Set to false.
					false,                  // A Boolean value that specifies whether the map control displays a disambiguation box when multiple location matches are possible. Set to false since we don't need an end-user interaction.
					false,                  // A Boolean value that specifies whether the map control moves the view to the first location match. Set to false since multiple results look ugly.
					this.findCallback       // The function that the server calls with the search results.
				);
				// Complete VEMap.Find method's reference can be found here: http://msdn.microsoft.com/en-us/library/bb429645.aspx                
			}

			this.ShowMap = function(salesPerCountry) {
				// Save sales dictionary in a class variable to access it later.
				this.salesPerCountry = salesPerCountry;

				// Display the loading panel.
				this.loadingPanel.ShowInElement(document.getElementById(mapContainerId));

				// Delete existing shape layers from previous ShowMap method calls.
				this.map.DeleteAllShapeLayers();

				// Create a new shape layer for pushpins indicators.
				var layer = new VEShapeLayer();
				this.map.AddShapeLayer(layer);
				layer._owner = this;    // See a remark above about 'this' statement.

				// Select the first country to locate. We store its name in the class variable 
				// since we need to access it from the findCallback function.
				this.displayingCountry = this.getNextCountry(null);

				// Locate the first country. We have to find countries one-by-one since the VEMap.Find method is
				// asynchrous and doesn't accept simultaneous requests. We query the first country, wait for a
				// callback and locate the next country from the callback function.
				this.findCountry(layer);
			}            
		}
	</script>
</head>
<body>
	<form id="form1" runat="server">
		<div>
			<dx:ASPxPageControl ID="ASPxPageControl1" runat="server" ActiveTabIndex="0">
				<TabPages>
					<dx:TabPage Name="tabPivot" Text="ASPxPivotGrid">
						<ContentCollection>
							<dx:ContentControl runat="server">
								<dx:ASPxPivotGrid runat="server" ID="ASPxPivotGrid1" ClientInstanceName="ASPxPivotGrid1"
									Width="800px" DataSourceID="AccessDataSource1" OnCustomJsProperties="ASPxPivotGrid1_CustomJsProperties">
									<Fields>
										<dx:PivotGridField ID="fieldCountry" Area="ColumnArea" AreaIndex="0" FieldName="Country">
										</dx:PivotGridField>
										<dx:PivotGridField ID="fieldProductName" Area="RowArea" AreaIndex="0" FieldName="ProductName">
										</dx:PivotGridField>
										<dx:PivotGridField ID="fieldQuantity" Area="DataArea" AreaIndex="0" FieldName="Quantity">
										</dx:PivotGridField>
									</Fields>
									<OptionsCustomization AllowDrag="False" />
									<OptionsView ShowHorizontalScrollBar="True" />
								</dx:ASPxPivotGrid>
								<asp:AccessDataSource ID="AccessDataSource1" runat="server" DataFile="~/App_Data/nwind.mdb"
									DataSourceMode="DataReader" SelectCommand="SELECT [Country], [ProductName], [Quantity] FROM [Invoices]" />
							</dx:ContentControl>
						</ContentCollection>
					</dx:TabPage>
					<dx:TabPage Name="tabMap" Text="Bing Maps">
						<ContentCollection>
							<dx:ContentControl runat="server">
								<dx:ASPxLoadingPanel ID="loadingPanel1" ClientInstanceName="loadingPanel1" runat="server" />
								<div id="salesMapDiv" style="position: relative; width: 800px; height: 400px;" />
								<script type="text/javascript">
									var salesMap = null;
								</script>
							</dx:ContentControl>
						</ContentCollection>
					</dx:TabPage>
				</TabPages>
				<ClientSideEvents ActiveTabChanged="function(s, e) {
	if(e.tab.name != 'tabMap') return;

	// Create a SalesMap class instance, if necessary.
	if(salesMap == null)
		salesMap = new SalesMap('salesMapDiv', loadingPanel1);

	// Display a sales map.
	salesMap.ShowMap(ASPxPivotGrid1.cpCountrySales);
}"></ClientSideEvents>
			</dx:ASPxPageControl>
		</div>
	</form>
</body>
</html>