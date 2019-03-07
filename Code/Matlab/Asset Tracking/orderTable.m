function ordered_table = orderTable(asset_table)

anchor = [472995.326, 106020.104];
distance_from_anchor = sqrt((asset_table.XCOORD - anchor(1)).^2 + (asset_table.YCOORD - anchor(2)).^2);

asset_table = [asset_table, table(distance_from_anchor)];
ordered_table = sortrows(asset_table,'distance_from_anchor');
%ordered_table = removevars(ordered_table,{'distance_from_anchor'});
ordered_table.distance_from_anchor = [];
