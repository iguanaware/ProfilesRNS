SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [ORNG.].[ReadAppData](@Uri nvarchar(255),@AppID INT, @Keyname nvarchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @NodeID bigint
	
	SELECT @NodeID = [RDF.].[fnURI2NodeID](@Uri);

	SELECT Value from [ORNG.].AppData where AppID=@AppID AND NodeID = @NodeID AND Keyname = @Keyname
END

GO
