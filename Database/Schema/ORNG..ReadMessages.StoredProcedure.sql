SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadMessages](@RecipientUri nvarchar(255),@Coll nvarchar(255), @MsgIDs nvarchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @RecipientNodeID bigint
	DECLARE @baseURI nvarchar(255)
	DECLARE @sql nvarchar(255)
	
	select @RecipientNodeID = [RDF.].[fnURI2NodeID](@RecipientUri)
	select @baseURI = [Value] FROM [Framework.].[Parameter] WHERE ParameterID = 'baseURI';
	
	SET @sql = 'SELECT MsgID, Coll, Body, Title, ''' + @baseURI  + '''+ SenderNodeID , ''' + @baseURI + '''+ RecipientNodeID ' +
		'FROM [ORNG.].[Messages] WHERE RecipientNodeID = ' + @RecipientNodeID
	IF (@Coll IS NOT NULL)
		SET @sql = @sql + ' AND Coll = ''' + @Coll + '''';
	IF (@MsgIDs IS NOT NULL)
		SET @sql = @sql + ' AND MsgID IN ' + @MsgIDs
		
	EXEC @sql;
END

GO
