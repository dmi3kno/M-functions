let Table.addGroupedCumSum = (df as table, colname as text, newcolname as text, groupcolnames as list) as table=>
    let
        fnAddCumSum = (df as table, colname as text, newcolname as text) as table =>
        let
            Source = Table.Buffer(df),
            TableType = Value.Type(Table.AddColumn(Source, newcolname, each null, type number)),
            Cumulative = List.Accumulate(Table.Column(Source,colname),{},(cum,col) => cum & {List.Last(cum,0) + col}),
            NewColAdded = Table.FromColumns(Table.ToColumns(Source)&{Cumulative},TableType)
        in
            NewColAdded,
        TableType = Value.Type(Table.AddColumn(df, newcolname, each null, type number)),
        GroupedRows = Table.Group(df, groupcolnames, {{"AllData", each fnAddCumSum(_, colname, newcolname), TableType}}),
        ExpandedCols=Table.ExpandTableColumn(GroupedRows, "AllData", List.Difference(Table.ColumnNames(Table.Column(GroupedRows, "AllData"){0}), Table.ColumnNames(GroupedRows)))
    in
        ExpandedCols,
documentation = [
Documentation.Name =  " Table.addGroupedCumSum ",
Documentation.Description = " Adds column <code> newcolname </code> calculated as cumulative sum of values in <code>colname</code> grouped by column names listed in <code>groupcolnames</code>.  ",
Documentation.LongDescription = " Adds column <code> newcolname </code> calculated as cumulative sum of values in <code>colname</code> grouped by column names listed in <code>groupcolnames</code>.  ",
Documentation.Category = " Table ",
Documentation.Source = " .  . ",
Documentation.Version = " 1.0 ",
Documentation.Author = " Dmytro Perepolkin ,@dmi3kno . ",
Documentation.Examples = {[Description =  "  ",
    Code = " Table.addGroupedCumSum(mtcars, 'mpg', 'mpg_cum', {'cyl'}) ",
    Result = " table with new column <code>mpg_cum</code> added "]}]
  
 in  
  Value.ReplaceType(Table.addGroupedCumSum, Value.ReplaceMetadata(Value.Type(Table.addGroupedCumSum), documentation))