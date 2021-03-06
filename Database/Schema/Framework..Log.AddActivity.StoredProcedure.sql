SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Framework.].[Log.AddActivity]
	@userId int,
	@personId int = null,
	@subjectId bigint = null, 
	@methodName varchar(255),
	@property varchar(255),
	@propertyID bigint = null,
	@privacyCode int,
	@param1 varchar(255),
	@param2 varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@personId is null)
	BEGIN
		select @personID = InternalID from [RDF.Stage].InternalNodeMap  where class = 'http://xmlns.com/foaf/0.1/Person' and nodeID = @subjectId
	END
	IF (@property is null)
	BEGIN
		select @property = value from [RDF.].Node where NodeID = @propertyID
	END
	INSERT INTO [Framework.].[Log.Activity] (userId, personId, methodName, property, privacyCode, param1, param2) 
		VALUES(@userId, @personId, @methodName, @property, @privacyCode, @param1, @param2)
END
GO
